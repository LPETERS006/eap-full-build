FROM lpeters999/base-eap:latest as builder
RUN set -eux \
	&& cd /tmp/eap-build \
	&& ./build-eap7.sh 7.2.7 \
	&& cd ./dist \
	&& unzip jboss-eap-7.2.7.zip \
	&& cd /tmp \
	&& git clone https://github.com/LPETERS006/eap-full-build.git \
	&& cp -R -f /tmp/eap-full-build/7.2.7/files/* /tmp/eap-build/dist/jboss-eap-7.2/ \
	&& chmod 0777 /tmp/eap-build/dist/jboss-eap-7.2 && chmod -R a+rwX /tmp/eap-build/dist/jboss-eap-7.2;

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
    JBOSS_FR_DIR="/opt/jboss/standalone/fr" \
    LANG="C.UTF-8"
LABEL name="$JBOSS_IMAGE_NAME" \
      version="$JBOSS_IMAGE_VERSION" \
      architecture="x86_64"  \
      maintainer="LPETERS999"
RUN set -eux && mkdir -p /opt/jboss/
COPY --chown=1000:1000 --from=builder /tmp/eap-build/dist/jboss-eap-7.2 /opt/jboss
RUN set -eux && apk update \
        && apk add --no-cache --allow-untrusted -f --force-broken-world --clean-protected -u -U -l -q -v coreutils bash su-exec openjdk11 fontconfig ttf-dejavu \
        && ln -s -f "/usr/lib/jvm/java-11-openjdk/bin/javac" /usr/bin/javac \
        && chmod +x /opt/jboss/bin/*.sh \
        && rm -rf /var/cache/apk/* /tmp/* /tmp* /usr/share/man /var/tmp/* \
        && wait 
USER 1000
RUN /opt/jboss/bin/add-user.sh admin Admin#007 --silent
EXPOSE 8090 10000
WORKDIR /opt/jboss
VOLUME [ "/opt/jboss/standalone/deployments", "/opt/jboss/standalone/configuration", "/opt/jboss/fr" ]
ENTRYPOINT ["su-exec","1000:0" , "sh", "-c", "/opt/jboss/bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0 -Djboss.socket.binding.port-offset=10"]
