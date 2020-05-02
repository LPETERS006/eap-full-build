# eap-full-build
# Own compiled JBoss with postgres, postgis (hibernate-spatial)
(In case that publishing that images violates applicable law, please PM me! )

Now Transparent including compile of sources

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
