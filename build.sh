#!/usr/bin/env bash
# Determine latest version:
# on Linux
#latestVer=$(curl 'http://nginx.org/download/' | 
#   grep -oP 'href="nginx-\K[0-9]+\.[0-9]+\.[0-9]+' | 
#   sort -t. -rn -k1,1 -k2,2 -k3,3 | head -1)
# on MacOS X
apt-get update && apt-get -y install curl
latestVer=$(curl 'http://nginx.org/download/' | 
 egrep -o 'href="nginx-[0-9]+\.[0-9]+\.[0-9]+' | sed 's/^href="nginx-//' |
 sort -t. -rn -k1,1 -k2,2 -k3,3 | head -1)
echo downloading nginx version $latestVer
curl "http://nginx.org/download/nginx-${latestVer}.tar.gz" > nginx-${latestVer}.tar.gz
if [ -z nginx-${latestVer}.tar.gz ];then
  echo "Unable to download latest nginx version, exiting"
  exit 1 
fi

apt-get -y install build-essential liblua5.1-0-dev liblua5.1-0 git
tar -zxvf nginx-$latestVer.tar.gz
cd nginx-${latestVer}
mkdir ext
cd ext
git clone --depth 1 git://github.com/chaoslawful/lua-nginx-module.git
# configure
cd ..
./configure --prefix=/opt/nginx  \
  --without-http_gzip_module \
  --without-http_rewrite_module \
  --without-http_autoindex_module \
  --without-http_geo_module \
  --without-http_scgi_module \
  --without-http_ssi_module \
  --without-http_uwsgi_module \
  --add-module=ext/lua-nginx-module && \ 
make -j2 && make install
# && cd .. && rm -rf nginx-$latestVer*
