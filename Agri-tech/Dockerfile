FROM tomcat:9.0-jdk11-openjdk-slim

# 1. Clean out default Tomcat files
RUN rm -rf /usr/local/tomcat/webapps/*

# 2. Add MySQL Driver to Tomcat's library
ADD https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.28/mysql-connector-java-8.0.28.jar /usr/local/tomcat/lib/

# 3. Copy your web content. 
# We use '*' to ensure we grab everything inside the WebContent folder
COPY WebContent/ /usr/local/tomcat/webapps/ROOT/

# 4. Set the Port
EXPOSE 8080

CMD ["catalina.sh", "run"]
