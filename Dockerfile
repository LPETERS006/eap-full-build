FROM lpeters999/base-eap:latest as builder
RUN cd /tmp/eap-build \
	&& ./build-eap6.sh 6.3.3 \
	&& cd ./dist	\
	&& unzip jboss-eap-6.3.3.zip \
	&& cd /tmp \
	&& git clone -b 6.3.3 https://github.com/LPETERS006/eap-full-build.git \
	&& cp -R -f /tmp/eap-full-build/files/* /tmp/eap-build/dist/jboss-eap-6.3/ \
	&& addgroup -g 888 -S jboss \
	&& adduser -u 888 -D -h /tmp/eap-build/dist/jboss-eap-6.3 -s /bin/ash -S jboss -G root \
	&& chown -R 888:root /tmp/eap-build/dist/jboss-eap-6.3 && chmod 0755 /tmp/eap-build/dist/jboss-eap-6.3 && chmod -R g+rwX /tmp/eap-build/dist/jboss-eap-6.3
	
FROM alpine:latest	
ENV JBOSS_IMAGE_NAME="lpeters999/eap-full-ci" \
    JBOSS_IMAGE_VERSION="6.3.3" \
    LAUNCH_JBOSS_IN_BACKGROUND="true" \
    JBOSS_PRODUCT="eap" \
    JBOSS_EAP_VERSION="6.3.3" \
    PRODUCT_VERSION="6.3.3" \
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
COPY --from=builder /tmp/eap-build/dist/jboss-eap-6.3 /opt/jboss
RUN apk update \
	&& apk add --no-cache --allow-untrusted -f --force-broken-world --clean-protected -u -U -l -q -v openjdk8 fontconfig ttf-dejavu \
	&& ln -s -f "/usr/lib/jvm/java-1.8-openjdk/bin/javac" /usr/bin/javac \ 
	&& addgroup -g 888 -S jboss \
	&& adduser -u 888 -D -h ${JBOSS_HOME} -s /bin/ash -S jboss -G root \
	&& chmod +x ${JBOSS_HOME}/bin/add-user.sh \
	&& rm -rf /var/cache/apk/* /tmp/* /tmp* /usr/share/man /var/tmp/* \ 
	&& wait 
USER 888
RUN ${JBOSS_HOME}/bin/add-user.sh admin Admin#007 --silent
EXPOSE 8090 9990
CMD ["sh", "-c", "${JBOSS_HOME}/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0", "-Dhttp.port=${JBOSS_HTTP_PORT}", "default"]
