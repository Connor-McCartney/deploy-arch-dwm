#include <X11/extensions/Xfixes.h>
#include <X11/extensions/shape.h>
#include <X11/extensions/Xrender.h>
#include <X11/extensions/record.h>
#include <X11/X.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Xatom.h>
#include <X11/XKBlib.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <string.h>
#include <sys/time.h>

#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"

int *win_key_pressed;
int *shift_key_pressed;
int *b_key_pressed;

int *left_arrow_key_pressed;
int *up_arrow_key_pressed;
int *right_arrow_key_pressed;
int *down_arrow_key_pressed;

typedef struct {
    int img_w;
    int img_h;
    XImage* ximage;
    Pixmap pix;
    Picture pic;
} image_t;


typedef struct _{
    image_t* frames;
    int nframes;
} frames_t;

enum kirby_states {
    IDLE, 
    WALK,
};


enum kirby_direction {
    LEFT, 
    RIGHT,
};


static image_t kirby_frame;
static int kirby_state = IDLE;
static int kirby_x;
static int kirby_y;
static int kirby_y_velocity;
static int kirby_direction;
static int animation_y_offset = 0;



static struct timeval last, now;
static long diff;

void key_pressed_cb(XPointer arg, XRecordInterceptData *d) {
    if (arg){}; // just hide unused warning lol
    if (d->category != XRecordFromServer)
        return;

    int key = ((unsigned char*) d->data)[1];
    int type = ((unsigned char*) d->data)[0] & 0x7F;
    int repeat = d->data[2] & 1;

    if (!repeat) {
        if (type == KeyPress) {
            if (key == 133) *win_key_pressed = 1;
            if (key == 56)  *b_key_pressed = 1;
            if (key == 50)  *shift_key_pressed = 1;
            if (key == 113) *left_arrow_key_pressed  = 1;
            if (key == 111) *up_arrow_key_pressed    = 1;
            if (key == 114) *right_arrow_key_pressed = 1;
            if (key == 116) *down_arrow_key_pressed  = 1;
        } else if (type == KeyRelease) {
            if (key == 133) *win_key_pressed = 0;
            if (key == 56)  *b_key_pressed = 0;
            if (key == 50)  *shift_key_pressed = 0;
            if (key == 113) *left_arrow_key_pressed  = 0;
            if (key == 111) *up_arrow_key_pressed    = 0;
            if (key == 114) *right_arrow_key_pressed = 0;
            if (key == 116) *down_arrow_key_pressed  = 0;
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


frames_t load_frames(Display* dpy, Window win, XVisualInfo vinfo, XRenderPictFormat* fmt, char* folder_name, int nframes) {
    frames_t frames = {};
    frames.frames = malloc(sizeof(image_t) * nframes);

    for (int i=0; i<nframes; i++) {
        char filename[50];
        snprintf(filename, 50, "sprites/%s/%d.png", folder_name, i);
        image_t img  = img_load(dpy, win, vinfo, fmt, filename);
        frames.frames[i] = img;
    }

    frames.nframes = nframes;
    return frames;
}



void animate(image_t* frames, int nframes, int animation_speed, int y_offset) {
    animation_y_offset = y_offset;

    /*
    for (int i=0; i<nframes; i++) {
        if ((i*animation_speed) < diff && (diff < (i+1)*animation_speed)) {
            kirby_frame = frames[i]; 
        }
    }
    if (diff > nframes*animation_speed) {
        last = now;
    }
    */

    int frame = diff / animation_speed;
    if (frame >= nframes) {
        frame = 0;
        last = now;
    }
    kirby_frame = frames[frame];
}

int run() {
    XTransform xf = {{
        { XDoubleToFixed(-1), 0, 0 },
        { 0, XDoubleToFixed(1), 0 },
        { 0, 0, XDoubleToFixed(1) }
    }};


    XTransform identity = {{
        { XDoubleToFixed(1), 0, 0 },
        { 0, XDoubleToFixed(1), 0 },
        { 0, 0, XDoubleToFixed(1) }
    }};

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

    int screen_h = DisplayHeight(dpy, screen);
    int screen_w = DisplayWidth(dpy, screen);
    int win_w = screen_w;
    int win_h = 300;
    int floor_height = 58;
    Window win = XCreateWindow(dpy, root, 0, screen_h - win_h, win_w, win_h,
                               0, vinfo.depth, InputOutput, vinfo.visual,
                               CWColormap | CWBackPixel | CWBorderPixel | CWOverrideRedirect,
                               &attrs);
    XMapWindow(dpy, win);

    XRenderPictFormat* fmt = XRenderFindVisualFormat(dpy, vinfo.visual);
    Picture pict = XRenderCreatePicture(dpy, win, fmt, 0, NULL);

    // empty input region so it's clikable through
    XserverRegion region = XFixesCreateRegion(dpy, NULL, 0);
    XFixesSetWindowShapeRegion(dpy, win, ShapeInput, 0, 0, region);
    XFixesDestroyRegion(dpy, region);

    frames_t idle_frames = load_frames(dpy, win, vinfo, fmt, "idle", 4);
    frames_t walk_frames = load_frames(dpy, win, vinfo, fmt, "walk", 10);


    struct timeval frame_last, frame_now;
    gettimeofday(&last, NULL);
    gettimeofday(&frame_last, NULL);


    kirby_frame = idle_frames.frames[0];

    kirby_x = 100;
    kirby_y = win_h - floor_height;
    int walk_speed = 3;

    while (1) {

        if (*right_arrow_key_pressed && !*left_arrow_key_pressed) {
            kirby_state = WALK;
            kirby_direction = RIGHT;
            kirby_x += walk_speed;
        } else if (*left_arrow_key_pressed && !*right_arrow_key_pressed) {
            kirby_state = WALK;
            kirby_direction = LEFT;
            kirby_x -= walk_speed;
        } else {
            kirby_state = IDLE;
        }


        if (win_h-kirby_y <= floor_height) {
            kirby_y_velocity = 0;
            kirby_y = win_h-floor_height;
        }

        if (*up_arrow_key_pressed && (win_h-kirby_y == floor_height))  {
            kirby_y_velocity = -105;
        }
        kirby_y_velocity += 2; // gravity
        kirby_y += kirby_y_velocity/10;

        gettimeofday(&now, NULL);
        //long now_us = now.tv_sec * 1000000 + now.tv_usec;
        diff = (now.tv_sec - last.tv_sec) * 1000000 + (now.tv_usec - last.tv_usec);




        if (kirby_state == IDLE) {
            animate(idle_frames.frames, idle_frames.nframes, 140000, 0);
        }
        if (kirby_state == WALK) {
            animate(walk_frames.frames, walk_frames.nframes, 50000, -8);
        }



        // don't walk outside the screen
        if (kirby_x > win_w - kirby_frame.img_w) { kirby_x = win_w - kirby_frame.img_w; }
        if (kirby_x < 0) { kirby_x = 0; }

        // face left/right
        if (kirby_direction == RIGHT) {
            XRenderSetPictureTransform(dpy, kirby_frame.pic, &identity);
        } else if (kirby_direction == LEFT) {
            xf.matrix[0][2] = XDoubleToFixed(kirby_frame.img_w);
            XRenderSetPictureTransform(dpy, kirby_frame.pic, &xf);
        }

        XRenderComposite(dpy, PictOpOver, kirby_frame.pic, None, pict,
                         0, 0, 0, 0, kirby_x, kirby_y + animation_y_offset,
                         kirby_frame.img_w, kirby_frame.img_h);

        XFlush(dpy);


        // sleep
        const long frame_us = 16666; // ~60 FPS
        gettimeofday(&frame_now, NULL);
        long elapsed = (frame_now.tv_sec - frame_last.tv_sec) * 1000000 +
                       (frame_now.tv_usec - frame_last.tv_usec);
        if (elapsed < frame_us) {
            usleep(frame_us - elapsed);
        }
        frame_last = frame_now;


        //XRenderColor transparent = {0, 6553, 0, 1};
        XRenderColor transparent = {0, 0, 0, 0};
        XRenderFillRectangle(dpy, PictOpSrc, pict, &transparent, kirby_x, kirby_y+animation_y_offset, kirby_frame.img_w, kirby_frame.img_h);



    }
    return 0;
}

int main() {
    win_key_pressed = mmap(NULL, sizeof(int), PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
    shift_key_pressed = mmap(NULL, sizeof(int), PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
    b_key_pressed = mmap(NULL, sizeof(int), PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);


    left_arrow_key_pressed =  mmap(NULL, sizeof(int), PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
    right_arrow_key_pressed = mmap(NULL, sizeof(int), PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
    down_arrow_key_pressed = mmap(NULL, sizeof(int), PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
    up_arrow_key_pressed = mmap(NULL, sizeof(int), PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);

    if (fork()) scan();
    else run();
}

