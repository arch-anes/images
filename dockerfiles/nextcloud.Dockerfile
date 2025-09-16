FROM nextcloud:31.0.9-fpm-alpine

RUN apk update && apk add sudo openrc ocrmypdf tesseract-ocr
