FROM nextcloud:31.0.2-fpm-alpine

RUN apk add openrc ocrmypdf tesseract-ocr
