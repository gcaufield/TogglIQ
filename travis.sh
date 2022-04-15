#!/bin/bash
# travis.sh script to

SDK_BASE_URL="https://developer.garmin.com/downloads/connect-iq/sdks"
SDK="connectiq-sdk-lin-4.1.1-2022-03-14-18db583bc.zip"
SDK_URL="$SDK_BASE_URL/$SDK"
SDK_FILE="sdk.zip"
SDK_DIR="${HOME}/.Garmin/ConnectIQ/Sdk/"
DEVICE_FILE="devices.zip"
DEVICE_DIR="${HOME}/.Garmin/ConnectIQ/"

PEM_FILE="/tmp/developer_key.pem"
DER_FILE="/tmp/developer_key.der"

###

wget -O "${SDK_FILE}" "${SDK_URL}"
mkdir -p "${SDK_DIR}"
unzip "${SDK_FILE}" "bin/*" -d "${SDK_DIR}"
unzip "${SDK_FILE}" "share/*" -d "${SDK_DIR}"

## Download devices from google drive
gdown -O "${DEVICE_FILE}" "${DEVICE_TOKEN}"
mkdir -p "${DEVICE_DIR}"
unzip "${DEVICE_FILE}" "Devices/*" -d "${DEVICE_DIR}"

if [[ -z "${KEY_PASS}" ]]; then
  # If the build doesn't have the encryption key for the developer key, generate
  # a new one just for the build
  openssl genrsa -out developer_key.pem 4096
  openssl pkcs8 -topk8 -inform PEM -outform DER -in developer_key.pem -out developer_key -nocrypt
else
  openssl enc -salt -aes-128-cbc -pbkdf2 -d -in developer_key.encrypt -out developer_key -k "${KEY_PASS}"
fi


export MB_HOME="${SDK_DIR}"
export MB_PRIVATE_KEY="./developer_key"

mbget --token ${GH_TOKEN} update
./mb_runner.sh package

# Start an XServer and simulator and wait a couple seconds for it to start up
Xorg -config ./dummy-1920x1080.conf :1 &
DISPLAY=:1 ./mb_runner.sh simulator

./mb_runner.sh test .
