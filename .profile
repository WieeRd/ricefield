#!/usr/bin/env bash
# ~/.profile: sourced by display managers before the graphical session.
# import systemd user environments from `environment.d/`

set -o allexport
systemctl --user unset-environment DISPLAY XAUTHORITY
eval "$(systemctl --user show-environment)"
set +o allexport
