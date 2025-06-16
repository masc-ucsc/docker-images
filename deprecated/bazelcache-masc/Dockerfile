FROM nginx:alpine
COPY ngnix.conf /etc/nginx/nginx.conf
COPY cleancache /etc/periodic/daily/cleancache
RUN chmod 755 /etc/periodic/daily/cleancache

EXPOSE 80

RUN mkdir /cache /cache/cache /cache/cache/ac /cache/cache/cas
RUN chmod 0777 /cache /cache/cache /cache/cache/ac /cache/cache/cas

