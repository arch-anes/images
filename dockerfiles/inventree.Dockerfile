FROM inventree/inventree:1.1.3

RUN apt update && apt install -y nginx

COPY ./files/inventree/nginx.conf /etc/nginx/sites-enabled/default
RUN nginx -T

CMD ["sh", "-c", "nginx && gunicorn -c ./gunicorn.conf.py InvenTree.wsgi -b 0.0.0.0:8000 --chdir ${INVENTREE_BACKEND_DIR}/InvenTree"]
