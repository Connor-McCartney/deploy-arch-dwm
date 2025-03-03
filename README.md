# Install

```
pacman -Sy wget
wget https://raw.githubusercontent.com/Connor-McCartney/deploy-arch-dwm/refs/heads/main/install.sh
chmod +x install.sh
./install.sh
```

<br>

# DWM patches

https://dwm.suckless.org/patches/adjacenttag/

https://dwm.suckless.org/patches/fullgaps/

https://dwm.suckless.org/patches/attachbelow/

https://dwm.suckless.org/patches/alpha/

(slstatus) https://tools.suckless.org/slstatus/patches/alsa/

<br>

# DWM Keybinds

Win-shift-q kill dwm

Win-w kill program

Win-1 discord (tag 1)

Win-2 chrome (tag 2)

Win-enter alacritty

Win-shift-enter alacritty in last working dir

Win-p dmenu

Win-tab switch programs

Win-arrow  switch tags

Win-shift-arrow  drag program to adjacent tag

Win-b toggle top bar

Win-esc custom switcher

Win-shit-h/l move tiles left/right

Win-z zoom/promote to master tile

Win-left-click move window

Win-right-click resize window

<br>

# Alacritty keybinds

ctrl-shift-space vim mode

ctrl-shift-f search

ctrl-+/- zoom

<br>

# nvim keybinds

ctrl-o/ctrl-n - scroll autocomplete suggestions

ctrl-tab - select autocomplete suggestion

ctrl-o/ctrl-i - switch back and forth buffers

shift-K - lsp hover info

gd - go to definition

gr - go to references

`<F2>` - rename variable

o/O - insert line above/below

ctrl-d/ctrl-u - scroll up/down

/ - search

n/N - scroll back/forth search findings

dd - delete line

ctrl-j/ctrl-k - move lines up/down (rebind)

gg - top of file

G - bottom of file

0 - go to line start

$ - go to line end

A - insert at end of line

I - insert at beginning of line

V - select entire line

ctrl-v - visual mode in multiline/columns

q - macros

w/b - forward/backwards a word

e - same as w but cursor goes to end of word instead of beginning

W/B/E - forwards/backwards but with whitespace

y - copy

x - delete char (or cut when visual mode)

s - delete char and enter insert mode

u - undo

ctrl-r - redo

% - matching bracket

) and ( - up/down functions/paragraphs
