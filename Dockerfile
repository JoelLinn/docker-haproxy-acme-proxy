FROM haproxy:2.1

ENV BUILD_DEPS \
        build-essential \
        luarocks \
        libcurl4-openssl-dev \
        liblua5.3-dev

# Install an up to date version of Lua-cURL
RUN DEBIAN_FRONTEND=noninteractive apt-get update &&\
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ${BUILD_DEPS} libcurl4  && \
    echo 'lua_version = "5.3"' >> /etc/luarocks/config.lua && \
    luarocks install Lua-cURL CURL_INCDIR=/usr/include/x86_64-linux-gnu/ LUA_INCDIR=/usr/include/lua5.3/ && \
    apt-get purge -y ${BUILD_DEPS} && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

COPY haproxy.cfg /usr/local/etc/haproxy/

COPY haproxy-acme-validation-proxy-plugin/acme-http01-webroot.lua /usr/local/etc/haproxy/

# Regex to match valid domains, examples:
#  .*                                         any string/domain
#  ^intra\.example\.com$                      exacty intra.example.com
#  (\.i\.example\.com)$|(\.iana\.org)$        any subdomain under i.example.com or any subdomain under iana.org
ENV ACME_DOMAINS .*
# When the acme clients use redirects to serve the challenges, you must set this to TRUE
ENV ACME_HTTP01_ENABLE_REDIRECTS FALSE
