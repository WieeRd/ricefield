#!/usr/bin/env bash
# ~/.profile: sourced by display managers before the graphical session.

set -o allexport

# use fcitx5 as an input method
XMODIFIERS=@im=fcitx
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
GLFW_IM_MODULE=ibus

set +o allexport
