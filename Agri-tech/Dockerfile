FROM tomcat:9.0-jdk11-openjdk-slim

# 1. Clean out default Tomcat files
RUN rm -rf /usr/local/tomcat/webapps/*

# 2. Add MySQL Driver to Tomcat's library
ADD https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.28/mysql-connector-java-8.0.28.jar /usr/local/tomcat/lib/

# 3. Copy your web content. 
# We must include the 'Agri-tech/' prefix here because the build starts from the repo root.
COPY Agri-tech/WebContent/ /usr/local/tomcat/webapps/ROOT/

# 4. Standard Tomcat Port
EXPOSE 8080

CMD ["catalina.sh", "run"]
