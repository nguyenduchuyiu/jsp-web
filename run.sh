#!/bin/bash
ant clean dist
sudo rm -rf /opt/tomcat/webapps/BaiTapLon
sudo cp dist/BaiTapLon.war /opt/tomcat/webapps/
sudo /opt/tomcat/bin/shutdown.sh || true
sleep 2
sudo /opt/tomcat/bin/startup.sh
echo "Waiting for Tomcat to extract WAR..."
sleep 5
echo "Deployment complete. Access at: http://localhost:8080/BaiTapLon/home"