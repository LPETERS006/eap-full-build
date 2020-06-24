FROM lpeters999/base-eap:latest as builder
RUN set -eux; \
	addgroup -g 71 -S jboss; \
	adduser -u 71 -S -D -G jboss -H -h /tmp/eap-build -s /bin/ash -S jboss; \
	mkdir -p /tmp/eap-build; \
	chown -R jboss:jboss /tmp/eap-build
WORKDIR /opt/jboss
RUN set -ex \
		&& cd /tmp/eap-build \
        && ./build-eap7.sh 7.2.7 \
        && cd ./dist \
        && unzip jboss-eap-7.2.7.zip \
        && cd /tmp \
        && git clone https://github.com/LPETERS006/eap-full-build.git \
        && cp -R -f /tmp/eap-full-build/7.2.7/files/* /tmp/eap-build/dist/jboss-eap-7.2/ \
        && chown -R jboss:jboss /tmp/eap-build/dist/jboss-eap-7.2 && chmod -R 2777 /tmp/eap-build/dist/jboss-eap-7.2

FROM alpine:latest
ENV JBOSS_IMAGE_NAME="lpeters999/eap-full-ci" \
    JBOSS_IMAGE_VERSION="7.2.7-jdk11-u0" \
    LAUNCH_JBOSS_IN_BACKGROUND="true" \
    JBOSS_PRODUCT="eap" \
    JBOSS_EAP_VERSION="7.2.7" \
    PRODUCT_VERSION="7.2.7" \
    JBOSS_HTTP_PORT="8090" \
    JBOSS_HOME="/opt/jboss" \
    JBOSS_CONFIG_DIR="/opt/jboss/standalone/configuration" \
    JBOSS_DEPLOY_DIR="/opt/jboss/standalone/deployments" \
    JBOSS_FR_DIR="/opt/jboss/fr" \
	LANG="en_US.utf8" \
	GOSU_VERSION="1.12"
LABEL name="$JBOSS_IMAGE_NAME" \
      version="$JBOSS_IMAGE_VERSION" \
      architecture="x86_64"  \
      maintainer="LPETERS999"

RUN set -eux \
	&& addgroup -g 71 -S jboss && adduser -u 71 -S -D -G jboss -H -h /opt/jboss -s /bin/ash -S jboss \
	&& mkdir -p /opt/jboss && mkdir -p /opt/jboss/fr && chown -R jboss:jboss /opt/jboss
	
COPY --from=builder /tmp/eap-build/dist/jboss-eap-7.2 /opt/jboss

RUN set -eux && apk update && apk add --no-cache --virtual .fetch-deps dpkg gnupg openssl tar \
        && apk add --no-cache --allow-untrusted -f --force-broken-world --clean-protected -u -U -l -q -v openjdk11 coreutils fontconfig ttf-dejavu icu ca-certificates \
		&& ln -s -f "/usr/lib/jvm/java-11-openjdk/bin/javac" /usr/bin/javac \
		&& runDeps="$( \
			scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
		)" \
		&& apk add --no-cache --virtual .jboss-rundeps $runDeps bash su-exec tzdata \
		&& apk del .fetch-deps \
		&& cd / && find /usr/local -name '*.a' -delete \
	    && chown -R jboss:jboss "$JBOSS_HOME" && chmod 2777 "$JBOSS_HOME" \
		&& chown -R jboss:jboss "$JBOSS_CONFIG_DIR" && chmod 777 "$JBOSS_CONFIG_DIR" \
		&& chown -R jboss:jboss "$JBOSS_DEPLOY_DIR" && chmod 777 "$JBOSS_DEPLOY_DIR" \
		&& chown -R jboss:jboss "$JBOSS_FR_DIR" && chmod 777 "$JBOSS_FR_DIR" \        
		&& chmod +x /opt/jboss/bin/add-user.sh && chmod +x /opt/jboss/bin/standalone.sh \
        && rm -rf /var/cache/apk/* /tmp/* /tmp* /usr/share/man /var/tmp/* \
        && wait	
VOLUME [ "/opt/jboss/standalone/configuration", "/opt/jboss/standalone/deployments", "/opt/jboss/fr" ]		
WORKDIR /opt/jboss
RUN  ["sh", "-c", "/opt/jboss/bin/add-user.sh admin Admin#007 --silent"]
EXPOSE 8090 10000
ENTRYPOINT ["sh", "-c", "/opt/jboss/bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0 -Djboss.socket.binding.port-offset=10"]
