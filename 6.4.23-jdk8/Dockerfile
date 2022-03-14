FROM lpeters999/base-eap:et_jdk8-alpine as builder
RUN cd /tmp/eap-build && ./build-eap6.sh 6.4.23 && cd ./dist && unzip jboss-eap-6.4.23.zip >/dev/null && cd /tmp && \ 
    git clone https://github.com/LPETERS006/eap-full-build.git && \
    cp -R -f /tmp/eap-full-build/6.4.23-jdk8/files/* /tmp/eap-build/dist/jboss-eap-6.4/ >/dev/null && \
    addgroup -g 888 -S jboss && adduser -u 888 -D -h /tmp/eap-build/dist/jboss-eap-6.4 -s /bin/ash -S jboss -G root && \
    chown -R 888:root /tmp/eap-build/dist/jboss-eap-6.4 && chmod 0755 /tmp/eap-build/dist/jboss-eap-6.4 && chmod -R g+rwX /tmp/eap-build/dist/jboss-eap-6.4

FROM eclipse-temurin:8-jdk-alpine
LABEL name="$JBOSS_IMAGE_NAME" version="$JBOSS_IMAGE_VERSION" architecture="x86_64" maintainer="LPETERS999"
ENV JBOSS_IMAGE_NAME="lpeters999/eap-full-ci" \
    JBOSS_IMAGE_VERSION="6.4.23-jdk8" \
    LAUNCH_JBOSS_IN_BACKGROUND="true" \
    JBOSS_PRODUCT="eap" \
    JBOSS_EAP_VERSION="6.4.23" \
    PRODUCT_VERSION="6.4.23" \
    EAP_HOME="/opt/jboss" \
    JBOSS_HTTP_PORT="8090" \
    JBOSS_HOME="/opt/jboss" \
    JBOSS_CONFIG_DIR="/opt/jboss/standalone/configuration" \
    JBOSS_DEPLOY_DIR="/opt/jboss/standalone/deployments" \
    LANG="C.UTF-8" \
    JAVA_OPTS="-Xms1303m -Xmx2048m -XX:MaxPermSize=1024m -XX:MetaspaceSize=256M -Djava.net.preferIPv4Stack=true"
RUN mkdir -p /opt/jboss/ /opt/jboss/fr
COPY --from=builder --chown=888:root /tmp/eap-build/dist/jboss-eap-6.4 /opt/jboss
RUN addgroup -g 888 -S jboss && adduser -u 888 -D -h ${JBOSS_HOME} -s /bin/ash -S jboss -G root && chmod +x ${JBOSS_HOME}/bin/*.sh && \
	apk update && apk add --no-cache --allow-untrusted -f --clean-protected -u -l -q -v fontconfig ttf-dejavu && \
	rm -rf /var/cache/apk/* && wait
USER 888
RUN ${JBOSS_HOME}/bin/add-user.sh admin Admin#007 --silent
EXPOSE 8090 10000
#VOLUME [ "/opt/jboss/standalone/deployments", "/opt/jboss/standalone/configuration", "/opt/jboss/fr" ]

ENTRYPOINT ["sh", "-c", "/opt/jboss/bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0 -Djboss.socket.binding.port-offset=10"]