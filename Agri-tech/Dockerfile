FROM tomcat:9.0-jdk11-openjdk-slim

RUN rm -rf /usr/local/tomcat/webapps/*

ADD https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.28/mysql-connector-java-8.0.28.jar /usr/local/tomcat/lib/

COPY . /usr/local/tomcat/webapps/ROOT/

EXPOSE 8080

CMD sh -c "sed -i 's/8080/'\"$PORT\"'/g' /usr/local/tomcat/conf/server.xml && catalina.sh run"

