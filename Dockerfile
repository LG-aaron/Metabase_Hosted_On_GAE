FROM gcr.io/google-appengine/openjdk

EXPOSE 8080

ENV PORT 8080
ENV MB_PORT 8080
ENV MB_JETTY_PORT 8080

ENV MB_DB_TYPE: mysql
ENV MB_DB_DBNAME: metabase
ENV MB_DB_PORT: 3306
ENV MB_DB_USER: user
ENV MB_DB_PASS: secret
ENV MB_DB_HOST: 127.0.0.1

ENV JAVA_OPTS "-XX:+IgnoreUnrecognizedVMOptions -Dfile.encoding=UTF-8 --add-opens=java.base/java.net=ALL-UNNAMED --add-modules=java.xml.bind"

ADD https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 ./cloud_sql_proxy
ADD http://downloads.metabase.com/v0.28.1/metabase.jar ./metabase.jar

RUN chmod +x ./cloud_sql_proxy

CMD ./cloud_sql_proxy -instances=$METABASE_SQL_INSTANCE=tcp:$MB_DB_PORT & (java -jar ./metabase.jar migrate release-locks && java -jar ./metabase.jar)
