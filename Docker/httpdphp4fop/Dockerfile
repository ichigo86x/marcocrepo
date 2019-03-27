# ASI
FROM i386/centos:6
 
# AGGIORNO E INSTALLO REQUISITI
RUN sed -i 's/\$arch/i686/g' /etc/yum.repos.d/*
RUN sed -i 's/\$basearch/i386/g' /etc/yum.repos.d/*

RUN yum clean all
RUN yum update -y

RUN yum clean all
RUN yum install -y gcc* make expat* expat bison* flex curl* libcurl* curl-devel* libcurl-devel* openssl 

#INSTALLAZIONE APACHE
RUN yum clean all
RUN yum install -y httpd mod_ssl httpd-devel

#COPIO SOFTWARE DA COMPILARE
RUN mkdir /tmp/src
COPY src/Sablot-1.0.3.tar.gz /tmp/src/Sablot-1.0.3.tar.gz
COPY src/php-4.4.9.tar.gz /tmp/src/php-4.4.9.tar.gz
COPY src/fop-0.20.5-src.tar.gz /tmp/src/fop-0.20.5-src.tar.gz
COPY src/j2sdk-1_4_2_12-linux-i586.bin /tmp/src/j2sdk-1_4_2_12-linux-i586.bin
COPY src/xorg-x11-deprecated-libs-6.8.2-31.i386.rpm /tmp/src/xorg-x11-deprecated-libs-6.8.2-31.i386.rpm

#SABLOT
RUN cd /tmp/src && \
    tar xvzf Sablot-1.0.3.tar.gz && \
    cd Sablot-1.0.3 && \
    ./configure --prefix=/usr/local/sablotron && \
    make && \
    make install

#PHP 449
RUN cd /tmp/src && \
    tar xvzf php-4.4.9.tar.gz && \
    cd php-4.4.9 && \
    ./configure --prefix=/usr/local/php-4.4.9 --enable-xslt --with-xslt --with-xslt-sablot=/usr/local/sablotron --with-config-file-path=/usr/local/php-4.4.9 --with-apxs2=/usr/sbin/apxs --enable-trans-sid --enable-calendar --with-curl=/usr/include/curl && \
    make && \
    make install

#JDK
RUN cd /tmp/src && \
    chmod 777 j2sdk-1_4_2_12-linux-i586.bin && \
    yes | ./j2sdk-1_4_2_12-linux-i586.bin && \
    mv j2sdk1.4.2_12 /usr/local/j2sdk1.4.2_12 && \
    export JAVA_HOME=/usr/local/j2sdk1.4.2_12

#FOP
RUN cd /tmp/src && \
    tar xvzf fop-0.20.5-src.tar.gz && \
    cd fop-0.20.5 && \
    export JAVA_HOME=/usr/local/j2sdk1.4.2_12 && \
    ./build.sh

RUN cd /tmp/src && \
    rpm -i xorg-x11-deprecated-libs-6.8.2-31.i386.rpm  && \
    mv fop-0.20.5 /usr/local/fop-0.20.5

#VARIABILI D'AMBIENTE
RUN echo 'export PATH="/usr/local/fop-0.20.5/":$PATH:$HOME/bin' >> /root/.bash_profile
RUN echo 'export JAVA_HOME="/usr/local/j2sdk1.4.2_12/"' >> /root/.bash_profile

RUN mkdir /data && \
    mkdir /data/conf && \
    mkdir /data/conf/httpd && \
    mkdir /data/conf/php && \
    mv /etc/httpd/conf /data/conf/httpd/ && \
    mv /etc/httpd/conf.d /data/conf/httpd/ && \
    ln -s /etc/httpd/conf /data/conf/httpd/conf && \
    ln -s /etc/httpd/conf.d /data/conf/httpd/conf.d && \
    rm -f /usr/local/php-4.4.9/php.ini && \
    ln -s /usr/local/php-4.4.9/php.ini /data/conf/php/php.ini

#COPIO CONFIGURAZIONI APACHE/PHP
COPY src/httpd.conf /data/conf/httpd/conf/httpd.conf
COPY src/php.ini /data/conf/php/php.ini

#LOG TO STDIN e STDOUT
# RUN sed -ri \
# 		-e 's!^(\s*CustomLog)\s+\S+!\1 /proc/self/fd/1!g' \
# 		-e 's!^(\s*ErrorLog)\s+\S+!\1 /proc/self/fd/2!g' \
#         "/etc/httpd/conf/httpd.conf"

#AVVIO AUTOMATICO
RUN chkconfig --level 345 httpd on

#VOLUMES
VOLUME ["/var/www/html"]
VOLUME ["/data/conf"]

EXPOSE 80
CMD ["/sbin/init"]
