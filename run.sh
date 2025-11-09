ant clean dist
cp dist/BaiTapLon.war /opt/tomcat/webapps/
/opt/tomcat/bin/shutdown.sh || true
sleep 2
/opt/tomcat/bin/startup.sh