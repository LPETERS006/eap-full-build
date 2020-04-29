# eap-full-build
# Own compiled JBoss with postgres, postgis (hibernate-spatial)
(In case that publishing that images violates applicable law, please PM me! )

Now Transparent including compile of sources

# volumes for standalone and other stuff
    volumes:
      - './fr:/opt/jboss/fr'
      - './deployments:/opt/jboss/standalone/deployments'
      - './configuration:/opt/jboss/standalone/configuration'
      
(!! All files from configuration will exposed after first startup. Than you can easily edit standalone.xml and do a restart)

# moved 8080 to 8090
    ports:
      - '8090:8090' 
      - '9999:9999'
