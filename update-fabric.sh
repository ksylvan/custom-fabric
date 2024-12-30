#!/bin/sh

# Change to the directory containing this script
cd "$(dirname "$0")" || exit

FABRIC_CONFIG_DIR="${HOME}/.config/fabric"
PATTERNS_DIR="${FABRIC_CONFIG_DIR}/patterns"

if [ ! -d "${PATTERNS_DIR}" ]; then
    echo "Fabric configuration directory not found at ${FABRIC_CONFIG_DIR}"
    exit 1
fi

echo "Updating Fabric configuration with custom patterns..."
cp -r patterns/* "${PATTERNS_DIR}"
