/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx  = 7;        /* border pixel of windows */
static const unsigned int gappx     = 15;        /* gaps between windows */
static const unsigned int snap      = 15;       /* snap pixel */

static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const int attachbelow = 1;
static const char *fonts[]          = { "monospace:size=10" };
static const char dmenufont[]       = "monospace:size=10";
static const char col_gray1[]       = "#222222";
static const char col_gray2[]       = "#444444";
static const char col_gray3[]       = "#bbbbbb";
static const char col_gray4[]       = "#eeeeee";
static const char col_cyan[]        = "#005577";
static const char col_purple[]      = "#702963";
static const char col_white[]       = "#ffffff";
static const char *colors[][3]      = {
	/*               fg         bg           border   */
	[SchemeNorm] = { col_white, col_gray1,   col_gray1 }, // unactive tabs
	[SchemeSel]  = { col_white, col_purple,  col_purple }, // active tab
};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "discord",       NULL,       NULL,       1<<0,            0,           -1 },
	{ "LibreWolf",     NULL,       NULL,       1<<1,            0,           -1 },
	{ "InputOutput",   NULL,       NULL,          0,            0,           -1 },

};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

/* key definitions */
#define MODKEY Mod4Mask // 1 is alt, 4 is windows key
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_gray1, "-nf", col_gray3, "-sb", col_cyan, "-sf", col_gray4, NULL };
static const char *konsole[]  = { "konsole", NULL };
static const char *konsole_lastdir[]  = { "/bin/sh", "-c", "konsole --workdir $(cat /tmp/lastdir)", NULL };
static const char *discord[]  = { "discord", NULL };
static const char *librewolf[]  = { "librewolf", NULL };
static const char *flameshot[]  = { "flameshot", "gui", NULL };
static const char *switcher[]  = { "/bin/sh", "-c", "./.switcher.sh", NULL };





// audio hardware keys
// https://gist.github.com/palopezv/efd34059af6126ad970940bcc6a90f2e
#include <X11/XF86keysym.h>
/*
static const char *upvol[]      = { "/usr/bin/amixer",  "set", "Master", "5%+", NULL };
static const char *downvol[]    = { "/usr/bin/amixer",  "set", "Master", "5%-", NULL };
static const char *mutevol[]    = { "/usr/bin/amixer", "set", "Master", "toggle", NULL };
*/
static const char *upvol[] = { "/usr/bin/pactl", "set-sink-volume", "@DEFAULT_SINK@", "+5%", NULL };
static const char *downvol[] = { "/usr/bin/pactl", "set-sink-volume", "@DEFAULT_SINK@", "-5%", NULL };
static const char *mutevol[] = { "/usr/bin/pactl", "set-sink-mute", "@DEFAULT_SINK@", "toggle", NULL };


/* Control Media Players (pause/play/skip)*/
// https://www.reddit.com/r/linux4noobs/comments/ole89p/assign_multimedia_keys_playpausenextprevious_in/?rdt=49942
static const char *medplaypausecmd[] = { "playerctl", "play-pause", NULL };
static const char *mednextcmd[] = { "playerctl", "next", NULL };
static const char *medprevcmd[] = { "playerctl", "previous", NULL };


static const Key keys[] = {
	/* modifier                     key        function        argument */

	/* Keybindings for Media play/pause/next/previous */
	{ 0, XF86XK_AudioPlay, spawn, {.v = medplaypausecmd } },
	{ 0, XF86XK_AudioNext, spawn, {.v = mednextcmd } },
	{ 0, XF86XK_AudioPrev, spawn, {.v = medprevcmd } },

	// audio hardware keys
	{ 0,                       XF86XK_AudioLowerVolume, spawn, {.v = downvol } },
	{ 0,                       XF86XK_AudioMute, spawn, {.v = mutevol } },
	{ 0,                       XF86XK_AudioRaiseVolume, spawn, {.v = upvol   } },

	// fullgaps patch
	{ MODKEY,                       XK_minus,  setgaps,        {.i = -1 } },
	{ MODKEY,                       XK_equal,  setgaps,        {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_equal,  setgaps,        {.i = 0  } },

	// adjacenttags patch
	{ MODKEY,                       XK_Right,  viewnext,       {0} },
	{ MODKEY,                       XK_Left,   viewprev,       {0} },
	{ MODKEY|ShiftMask,             XK_Right,  tagtonext,      {0} },
	{ MODKEY|ShiftMask,             XK_Left,   tagtoprev,      {0} },

	// open programs
	{ MODKEY,                       XK_p,      spawn,          {.v = dmenucmd } },
	{ MODKEY,                       XK_Return, spawn,          {.v = konsole} },
	{ MODKEY|ShiftMask,             XK_Return, spawn,          {.v = konsole_lastdir} },
	{ MODKEY,                       XK_1,      spawn,          {.v = discord} },
    { MODKEY,                       XK_2,      spawn,          {.v = librewolf} },
    { MODKEY,                       XK_3,      spawn,          {.v = flameshot} },


	// other useful
	{ MODKEY,                       XK_z,      zoom,           {0} },
	{ MODKEY,                       XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_w,      killclient,     {0} },
	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },
	{ MODKEY,                       XK_Tab,      focusstack,   {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY|ShiftMask,             XK_l,      setmfact,       {.f = +0.05} },
	{ MODKEY,                       XK_Escape,    spawn,       {.v = switcher } },


	// other
	//{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	//{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	//{ MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
	//{ MODKEY,                       XK_Tab,    view,           {0} },
	//{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	//{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
	//{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
	//{ MODKEY,                       XK_space,  setlayout,      {0} },
	//{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	//{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	//{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },

	/*
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	*/
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	//{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

