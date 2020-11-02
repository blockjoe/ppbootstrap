#!/bin/bash

BASE=https://xff.cz/kernels
MAJOR_S=5
MINOR_S=9


function url-exists() {
    resp=$(curl -s --head "$1" | head -n 1 )
    echo "$resp"
    if [[ "$resp" =~ .*4[0-9][0-9].* ]]; then
	   return 1 
    else
	   return 0
    fi
}

function check-next-major() {
  NEXT_MAJOR=$((MAJOR_S + 1))
  url="${BASE}/${NEXT_MAJOR}.0"
  url-exists "$url" > /dev/null
  return "$?"
}

function find-current-major-version() {
  while check-next-major; do
       MAJOR_S=$((MAJOR_S + 1))
  done
}

function check-next-minor() {
  NEXT_MINOR=$((MINOR_S + 1))
  url="${BASE}/${MAJOR_S}.${NEXT_MINOR}"
  url-exists "$url" > /dev/null
  return "$?"
}

function find-current-minor-version() {
  while check-next-minor; do
	  MINOR_S=$((MINOR_S + 1))
  done
}

function find-current-version() {
 find-current-major-version
 find-current-minor-version
 VER="${MAJOR_S}.${MINOR_S}"
 URL_BASE="${BASE}/${VER}"
}

cd "$(dirname "${BASH_SOURCE[0]}")"

find-current-version
mkdir -p "$VER"
cd "$VER"

wget --backups=1 "${URL_BASE}/README"
wget --backups=1 "${URL_BASE}/pp.tar.gz"
wget --backups=1 "${URL_BASE}/pp.tar.gz.asc"
wget --backups=1 "${URL_BASE}/patches.tar.gz"

rm -rf *.1

if [ -d "pp-${VER}" ]; then
	rm -rf "pp-${VER}"
fi

tar -zxf pp.tar.gz

printf "$VER" > ../LATEST
