FROM ubuntu:xenial
WORKDIR /build/
COPY build.sh nginx.conf index.html /build/
RUN /build/build.sh

FROM ubuntu:xenial
WORKDIR /opt/nginx
COPY --from=0 /opt/nginx/ .
COPY --from=0 /build/nginx.conf /opt/nginx/conf
COPY --from=0 /build/index.html /var/www/html/
#RUN apk add --no-cache --virtual .build-deps liblua5.1-0 \
RUN apt-get update && apt-get  -yq install liblua5.1-0 \
    && ln -sf /dev/stdout /opt/nginx/logs/access.log \
	&& ln -sf /dev/stderr /opt/nginx/logs/error.log
EXPOSE 80
CMD ["/opt/nginx/sbin/nginx", "-g", "daemon off;"]  
