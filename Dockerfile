FROM lpeters999/base-eap:latest as builder
RUN cd /tmp/eap-build \
	&& ./build-eap7.sh 7.1.1 \
	&& cd ./dist	\
	&& unzip jboss-eap-7.1.1.zip \
	&& mv jboss-eap-7.1 $JBOSS_HOME 
	
FROM alpine:latest	
ENV JBOSS_IMAGE_NAME="lpeters999/jboss-eap-alpine" \
    JBOSS_IMAGE_VERSION="7.1.1" \
    LAUNCH_JBOSS_IN_BACKGROUND="true" \
    JBOSS_PRODUCT="eap" \
    JBOSS_EAP_VERSION="7.1.1" \
    PRODUCT_VERSION="7.1.1" \
    JBOSS_HTTP_PORT="8090" \
    JBOSS_HOME="/opt/jboss" \
    JBOSS_CONFIG_DIR="/opt/jboss/standalone/configuration" \
    JBOSS_DEPLOY_DIR="/opt/jboss/standalone/deployments" \
    LANG="C.UTF-8"
LABEL name="$JBOSS_IMAGE_NAME" \
      version="$JBOSS_IMAGE_VERSION" \
      architecture="x86_64"  \
      maintainer="LPETERS999"	
COPY --from=builder /opt/jboss /opt/jboss
ADD https://github.com/LPETERS006/eap-full-build/blob/7.1.1/files /opt/jboss
RUN apk update \
	&& apk add --no-cache --allow-untrusted -f --force-broken-world --clean-protected -u -U -l -q -v apk-tools openjdk8 fontconfig ttf-dejavu wget \
	&& ln -s -f "/usr/lib/jvm/java-1.8-openjdk/bin/javac" /usr/bin/javac \ 
	&& addgroup -g 888 -S jboss \
	&& adduser -u 888 -D -h ${JBOSS_HOME} -s /bin/ash -S jboss -G root \
	&& chown -R 888:root /opt/jboss && chmod 0755 /opt/jboss && chmod -R g+rwX /opt/jboss \
	&& chmod +x ${JBOSS_HOME}/bin/add-user.sh \
	&& wait \
	&& rm -rf /var/cache/apk/* /tmp/* /tmp* /usr/share/man /var/tmp/* 

USER 888
RUN ${JBOSS_HOME}/bin/add-user.sh admin Admin#007 --silent
EXPOSE 8090 9990
CMD ["sh", "-c", "${JBOSS_HOME}/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0", "-Dhttp.port=${JBOSS_HTTP_PORT}", "default"]
