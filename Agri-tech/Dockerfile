FROM tomcat:9.0-jdk11-openjdk-slim

# 1. Remove default Tomcat apps
RUN rm -rf /usr/local/tomcat/webapps/*

# 2. Add MySQL Driver
ADD https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.28/mysql-connector-java-8.0.28.jar /usr/local/tomcat/lib/

# 3. Copy your project files
COPY . /usr/local/tomcat/webapps/ROOT/

# 4. Expose port
EXPOSE 8080

CMD sh -c "sed -i \"s/port=\\\"8080\\\"/port=\\\"$PORT\\\"/\" /usr/local/tomcat/conf/server.xml && catalina.sh run"
