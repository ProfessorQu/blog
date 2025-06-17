#!/usr/bin/env bash
#
# Convert all preview.jpg and preview.png to webp and create lqip images

if [ -d "./assets" ]; then
  ASSETS_DIR="./assets"
elif [ -d "../assets" ]; then
  ASSETS_DIR="../assets"
else
  echo "'assets' folder not found"
  exit 1
fi

get_lqip() {
  POST_DIR="$ASSETS_DIR/img/posts/$1"
  if [ -f "$POST_DIR/preview.png" ]; then
    IMAGE_PATH="$POST_DIR/preview.png"
  elif [ -f "$POST_DIR/preview.jpg" ]; then
    IMAGE_PATH="$POST_DIR/preview.jpg"
  else
    echo "image not found in $POST_DIR"
    exit 1
  fi

  WEBP="$POST_DIR/preview.webp"
  cwebp "$IMAGE_PATH" -o "$WEBP" -quiet
  convert "$WEBP" -resize 20x20 -strip -quality 20 tmp.webp
  BASE64="$(base64 -i tmp.webp)"
  LIQP="data:image/webp;base64,${BASE64//[$'\t\r\n ']/}"
  rm tmp.webp

  echo "path: ${WEBP:2}"
  echo "lqip: $LIQP"
}

get_lqip "$1"
