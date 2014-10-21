#!/bin/bash

MACHINE="$(uname 2>/dev/null)"

export CFLAGS="-Wall -g -m64 -pipe -O2 -march=x86-64 -fPIC"
export CXXLAGS="${CFLAGS}"
export CPPFLAGS="-I${PREFIX}/include"
export LDFLAGS="-L${PREFIX}/lib"

mkdir -vp ${PREFIX}/bin || exit 1;
mkdir -vp ${PREFIX}/var/log/nginx || exit 1;
touch ${PREFIX}/var/log/nginx/{access,error}.log || exit 1;

cat > ${PREFIX}/bin/nginx <<EOF
#!/bin/bash

CWD="\$(cd "\$(dirname "\${0}")" && pwd -P)"
ROOT_PATH="\$(cd "\${CWD}/../" && pwd -P)"

echo -e ""
echo -e "Setting up ROOT_PATH for nginx to \${ROOT_PATH} ..."
echo -e "Launching nginx ..."
echo -e ""
\${ROOT_PATH}/sbin/nginx -p "\${ROOT_PATH}" "\${@}"
EOF

chmod 755 ${PREFIX}/bin/nginx

chmod +x configure;

./configure \
    --with-pcre \
    --with-http_ssl_module \
    --http-client-body-temp-path=etc/nginx/client \
    --http-proxy-temp-path=etc/nginx/proxy \
    --http-fastcgi-temp-path=etc/nginx/fastcgi \
    --http-scgi-temp-path=etc/nginx/scgi \
    --http-uwsgi-temp-path=etc/nginx/uwsgi \
    --http-log-path=var/log/nginx/access.log \
    --conf-path=etc/nginx/nginx.conf \
    --lock-path=etc/nginx/nginx.lock \
    --error-log-path=var/log/nginx/error.log \
    --pid-path=etc/nginx/nginx.pid \
    --with-cc-opt="-I$PREFIX/include" \
    --with-ld-opt="-L$PREFIX/lib" \
    --prefix="${PREFIX}" || return 1;
make || return 1;
make install || return 1;
