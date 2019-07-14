#!/usr/bin/env bash
set -e

if [[ TRAVIS_EVENT_TYPE = "cron" ]]; then
  rm -rf ~/.local/share/img
fi
