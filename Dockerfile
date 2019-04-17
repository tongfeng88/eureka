FROM anapsix/alpine-java:8_server-jre_unlimited

MAINTAINER wangiegie@gmail.com

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN mkdir -p /pigx-eureka

WORKDIR /pigx-eureka

EXPOSE 8761

ADD ./target/pigx-eureka-2.7.0.jar ./

CMD java -Djava.security.egd=file:/dev/./urandom -jar pigx-eureka-2.7.0.jar
