#!/bin/sh

# Change to the directory containing this script
cd "$(dirname "$0")"

FABRIC_CONFIG_DIR="${HOME}/.config/fabric"
PATTERNS_DIR="${FABRIC_CONFIG_DIR}/patterns"
SCRIPT_TO_OVERWRITE="${FABRIC_CONFIG_DIR}/fabric-bootstrap.inc"

if [ ! -d "${PATTERNS_DIR}" ]; then
    echo "Fabric configuration directory not found at ${FABRIC_CONFIG_DIR}"
    exit 1
fi

if [ ! -f "${SCRIPT_TO_OVERWRITE}" ]; then
    echo "Script to overwrite not found at ${SCRIPT_TO_OVERWRITE}"
    exit 1
fi

echo "Updating Fabric configuration with custom patterns..."
cp -r patterns/* "${PATTERNS_DIR}"

cd ${FABRIC_CONFIG_DIR}
echo "Updating Fabric aliases with all patterns..."

patterns=$(cd patterns && ls)

TEMP_FILE=$(mktemp)
for i in ${patterns}; do
    echo "alias $i='fabric --pattern $i'" >> ${TEMP_FILE}
done

mv ${TEMP_FILE} ${SCRIPT_TO_OVERWRITE}
