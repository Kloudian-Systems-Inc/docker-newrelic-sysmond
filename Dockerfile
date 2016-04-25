FROM        alpine:3.3
MAINTAINER  Orbweb Inc. <engineering@orbweb.com>

ENV         NEW_RELIC_SYSMOND_VERSION 2.3.0.129

RUN         apk --no-cache add --virtual .build-deps \
                build-base \
                curl && \
            curl -sL https://download.newrelic.com/server_monitor/release/newrelic-sysmond-$NEW_RELIC_SYSMOND_VERSION-linux.tar.gz | tar xz && \
            mkdir -p /etc/newrelic && \
            (cd newrelic-sysmond-$NEW_RELIC_SYSMOND_VERSION-linux && \
                cp daemon/nrsysmond.x64 /usr/bin/nrsysmond && \
                cp scripts/nrsysmond-config /usr/bin && \
                cp nrsysmond.cfg /etc/newrelic/nrsysmond.cfg) && \
            chmod +x /usr/bin/nrsysmond && \
            chmod +x /usr/bin/nrsysmond-config && \
            rm -rf newrelic-sysmond-$NEW_RELIC_SYSMOND_VERSION-linux && \
            apk --no-cache add --virtual .run-deps \
                ssl
            apk del .build-deps
CMD         ["nrsysmond", "-E", "-F"]
