set -Eeo pipefail

local user; user="$(id -u)"

DIR="/home/jboss/standalone/configuration/standalone_xml_history"

if [ -d "$DIR" ]; then
	ln /opt/jboss/standalone /home/jboss/standalone
	else
		echo
		echo 'PostgreSQL Database directory appears to contain a database; Skipping initialization'
		echo
	fi
	
if [ "$user" = '0' ]; then
	find "/home/jboss/standalone" \! -user jboss -exec chown jboss '{}' +
fi
	chmod 700 "/home/jboss/standalone"
fi

if [ "$user" = '0' ]; then
	find "/opt/jboss/standalone" \! -user jboss -exec chown jboss '{}' +
	find /home/jboss/standalone \! -user jboss -exec chown jboss '{}' +
fi
