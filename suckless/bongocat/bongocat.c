// gcc a.c -lX11 -lXrender -lm -lXtst
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Xatom.h>
#include <X11/extensions/Xrender.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/mman.h>
#include <X11/XKBlib.h>
#include <X11/extensions/record.h>

#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"

int *any_key_pressed;

void key_pressed_cb(XPointer arg, XRecordInterceptData *d) {
    if (d->category != XRecordFromServer)
        return;
    
    int key = ((unsigned char*) d->data)[1];
    int type = ((unsigned char*) d->data)[0] & 0x7F;
    int repeat = d->data[2] & 1;

    if(!repeat) {
        switch (type) {
            case KeyPress:
                *any_key_pressed = 1;
                break;
            default:
                break;
        }
    }
    XRecordFreeData (d);
}

void scan() {
    XRecordRange* rr;
    XRecordClientSpec rcs;
    XRecordContext rc;
    Display *dpy = XOpenDisplay(NULL);
    rr = XRecordAllocRange();
    rr->device_events.first = KeyPress;
    rr->device_events.last = ButtonReleaseMask;
    rcs = XRecordAllClients;
    rc = XRecordCreateContext (dpy, 0, &rcs, 1, &rr, 1);
    XFree (rr);
    XRecordEnableContext(dpy, rc, key_pressed_cb, NULL);
}

int run() {
    Display* dpy = XOpenDisplay(NULL);
    if (!dpy) {
        fprintf(stderr, "Failed to open display\n");
        return 1;
    }

    int screen = DefaultScreen(dpy);
    Window root = RootWindow(dpy, screen);

    // Find a 32-bit TrueColor visual (ARGB)
    XVisualInfo vinfo;
    if (!XMatchVisualInfo(dpy, screen, 32, TrueColor, &vinfo)) {
        fprintf(stderr, "No 32-bit TrueColor visual available\n");
        return 1;
    }

    // Setup window attributes
    XSetWindowAttributes attrs;
    attrs.colormap = XCreateColormap(dpy, root, vinfo.visual, AllocNone);
    attrs.background_pixel = 0x00000000;
    attrs.border_pixel = 0;
    attrs.override_redirect = True;


    int screen_height = DisplayHeight(dpy, screen);
    int screen_width = DisplayWidth(dpy, screen);
    const int win_w = 100;
    const int win_h = 67;
    Window win = XCreateWindow(
        dpy, root,
        screen_width-win_w, screen_height-win_h, win_w, win_h,
        0, vinfo.depth, InputOutput, vinfo.visual,
        CWColormap | CWBackPixel | CWBorderPixel | CWOverrideRedirect,
        &attrs
    );

    XMapWindow(dpy, win);
    XRenderPictFormat* fmt = XRenderFindVisualFormat(dpy, vinfo.visual);
    Picture pict = XRenderCreatePicture(dpy, win, fmt, 0, NULL);
    XRenderColor background = {0, 0, 0, 0}; // transparant


    ///////////////////////////////
    // load image
    int img_w, img_h, img_channels;
    unsigned char* data_left = stbi_load("left.png", &img_w, &img_h, &img_channels, 4);
    if (!data_left) {
        fprintf(stderr, "Failed to load image\n");
        return 1;
    }
    unsigned char* data_right = stbi_load("right.png", &img_w, &img_h, &img_channels, 4);
    if (!data_right) {
        fprintf(stderr, "Failed to load image\n");
        return 1;
    }
    unsigned char* data_rest = stbi_load("rest.png", &img_w, &img_h, &img_channels, 4);
    if (!data_rest) {
        fprintf(stderr, "Failed to load image\n");
        return 1;
    }

    // fix cuz red and blue seem swapped...
    for (int i = 0, n = img_w * img_h; i < n; i++) {
        unsigned char r, g, b, a;

        unsigned char *px_left = data_left + 4*i;
        r = px_left[0]; g = px_left[1]; b = px_left[2]; a = px_left[3];
        px_left[0] = b;
        px_left[2] = r;

        unsigned char *px_right = data_right + 4*i;
        r = px_right[0]; g = px_right[1]; b = px_right[2]; a = px_right[3];
        px_right[0] = b;
        px_right[2] = r;

        unsigned char *px_rest = data_rest + 4*i;
        r = px_rest[0]; g = px_rest[1]; b = px_rest[2]; a = px_rest[3];
        px_rest[0] = b;
        px_rest[2] = r;
    }

    // Create Pixmap + XImage
    Pixmap img_pixmap = XCreatePixmap(dpy, win, img_w, img_h, vinfo.depth);
    XImage* ximage_left = XCreateImage(
        dpy, vinfo.visual, vinfo.depth, ZPixmap, 0,
        (char*)data_left, img_w, img_h, 32, 0
    );
    XImage* ximage_rest = XCreateImage(
        dpy, vinfo.visual, vinfo.depth, ZPixmap, 0,
        (char*)data_rest, img_w, img_h, 32, 0
    );
    XImage* ximage_right = XCreateImage(
        dpy, vinfo.visual, vinfo.depth, ZPixmap, 0,
        (char*)data_right, img_w, img_h, 32, 0
    );

    GC gc = XCreateGC(dpy, img_pixmap, 0, NULL);
    Picture img_picture = XRenderCreatePicture(dpy, img_pixmap, fmt, 0, NULL);
    ////////////////////////////////////


    while (1) {

        // Clear window to transparent
        XRectangle clear_rect = {0, 0, win_w, win_h};
        XRenderFillRectangles(dpy, PictOpSrc, pict, &background, &clear_rect, 1);

        if (*any_key_pressed == 1) {
            if (rand() % 2) {
                XPutImage(dpy, img_pixmap, gc, ximage_left, 0, 0, 0, 0, img_w, img_h);
            } else {
                XPutImage(dpy, img_pixmap, gc, ximage_right, 0, 0, 0, 0, img_w, img_h);
            }

            XRenderComposite(dpy, PictOpOver, img_picture, None, pict, 0, 0, 0, 0, 0, 0, 300, 300); 
            XFlush(dpy);
            usleep(100000);
            *any_key_pressed = 0;
        }

        XPutImage(dpy, img_pixmap, gc, ximage_rest, 0, 0, 0, 0, img_w, img_h);
        XRenderComposite(dpy, PictOpOver, img_picture, None, pict, 0, 0, 0, 0, 0, 0, 300, 300); 

        XFlush(dpy);
        usleep(16000);  
    }

    // Cleanup (never actually reached)
    XRenderFreePicture(dpy, pict);
    XCloseDisplay(dpy);
    return 0;
}

int main() {
    any_key_pressed = mmap(NULL, sizeof(int), 
                      PROT_READ | PROT_WRITE,
                      MAP_SHARED | MAP_ANONYMOUS,
                      -1, 0);
    if (fork()) {
        scan();
    } else {
        run();
    }
}
