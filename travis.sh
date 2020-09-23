#!/bin/bash
# travis.sh script to

SDK_BASE_URL="https://developer.garmin.com/downloads/connect-iq/sdks"
SDK="connectiq-sdk-lin-3.2.2-2020-08-28-a50584d55.zip"
SDK_URL="$SDK_BASE_URL/$SDK"
SDK_FILE="sdk.zip"
SDK_DIR="${HOME}/.Garmin/ConnectIQ/Sdk"
DEVICE_FILE="devices.zip"
DEVICE_DIR="${HOME}/.Garmin/ConnectIQ/"

PEM_FILE="/tmp/developer_key.pem"
DER_FILE="/tmp/developer_key.der"

###

wget -O "${SDK_FILE}" "${SDK_URL}"
mkdir -p "${SDK_DIR}"
unzip "${SDK_FILE}" "bin/*" -d "${SDK_DIR}"

## Download devices from google drive
pip install gdown
gdown --id "1nDYmQqfE73wiSQJby5ZW4fkIfYc1ka6V" -O "${DEVICE_FILE}"
mkdir -p "${DEVICE_DIR}"
unzip "${DEVICE_FILE}" "Devices/*" -d "${DEVICE_DIR}"

openssl genrsa -out "${PEM_FILE}" 4096
openssl pkcs8 -topk8 -inform PEM -outform DER -in "${PEM_FILE}" -out "${DER_FILE}" -nocrypt

export MB_HOME="${SDK_DIR}"
export MB_PRIVATE_KEY="${DER_FILE}"

./mb_runner.sh package
