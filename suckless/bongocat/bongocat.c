#include <X11/X.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Xatom.h>
#include <X11/extensions/Xrender.h>
#include <X11/XKBlib.h>
#include <X11/extensions/record.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <sys/mman.h>
#include <string.h>
#include <sys/time.h>

#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"

int *any_key_pressed;
int *win_key_pressed;
int *shift_key_pressed;
int *b_key_pressed;

typedef struct {
    int img_w;
    int img_h;
    XImage* ximage;
    Pixmap pix;
    Picture pic;
} image_t;

void key_pressed_cb(XPointer arg, XRecordInterceptData *d) {
    if (d->category != XRecordFromServer)
        return;

    int key = ((unsigned char*) d->data)[1];
    int type = ((unsigned char*) d->data)[0] & 0x7F;
    int repeat = d->data[2] & 1;

    if (!repeat) {
        if (type == KeyPress) {
            *any_key_pressed = 1;
            if (key == 133) *win_key_pressed = 1;
            if (key == 56)  *b_key_pressed = 1;
            if (key == 50)  *shift_key_pressed = 1;
        } else if (type == KeyRelease) {
            if (key == 133) *win_key_pressed = 0;
            if (key == 56)  *b_key_pressed = 0;
            if (key == 50)  *shift_key_pressed = 0;
        }
    }
    XRecordFreeData(d);
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

image_t img_load(Display* dpy, Window win, XVisualInfo vinfo, XRenderPictFormat* fmt, const char* path) {
    int w, h, c;
    unsigned char* data = stbi_load(path, &w, &h, &c, 4);
    if (!data) {
        fprintf(stderr, "image load failed: %s\n", path);
        exit(1);
    }

    for (int i = 0; i < w * h; ++i) {
        unsigned char* px = data + 4 * i;
        unsigned char tmp = px[0];
        px[0] = px[2];
        px[2] = tmp;
    }

    XImage* xi = XCreateImage(dpy, vinfo.visual, vinfo.depth, ZPixmap, 0,
                               (char*)data, w, h, 32, 0);
    Pixmap pix = XCreatePixmap(dpy, win, w, h, vinfo.depth);
    GC gc = XCreateGC(dpy, pix, 0, NULL);
    XPutImage(dpy, pix, gc, xi, 0, 0, 0, 0, w, h);
    Picture pic = XRenderCreatePicture(dpy, pix, fmt, 0, NULL);

    return (image_t){w, h, xi, pix, pic};
}

int run() {
    Display* dpy = XOpenDisplay(NULL);
    if (!dpy) {
        fprintf(stderr, "Failed to open display\n");
        return 1;
    }

    int screen = DefaultScreen(dpy);
    Window root = RootWindow(dpy, screen);

    XVisualInfo vinfo;
    if (!XMatchVisualInfo(dpy, screen, 32, TrueColor, &vinfo)) {
        fprintf(stderr, "No ARGB visual\n");
        return 1;
    }

    XSetWindowAttributes attrs;
    attrs.colormap = XCreateColormap(dpy, root, vinfo.visual, AllocNone);
    attrs.background_pixel = 0;
    attrs.border_pixel = 0;
    attrs.override_redirect = True;

    int win_w = 380, win_h = 90;
    int screen_h = DisplayHeight(dpy, screen);
    Window win = XCreateWindow(dpy, root, 0, screen_h - win_h, win_w, win_h,
                               0, vinfo.depth, InputOutput, vinfo.visual,
                               CWColormap | CWBackPixel | CWBorderPixel | CWOverrideRedirect,
                               &attrs);
    XMapWindow(dpy, win);

    XRenderPictFormat* fmt = XRenderFindVisualFormat(dpy, vinfo.visual);
    Picture pict = XRenderCreatePicture(dpy, win, fmt, 0, NULL);
    XRenderColor transparent = {0, 0, 0, 0};

    image_t kuromi_frames[8];
    char buf[128];
    for (int i = 0; i < 8; i++) {
        snprintf(buf, sizeof(buf), "/home/connor/suckless/bongocat/k%d.png", i + 1);
        kuromi_frames[i] = img_load(dpy, win, vinfo, fmt, buf);
    }

    image_t cat_rest = img_load(dpy, win, vinfo, fmt, "/home/connor/suckless/bongocat/rest.png");
    image_t cat_left = img_load(dpy, win, vinfo, fmt, "/home/connor/suckless/bongocat/left.png");
    image_t cat_right = img_load(dpy, win, vinfo, fmt, "/home/connor/suckless/bongocat/right.png");
    image_t cinna = img_load(dpy, win, vinfo, fmt, "/home/connor/suckless/bongocat/cinna.png");
    image_t kuromi_sit = img_load(dpy, win, vinfo, fmt, "/home/connor/suckless/bongocat/kuromi_sitting.png");

    struct timespec ts = {0, 16 * 1000000};
    int toggle = 0, frame = 0;
    struct timeval last, now;
    long paw_hold_until = 0;
    gettimeofday(&last, NULL);

    image_t cat;
    while (1) {
        if (*win_key_pressed && *shift_key_pressed && *b_key_pressed) {
            XMoveWindow(dpy, win, 0, screen_h - win_h + (toggle ? 0 : 100));
            *win_key_pressed = *shift_key_pressed = *b_key_pressed = 0;
            toggle ^= 1;
        }

        gettimeofday(&now, NULL);
        long now_us = now.tv_sec * 1000000 + now.tv_usec;
        long diff = (now.tv_sec - last.tv_sec) * 1000000 + (now.tv_usec - last.tv_usec);
        if (diff > 600000) {
            frame = (frame + 1) % 8;
            last = now;
        }

        XRenderFillRectangle(dpy, PictOpSrc, pict, &transparent, 0, 0, win_w, win_h);

        XRenderComposite(dpy, PictOpOver, kuromi_frames[frame].pic, None, pict,
                         0, 0, 0, 0, 260, -3,
                         kuromi_frames[frame].img_w, kuromi_frames[frame].img_h);

        XRenderComposite(dpy, PictOpOver, cinna.pic, None, pict,
                         0, 0, 0, 0, 70, 12,
                         cinna.img_w, cinna.img_h);

        XRenderComposite(dpy, PictOpOver, kuromi_sit.pic, None, pict,
                         0, 0, 0, 0, 170, 0,
                         kuromi_sit.img_w, kuromi_sit.img_h);

        if (*any_key_pressed) {
            if (rand()%2) {
                cat = cat_left;
            } else {
                cat = cat_right;
            }
            paw_hold_until = now_us + 50000;
        } else if (now_us > paw_hold_until) {
            cat = cat_rest;
        }

        XRenderComposite(dpy, PictOpOver, cat.pic, None, pict,
                         0, 0, 0, 0, 0, 23,
                         cat.img_w, cat.img_h);

        *any_key_pressed = 0;
        XFlush(dpy);
        nanosleep(&ts, NULL);
    }
    return 0;
}

int main() {
    any_key_pressed = mmap(NULL, sizeof(int), PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
    win_key_pressed = mmap(NULL, sizeof(int), PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
    shift_key_pressed = mmap(NULL, sizeof(int), PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
    b_key_pressed = mmap(NULL, sizeof(int), PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);

    if (fork()) scan();
    else run();
}
