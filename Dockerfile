FROM ubuntu:xenial
WORKDIR /build/
COPY build.sh nginx.conf index.html /build
RUN /build/build.sh

FROM ubuntu:xenial
WORKDIR /opt/nginx
COPY --from=0 /opt/nginx/ .
COPY --from=0 /nginx.conf /opt/nginx/conf
COPY --from=0 /index.html /var/www/html
RUN apt-get update && apt-get -yq install liblua5.1-0
CMD ["/opt/nginx/sbin/nginx"]
