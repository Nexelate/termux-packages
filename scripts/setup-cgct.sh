#!/usr/bin/env bash

set -e -u

REPO_URL="https://service.termux-pacman.dev/gpkg-dev"

: "${TERMUX_PKG_TMPDIR:="/tmp"}"
TMPDIR_CGCT="${TERMUX_PKG_TMPDIR}/cgct"

if [ ! -d "$TMPDIR_CGCT" ]; then
	mkdir -p "$TMPDIR_CGCT"
fi

. $(dirname "$(realpath "$0")")/properties.sh

if [ ! -d "$CGCT_DIR" ]; then
	curl "${REPO_URL}/x86_64/gpkg-dev.json" -o "${TMPDIR_CGCT}/cgct.json"
	for pkgname in cbt cgt; do
		filename=$(cat "${TMPDIR_CGCT}/cgct.json" | jq -r '."'$pkgname'"."FILENAME"')
		if [ ! -f "${TMPDIR_CGCT}/${filename}" ]; then
			curl "${REPO_URL}/x86_64/${filename}" -o "${TMPDIR_CGCT}/${filename}"
		fi
		tar xJf "${TMPDIR_CGCT}/${filename}" -C / data
	done
fi
