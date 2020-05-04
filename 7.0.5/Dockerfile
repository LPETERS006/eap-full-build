FROM lpeters999/base-eap:latest as builder

RUN cd /tmp \
        && git clone https://github.com/LPETERS006/eap-full-build.git \
		&& cp -f /tmp/eap-full-build/7.0.5/jboss-eap-7.properties /tmp/eap-build/src/jboss-eap-7.properties \
		&& cd /tmp/eap-build \
        && ./build-eap7.sh 7.0.5 \
        && cd ./dist \
        && unzip jboss-eap-7.0.5.zip \
        && cp -R -f /tmp/eap-full-build/7.0.5/files/* /tmp/eap-build/dist/jboss-eap-7.0/ \
        && addgroup -g 888 -S jboss \
        && adduser -u 888 -D -h /tmp/eap-build/dist/jboss-eap-7.0 -s /bin/ash -S jboss -G root \
        && chown -R 888:root /tmp/eap-build/dist/jboss-eap-7.0 && chmod 0755 /tmp/eap-build/dist/jboss-eap-7.0 && chmod -R g+rwX /tmp/eap-build/dist/jboss-eap-7.0

FROM alpine:latest
ENV JBOSS_IMAGE_NAME="lpeters999/eap-full-ci" \
    JBOSS_IMAGE_VERSION="7.0.5" \
    LAUNCH_JBOSS_IN_BACKGROUND="true" \
    JBOSS_PRODUCT="eap" \
    JBOSS_EAP_VERSION="7.0.5" \
    PRODUCT_VERSION="7.0.5" \
    JBOSS_HTTP_PORT="8090" \
    JBOSS_HOME="/opt/jboss" \
    JBOSS_CONFIG_DIR="/opt/jboss/standalone/configuration" \
    JBOSS_DEPLOY_DIR="/opt/jboss/standalone/deployments" \
    LANG="C.UTF-8"
LABEL name="$JBOSS_IMAGE_NAME" \
      version="$JBOSS_IMAGE_VERSION" \
      architecture="x86_64"  \
      maintainer="LPETERS999"
RUN mkdir -p /opt/jboss/
COPY --from=builder /tmp/eap-build/dist/jboss-eap-7.0 /opt/jboss
RUN apk update \
        && apk add --no-cache --allow-untrusted -f --force-broken-world --clean-protected -u -U -l -q -v openjdk8 fontconfig ttf-dejavu \
        && ln -s -f "/usr/lib/jvm/java-1.8-openjdk/bin/javac" /usr/bin/javac \
        && addgroup -g 888 -S jboss \
        && adduser -u 888 -D -h /opt/jboss -s /bin/ash -S jboss -G root \
        && chmod +x /opt/jboss/bin/add-user.sh \
        && rm -rf /var/cache/apk/* /tmp/* /tmp* /usr/share/man /var/tmp/* \
        && wait
USER 888
RUN /opt/jboss/bin/add-user.sh admin Admin#007 --silent
EXPOSE 8090 10000
WORKDIR /opt/jboss
ENTRYPOINT ["sh", "-c", "/opt/jboss/bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0 -Djboss.socket.binding.port-offset=10"]
