#!/bin/bash
# travis.sh script to

SDK_BASE_URL="https://developer.garmin.com/downloads/connect-iq/sdks"
SDK="connectiq-sdk-lin-4.0.9-2022-01-24-2154651d3.zip"
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
gdown --id "${DEVICE_TOKEN}" -O "${DEVICE_FILE}"
mkdir -p "${DEVICE_DIR}"
unzip "${DEVICE_FILE}" "Devices/*" -d "${DEVICE_DIR}"

openssl enc -salt -aes-128-cbc -pbkdf2 -d -in developer_key.encrypt -out developer_key -k "${KEY_PASS}"

export MB_HOME="${SDK_DIR}"
export MB_PRIVATE_KEY="./developer_key"

mbget --token ${GH_TOKEN} update
./mb_runner.sh package

# Start an XServer and simulator and wait a couple seconds for it to start up
#Xorg -config ./dummy-1920x1080.conf :1 &
#DISPLAY=:1 ./mb_runner.sh simulator
#
#./mb_runner.sh test .
