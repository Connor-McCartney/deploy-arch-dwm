rm desktop_kirby
gcc main.c -lm -lX11 -lXrender -lXtst -lXfixes -o desktop_kirby -Wall -Wextra -pedantic
./desktop_kirby
