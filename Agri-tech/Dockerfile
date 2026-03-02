FROM tomcat:9.0-jdk11-openjdk-slim

# 1. Clean out default Tomcat files
RUN rm -rf /usr/local/tomcat/webapps/*

# 2. Add MySQL Driver
ADD https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.28/mysql-connector-java-8.0.28.jar /usr/local/tomcat/lib/

# 3. Copy your WebContent folder
# This assumes 'WebContent' is INSIDE your 'Agri-tech' folder
COPY WebContent/ /usr/local/tomcat/webapps/ROOT/

EXPOSE 8080

CMD ["catalina.sh", "run"]
