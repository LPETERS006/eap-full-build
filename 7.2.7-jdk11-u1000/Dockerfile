FROM lpeters999/base-eap:gosu as builder
USER 0
RUN addgroup -g 888 -S jboss \
		&& adduser -u 888 -D -h /opt/jboss -s /bin/ash -S jboss -G jboss \
		&& cut -d: -f1 /etc/group | xargs -n1 addgroup nobody \
 		&& cd /tmp/eap-build \
        && ./build-eap7.sh 7.2.7 \
        && cd ./dist \
        && unzip jboss-eap-7.2.7.zip \
        && cd /tmp \
        && git clone https://github.com/LPETERS006/eap-full-build.git \
        && cp -R -f /tmp/eap-full-build/7.2.7/files/* /tmp/eap-build/dist/jboss-eap-7.2/ \
        && chown -R 888:888 /tmp/eap-build/dist/jboss-eap-7.2 && chmod -R 0755 /tmp/eap-build/dist/jboss-eap-7.2

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
	LANG="C.UTF-8" \
	GOSU_VERSION="1.12"
LABEL name="$JBOSS_IMAGE_NAME" \
      version="$JBOSS_IMAGE_VERSION" \
      architecture="x86_64"  \
      maintainer="LPETERS999"
RUN mkdir -p /opt/jboss/
COPY --from=builder /tmp/eap-build/dist/jboss-eap-7.2 /opt/jboss
RUN set -eux \
		&& apk update \
        && apk add --no-cache --allow-untrusted -f --force-broken-world --clean-protected -u -U -l -q -v openjdk11 fontconfig ttf-dejavu \
        && ln -s -f "/usr/lib/jvm/java-11-openjdk/bin/javac" /usr/bin/javac \
        && apk add --no-cache --virtual .gosu-deps ca-certificates dpkg gnupg \
		&& dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
		&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
		&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" \
		&& export GNUPGHOME="$(mktemp -d)" \
		&& gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
		&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
		&& command -v gpgconf && gpgconf --kill all || : \
		&& rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc \
		&& apk del --no-network .gosu-deps \
		&& chmod +x /usr/local/bin/gosu \
		&& gosu --version \
		&& gosu nobody true \
		&& addgroup -g 888 -S jboss \
		&& adduser -u 888 -D -h /opt/jboss -s /bin/ash -S jboss -G jboss \
		&& cut -d: -f1 /etc/group | xargs -n1 addgroup nobody \
        && chmod +x /opt/jboss/bin/add-user.sh \
        && rm -rf /var/cache/apk/* /tmp/* /tmp* /usr/share/man /var/tmp/* \
        && wait \
        && mkdir -p /opt/jboss/fr \
		&& chmod -R 755 /opt/jboss
USER 888
RUN /opt/jboss/bin/add-user.sh admin Admin#007 --silent
EXPOSE 8090 10000
WORKDIR /opt/jboss
VOLUME [ "/opt/jboss/standalone/configuration", "/opt/jboss/standalone/deployments", "/opt/jboss/fr" ]
ENTRYPOINT ["sh", "-c", "/opt/jboss/bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0 -Djboss.socket.binding.port-offset=10"]
