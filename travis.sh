#!/bin/bash
# travis.sh script to

SDK_BASE_URL="https://developer.garmin.com/downloads/connect-iq/sdks"
SDK="connectiq-sdk-lin-3.1.9-2020-06-24-1cc9d3a70.zip"
SDK_URL="$SDK_BASE_URL/$SDK"
SDK_FILE="sdk.zip"
SDK_DIR="sdk"

PEM_FILE="/tmp/developer_key.pem"
DER_FILE="/tmp/developer_key.der"

###

wget -O "${SDK_FILE}" "${SDK_URL}"
unzip "${SDK_FILE}" "bin/*" -d "${SDK_DIR}"

openssl genrsa -out "${PEM_FILE}" 4096
openssl pkcs8 -topk8 -inform PEM -outform DER -in "${PEM_FILE}" -out "${DER_FILE}" -nocrypt

export MB_HOME="${SDK_DIR}"
export MB_PRIVATE_KEY="${DER_FILE}"

./mb_runner.sh package
