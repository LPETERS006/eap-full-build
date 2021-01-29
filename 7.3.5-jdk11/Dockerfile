FROM lpeters999/base-eap:3.12 as builder
RUN cd /tmp/eap-build \
        && ./build-eap7.sh 7.3.5 \
        && cd ./dist \
        && unzip jboss-eap-7.3.5.zip \
        && cd /tmp \
        && git clone https://github.com/LPETERS006/eap-full-build.git \
        && cp -R -f /tmp/eap-full-build/7.3.5-jdk11/files/* /tmp/eap-build/dist/jboss-eap-7.3/ \
        && addgroup -g 888 -S jboss \
        && adduser -u 888 -D -h /tmp/eap-build/dist/jboss-eap-7.3 -s /bin/ash -S jboss -G root \
        && chown -R 888:root /tmp/eap-build/dist/jboss-eap-7.3 && chmod 0755 /tmp/eap-build/dist/jboss-eap-7.3 && chmod -R g+rwX /tmp/eap-build/dist/jboss-eap-7.3

FROM alpine:3.12
ENV JBOSS_IMAGE_NAME="lpeters999/eap-full-ci" \
    JBOSS_IMAGE_VERSION="7.3.5-jdk11" \
    LAUNCH_JBOSS_IN_BACKGROUND="true" \
    JBOSS_PRODUCT="eap" \
    JBOSS_EAP_VERSION="7.3.5" \
    PRODUCT_VERSION="7.3.5" \
	EAP_HOME="/opt/jboss" \
    JBOSS_HTTP_PORT="8090" \
    JBOSS_HOME="/opt/jboss" \
    JBOSS_CONFIG_DIR="/opt/jboss/standalone/configuration" \
    JBOSS_DEPLOY_DIR="/opt/jboss/standalone/deployments" \
    LANG="C.UTF-8" \
    JAVA_OPTS="-Xms1303m -Xmx2048m -XX:MaxPermSize=1024m -XX:MetaspaceSize=256M -Djava.net.preferIPv4Stack=true --add-modules=ALL-SYSTEM"
LABEL name="$JBOSS_IMAGE_NAME" \
      version="$JBOSS_IMAGE_VERSION" \
      architecture="x86_64"  \
      maintainer="LPETERS999"
RUN mkdir -p /opt/jboss/ \
	&& mkdir -p /opt/jboss/fr
COPY --from=builder --chown=888:root /tmp/eap-build/dist/jboss-eap-7.3 /opt/jboss
RUN addgroup -g 888 -S jboss && \
	adduser -u 888 -D -h ${JBOSS_HOME} -s /bin/ash -S jboss -G root && \
	chmod +x ${JBOSS_HOME}/bin/*.sh && \
	apk update && \ 
	apk add --no-cache --allow-untrusted -f --clean-protected -u -l -q -v apk-tools openjdk11 fontconfig ttf-dejavu && \
	wait && \
	rm -rf /var/cache/apk/* && \ 
	ln -s -f "/usr/lib/jvm/java-11-openjdk/bin/javac" /usr/bin/javac && \ 
	wait
USER 888
RUN ${JBOSS_HOME}/bin/add-user.sh admin Admin#007 --silent
EXPOSE 8090 10000
#VOLUME [ "/opt/jboss/standalone/deployments", "/opt/jboss/standalone/configuration", "/opt/jboss/fr" ]
ENTRYPOINT ["sh", "-c", "/opt/jboss/bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0 -Djboss.socket.binding.port-offset=10"]
