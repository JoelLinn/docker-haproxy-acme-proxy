FROM haproxy:1.9

RUN apt-get update && apt-get install -y lua-http lua-socket && apt-get clean

COPY haproxy.cfg /usr/local/etc/haproxy/

COPY haproxy-acme-validation-proxy-plugin/acme-http01-webroot.lua /usr/local/etc/haproxy/
