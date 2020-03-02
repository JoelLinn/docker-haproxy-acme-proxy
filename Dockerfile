FROM haproxy:2.1

RUN apt-get update && apt-get install -y lua-http lua-socket && apt-get clean

COPY haproxy.cfg /usr/local/etc/haproxy/

COPY haproxy-acme-validation-proxy-plugin/acme-http01-webroot.lua /usr/local/etc/haproxy/

# Regex to match valid domains, examples:
#  .*                                         any string/domain
#  ^intra\.example\.com$                      exacty intra.example.com
#  (\.i\.example\.com)$|(\.iana\.org)$        any subdomain under i.example.com or any subdomain under iana.org
ENV ACME_DOMAINS .*
# When the acme clients use redirects to serve the challenges, you must set this to TRUE
ENV ACME_HTTP01_ENABLE_REDIRECTS FALSE
