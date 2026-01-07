#!/usr/bin/env bash
set -euo pipefail

CACHE_DIR="$HOME/.cache/hyprlock"
OUT_FILE="$CACHE_DIR/weather_out.txt"
mkdir -p "$CACHE_DIR"

LAT="18.026"
LON="-63.045"

URL="https://api.open-meteo.com/v1/forecast?latitude=${LAT}&longitude=${LON}&current=temperature_2m,weather_code&temperature_unit=celsius"

json="$(
  /usr/bin/curl -4 -fsS \
    --connect-timeout 2 \
    --max-time 4 \
    -A "hyprlock-weather/1.0" \
    "$URL" 2>/dev/null || true
)"
[[ -z "$json" ]] && exit 0

t="$(echo "$json" | grep -oE '"temperature_2m":[-0-9.]+' | head -n1 | cut -d: -f2 || true)"
code="$(echo "$json" | grep -oE '"weather_code":[0-9]+' | head -n1 | cut -d: -f2 || true)"
[[ -z "$t" || -z "$code" ]] && exit 0

t_int="$(printf "%.0f" "$t" 2>/dev/null || echo "")"
[[ -z "$t_int" ]] && exit 0
temp="${t_int}°C"

bucket="cloudy"
if [[ "$code" == "0" ]]; then
  bucket="sunny"
elif [[ "$code" =~ ^(51|53|55|56|57|61|63|65|66|67|80|81|82|95|96|99)$ ]]; then
  bucket="rain"
elif [[ "$code" =~ ^(71|73|75|77|85|86)$ ]]; then
  bucket="snow"
fi

echo "${bucket}|${temp}" > "$OUT_FILE"

