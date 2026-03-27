FROM nextcloud:33.0.1-fpm-alpine

RUN apk update && apk add sudo openrc ocrmypdf tesseract-ocr
