FROM nextcloud:32.0.6-fpm-alpine

RUN apk update && apk add sudo openrc ocrmypdf tesseract-ocr
