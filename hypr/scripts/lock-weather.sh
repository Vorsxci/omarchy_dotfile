#!/usr/bin/env bash
set -euo pipefail

PART="${LOCK_WEATHER_PART:-full}"

CACHE_DIR="$HOME/.cache/hyprlock"
OUT_FILE="$CACHE_DIR/weather_out.txt"   # "bucket|temp"
mkdir -p "$CACHE_DIR"

bucket="cloudy"
temp="--°C"

if [[ -s "$OUT_FILE" ]]; then
  IFS='|' read -r bucket temp < "$OUT_FILE" || true
fi

SUN="󰖙"; CLOUD="󰖐"; RAIN="󰖗"; SNOW="󰖘"

case "$bucket" in
  sunny)  icon="$SUN" ;;
  cloudy) icon="$CLOUD" ;;
  rain)   icon="$RAIN" ;;
  snow)   icon="$SNOW" ;;
  *)      icon="$CLOUD" ;;
esac

case "$PART" in
  temp)   echo "$temp" ;;
  sunny)  [[ "$bucket" == "sunny"  ]] && echo "$SUN"   || echo "" ;;
  cloudy) [[ "$bucket" == "cloudy" ]] && echo "$CLOUD" || echo "" ;;
  rain)   [[ "$bucket" == "rain"   ]] && echo "$RAIN"  || echo "" ;;
  snow)   [[ "$bucket" == "snow"   ]] && echo "$SNOW"  || echo "" ;;
  full|*) echo "$icon $temp" ;;
esac

