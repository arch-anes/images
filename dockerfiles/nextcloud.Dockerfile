FROM nextcloud:31.0.2-fpm-alpine

RUN apk update && apk add nginx sudo openrc ocrmypdf tesseract-ocr

COPY ./files/nextcloud/nginx.conf /etc/nginx/http.d/default.conf
RUN nginx -T

COPY ./files/nextcloud/startup.sh /startup.sh
ENTRYPOINT [ "/startup.sh" ]
CMD ["php-fpm"]
