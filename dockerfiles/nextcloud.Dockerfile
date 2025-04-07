FROM nextcloud:31.0.2-fpm-alpine

RUN apk add sudo openrc ocrmypdf tesseract-ocr
