#!/bin/bash
service ssh start

# Get environment variables to show up in SSH session
eval $(printenv | awk -F= '{print "export " $1"="$2 }' >> /etc/profile)

# Add SSH Port to config
sed -i "s/SSH_PORT/$SSH_PORT/g" /etc/ssh/sshd_config

if [ -f /opt/spring-boot/mycert.crt ]; then 
    echo 'Applying custom certificate'
    keytool -import -trustcacerts -keystore cacerts -storepass changeit -noprompt -alias mycert -file /opt/spring-boot/mycert.crt
fi

if [[ -n "$APPLICATIONINSIGHTS_CONNECTION_STRING" ]]; then
    echo 'Enabling Application Insights Java agent'
    export JAVA_AGENT="-javaagent:/opt/spring-boot/applicationinsights-agent-3.0.0-PREVIEW.3.jar"
fi

# Give control to the CMD in the Dockerfile
exec "$@"
