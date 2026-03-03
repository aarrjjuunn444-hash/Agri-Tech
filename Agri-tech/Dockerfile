FROM tomcat:9.0-jdk11-openjdk-slim

# 1. Clean out default Tomcat files
RUN rm -rf /usr/local/tomcat/webapps/*

# 2. Ensure the ROOT directory exists
RUN mkdir -p /usr/local/tomcat/webapps/ROOT

# 3. Add MySQL Driver (Download directly to Tomcat libs)
ADD https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.28/mysql-connector-java-8.0.28.jar /usr/local/tomcat/lib/

# 4. Copy your web content
# IMPORTANT: Use '.' to copy the CONTENTS of WebContent, not the folder itself
COPY /usr/local/tomcat/webapps/ROOT/

# 5. Set the Port (Railway expects 8080 by default for Tomcat)
EXPOSE 8080

CMD ["catalina.sh", "run"]
