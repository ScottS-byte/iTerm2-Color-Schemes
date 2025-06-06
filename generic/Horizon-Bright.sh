#!/bin/sh
# Horizon-Bright

# source for these helper functions:
# https://github.com/chriskempson/base16-shell/blob/master/templates/default.mustache
if [ -n "$TMUX" ]; then
  # Tell tmux to pass the escape sequences through
  # (Source: http://permalink.gmane.org/gmane.comp.terminal-emulators.tmux.user/1324)
  put_template() { printf '\033Ptmux;\033\033]4;%d;rgb:%s\033\033\\\033\\' $@; }
  put_template_var() { printf '\033Ptmux;\033\033]%d;rgb:%s\033\033\\\033\\' $@; }
  put_template_custom() { printf '\033Ptmux;\033\033]%s%s\033\033\\\033\\' $@; }
elif [ "${TERM%%[-.]*}" = "screen" ]; then
  # GNU screen (screen, screen-256color, screen-256color-bce)
  put_template() { printf '\033P\033]4;%d;rgb:%s\007\033\\' $@; }
  put_template_var() { printf '\033P\033]%d;rgb:%s\007\033\\' $@; }
  put_template_custom() { printf '\033P\033]%s%s\007\033\\' $@; }
elif [ "${TERM%%-*}" = "linux" ]; then
  put_template() { [ $1 -lt 16 ] && printf "\e]P%x%s" $1 $(echo $2 | sed 's/\///g'); }
  put_template_var() { true; }
  put_template_custom() { true; }
else
  put_template() { printf '\033]4;%d;rgb:%s\033\\' $@; }
  put_template_var() { printf '\033]%d;rgb:%s\033\\' $@; }
  put_template_custom() { printf '\033]%s%s\033\\' $@; }
fi

# 16 color space
put_template 0  "16/16/1c"
put_template 1  "e9/56/78"
put_template 2  "29/d3/98"
put_template 3  "fa/b7/95"
put_template 4  "26/bb/d9"
put_template 5  "ee/64/ae"
put_template 6  "59/e3/e3"
put_template 7  "fd/f0/ed"
put_template 8  "1a/1c/23"
put_template 9  "ec/6a/88"
put_template 10 "3f/da/a4"
put_template 11 "fb/c3/a7"
put_template 12 "3f/c6/de"
put_template 13 "f0/75/b7"
put_template 14 "6b/e6/e6"
put_template 15 "ff/f3/f0"

color_foreground="16/16/1c"
color_background="fb/f0/ee"

if [ -n "$ITERM_SESSION_ID" ]; then
  # iTerm2 proprietary escape codes
  put_template_custom Pg "16161c"
  put_template_custom Ph "fbf0ee"
  put_template_custom Pi "16161c"
  put_template_custom Pj "f2d0c5"
  put_template_custom Pk "16161c"
  put_template_custom Pl "f2d0c5"
  put_template_custom Pm "f2d0c5"
else
  put_template_var 10 $color_foreground
  put_template_var 11 $color_background
  if [ "${TERM%%-*}" = "rxvt" ]; then
    put_template_var 708 $color_background # internal border (rxvt)
  fi
  put_template_custom 12 ";7" # cursor (reverse video)
fi

# clean up
unset -f put_template
unset -f put_template_var
unset -f put_template_custom

unset color_foreground
unset color_background
