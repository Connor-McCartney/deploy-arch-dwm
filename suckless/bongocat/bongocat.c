#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Xatom.h>
#include <X11/extensions/Xrender.h>
#include <stdio.h>
#include <unistd.h>
#include <time.h>
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

struct image_s {
    int img_w; 
    int img_h;
    XImage* ximage;
} typedef image_t;

image_t img_load(Display* dpy, XVisualInfo vinfo, char* path) {
    int img_w, img_h, img_channels;
    unsigned char* data = stbi_load(path, &img_w, &img_h, &img_channels, 4);
    if (!data) {
        fprintf(stderr, "Failed to load image\n");
        exit(1);
    }

    // fix cuz red and blue seem swapped...
    for (int i = 0, n = img_w * img_h; i < n; i++) {
        unsigned char r, g, b, a;
        unsigned char *px = data + 4*i;
        r = px[0]; g = px[1]; b = px[2]; a = px[3];
        px[0] = b;
        px[2] = r;
    }

    XImage* ximage = XCreateImage(
        dpy, vinfo.visual, vinfo.depth, ZPixmap, 0,
        (char*)data, img_w, img_h, 32, 0
    );

    image_t ret = {img_w, img_h, ximage};
    return ret;
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
    const int win_w = 600;
    const int win_h = 200;
    Window win = XCreateWindow(
        dpy, root,
//        screen_width-win_w, screen_height-win_h, win_w, win_h,
        0, screen_height-win_h, win_w, win_h,
        0, vinfo.depth, InputOutput, vinfo.visual,
        CWColormap | CWBackPixel | CWBorderPixel | CWOverrideRedirect,
        &attrs
    );

    XMapWindow(dpy, win);
    XRenderPictFormat* fmt = XRenderFindVisualFormat(dpy, vinfo.visual);
    Picture pict = XRenderCreatePicture(dpy, win, fmt, 0, NULL);
    XRenderColor background = {0, 0, 0, 0}; // transparant
    //XRenderColor background = {0, 0xffff, 0, 0xffff}; // transparant

    image_t cat_left = img_load(dpy, vinfo, "/home/connor/suckless/bongocat/left.png");
    image_t cat_right = img_load(dpy, vinfo, "/home/connor/suckless/bongocat/right.png");
    image_t cat_rest = img_load(dpy, vinfo, "/home/connor/suckless/bongocat/rest.png");
    image_t kuromi_sitting = img_load(dpy, vinfo, "/home/connor/suckless/bongocat/kuromi_sitting.png");
    image_t cinna = img_load(dpy, vinfo, "/home/connor/suckless/bongocat/cinna.png");

    image_t k1 = img_load(dpy, vinfo, "/home/connor/suckless/bongocat/k1.png");
    image_t k2 = img_load(dpy, vinfo, "/home/connor/suckless/bongocat/k2.png");
    image_t k3 = img_load(dpy, vinfo, "/home/connor/suckless/bongocat/k3.png");
    image_t k4 = img_load(dpy, vinfo, "/home/connor/suckless/bongocat/k4.png");
    image_t k5 = img_load(dpy, vinfo, "/home/connor/suckless/bongocat/k5.png");
    image_t k6 = img_load(dpy, vinfo, "/home/connor/suckless/bongocat/k6.png");
    image_t k7 = img_load(dpy, vinfo, "/home/connor/suckless/bongocat/k7.png");
    image_t k8 = img_load(dpy, vinfo, "/home/connor/suckless/bongocat/k8.png");

    Pixmap img_pixmap = XCreatePixmap(dpy, win, 600, 200, vinfo.depth);
    GC gc = XCreateGC(dpy, img_pixmap, 0, NULL);
    Picture img_picture = XRenderCreatePicture(dpy, img_pixmap, fmt, 0, NULL);


    int cinna_offset = 0;
    int kuromi_sitting_offset = 100;
    int kuromi_animated_offset = 200;
    int cat_offset = 300;

    XPutImage(dpy, img_pixmap, gc, cinna.ximage, 0, 0, cinna_offset, 200 -79, cinna.img_w, cinna.img_h);
    XPutImage(dpy, img_pixmap, gc, kuromi_sitting.ximage, 0, 0, kuromi_sitting_offset, 200 - 89, kuromi_sitting.img_w, kuromi_sitting.img_h);

    clock_t start = clock();
    int msec;
    while (1) {
        clock_t difference = clock() - start;
        msec = difference * 1000 * 1000 / CLOCKS_PER_SEC;
        if (msec < 10000) {
            XPutImage(dpy, img_pixmap, gc, k1.ximage, 0, 0, kuromi_animated_offset, 200 - 95, k1.img_w, k1.img_h);
        } else if (msec < 20000) {
            XPutImage(dpy, img_pixmap, gc, k2.ximage, 0, 0, kuromi_animated_offset, 200 - 95, k1.img_w, k1.img_h);
        } else if (msec < 40000) {
            XPutImage(dpy, img_pixmap, gc, k3.ximage, 0, 0, kuromi_animated_offset, 200 - 95, k1.img_w, k1.img_h);
        } else if (msec < 50000) {
            XPutImage(dpy, img_pixmap, gc, k2.ximage, 0, 0, kuromi_animated_offset, 200 - 95, k1.img_w, k1.img_h);
        } else if (msec < 70000) {
            XPutImage(dpy, img_pixmap, gc, k4.ximage, 0, 0, kuromi_animated_offset, 200 - 95, k1.img_w, k1.img_h);
        } else if (msec < 80000) {
            XPutImage(dpy, img_pixmap, gc, k5.ximage, 0, 0, kuromi_animated_offset, 200 - 95, k1.img_w, k1.img_h);
        } else if (msec < 90000) {
            XPutImage(dpy, img_pixmap, gc, k6.ximage, 0, 0, kuromi_animated_offset, 200 - 95, k1.img_w, k1.img_h);
        } else if (msec < 100000) {
            XPutImage(dpy, img_pixmap, gc, k7.ximage, 0, 0, kuromi_animated_offset, 200 - 95, k1.img_w, k1.img_h);
        } else if (msec < 110000) {
            XPutImage(dpy, img_pixmap, gc, k8.ximage, 0, 0, kuromi_animated_offset, 200 - 95, k1.img_w, k1.img_h);
        } else if (msec > 130000) {
            start = clock();
        }


        // Clear window to transparent
        XRectangle clear_rect = {0, 0, 600, 200};
        XRenderFillRectangles(dpy, PictOpSrc, pict, &background, &clear_rect, 1);

        if (*any_key_pressed == 1) {
            if (rand() % 2) {
                XPutImage(dpy, img_pixmap, gc, cat_left.ximage, 0, 0, cat_offset, 200 - 67, cat_left.img_w, cat_left.img_h);
            } else {
                XPutImage(dpy, img_pixmap, gc, cat_right.ximage, 0, 0, cat_offset, 200 - 67, cat_right.img_w, cat_right.img_h);
            }

            XRenderComposite(dpy, PictOpOver, img_picture, None, pict, 0, 0, 0, 0, 0, 0, 600, 200); 
            XFlush(dpy);
            usleep(100000);
            *any_key_pressed = 0;
        } 
        XPutImage(dpy, img_pixmap, gc, cat_rest.ximage, 0, 0, cat_offset, 200 - 67, cat_rest.img_w, cat_rest.img_h);
        XRenderComposite(dpy, PictOpOver, img_picture, None, pict, 0, 0, 0, 0, 0, 0, 600, 200); 

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
