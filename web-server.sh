#!/usr/bin/env bash

PORT=8000

if command -v python3 &>/dev/null; then
    python3 -m http.server $PORT
elif command -v python &>/dev/null; then
    VERSION=$(python -c 'import sys; print(sys.version_info.major)')
    if [ "$VERSION" -eq 3 ]; then
        python -m http.server $PORT
    else
        python -m SimpleHTTPServer $PORT
    fi
else
    echo "Error: No se encontró una instalación de Python."
    exit 1
fi
