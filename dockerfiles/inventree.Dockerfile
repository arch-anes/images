FROM inventree/inventree:1.0.0

RUN apt update && apt install -y nginx sudo openrc

COPY ./files/inventree/nginx.conf /etc/nginx/http.d/default.conf
RUN nginx -T

CMD ["sh", "-c", "invoke update --skip-backup --frontend && start-stop-daemon --start --make-pidfile --pidfile /nginx.pid --exec /usr/sbin/nginx && gunicorn -c ./gunicorn.conf.py InvenTree.wsgi -b 0.0.0.0:8000 --chdir ${INVENTREE_BACKEND_DIR}/InvenTree"]
