# eap-full-build
# Own compiled JBoss with postgres, postgis, hibernate-spatial (version specific)
(In case that publishing that images violates applicable law, please PM me! )

Now Transparent including compile of sources

TAG - Builds for the following versions :
latest-6.3.0, latest-6.3.3, latest-6.4.0, latest-6.4.2, latest-6.4.9, latest-6.4.10, latest-6.4.19, latest-6.4.20, latest-6.4.22
latest-7.1.0 latest-7.1.1, latest-7.1.2, latest-7.1.4, latest-7.2.0, latest-7.2.7, latest-7.3.0

# volumes for standalone and other stuff
    volumes:
      - './fr:/opt/jboss/fr'
      - './deployments:/opt/jboss/standalone/deployments'
      - './configuration:/opt/jboss/standalone/configuration'

# newer builds without modifed standalone.xml (everyone knows how to add drivers and datascources!)
      
(!! All files from configuration will exposed after first startup. Than you can easily edit standalone.xml and do a restart)

# moved 8080 -> 8090 & 9990 -> 10000 (offset +10)(conflict with another project from me, you can change back by editing [ENTRYPOINT] in Dockerfile)

    ports:
      - '8090:8090' 
      - '10000:10000'
