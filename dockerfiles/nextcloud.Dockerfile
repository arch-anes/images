FROM nextcloud:31.0.7-fpm-alpine

RUN apk update && apk add sudo openrc ocrmypdf tesseract-ocr
