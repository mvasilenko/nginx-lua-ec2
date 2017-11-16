FROM ubuntu:xenial
WORKDIR /build/
COPY build.sh /build
RUN /build/build.sh

FROM ubuntu:xenial
WORKDIR /opt/nginx
COPY --from=0 /opt/nginx/ .
RUN apt-get update && apt-get -yq install liblua5.1-0
CMD ["/opt/nginx/sbin/nginx"]

