#!/bin/sh

# Change to the directory containing this script
cd "$(dirname "$0")" || exit

FABRIC_CONFIG_DIR="${HOME}/.config/fabric"

echo "Updating Fabric configuration with new bootstrap scripts..."

for file in scripts/*.inc; do
    cp "$file" "${FABRIC_CONFIG_DIR}"
    echo Copied "$file" to "${FABRIC_CONFIG_DIR}"
done
