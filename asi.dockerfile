# ASI
FROM centos:6

# AGGIORNO E INSTALLO REQUISITI
RUN yum update -y
#COMPILAZIONE
RUN yum install -y gcc*
RUN yum install -y make
#SABLOT
RUN yum install -y expat*
#PHP
RUN yum install -y bison*
RUN yum install -y flex
RUN yum install -y curl*
#APACHE
RUN yum install -y openssl

#INSTALLAZIONE APACHE
RUN yum install httpd mod_ssl
RUN yum install httpd-devel

#COPIO SOFTWARE DA COMPILARE
RUN mkdir /tmp/src
COPY /root/src/* /tmp/src/

#SABLOT
RUN cd /tmp/src
RUN tar xvzf Sablot-1.0.3.tar.gz
RUN cd Sablot-1.0.3
RUN ./configure --prefix=/usr/local/sablotron
RUN make
RUN make install

# FreeTDS ( MSSQL Lib )
# RUN cd /tmp
# RUN tar xvzf freetds-stable.tgz
# RUN cd freetds-0.64
# RUN ./configure --prefix=/usr/local/freetds --enable-msdblib
# RUN make
# RUN make install

#PHP 449
RUN cd /tmp/src
RUN tar xvzf php-4.4.9.tar.gz
RUN cd php-4.4.9
RUN ./configure --prefix=/usr/local/php-4.4.9 --enable-xslt --with-xslt --with-xslt-sablot=/usr/local/sablotron --with-config-file-path=/usr/local/php-4.4.9 --with-apxs2=/usr/sbin/apxs --enable-trans-sid --enable-calendar --with-mssql=/usr/local/freetds/ --with-curl=/usr/include/curl
RUN make
RUN make install

#JDK
RUN cd /tmp/src
RUN ./j2sdk-1_4_2_12-linux-i586.bin
RUN mv j2sdk1.4.2_12 /usr/local/j2sdk1.4.2_12
RUN export JAVA_HOME=/usr/local/j2sdk1.4.2_12

#FOP
RUN cd /tmp/src
RUN tar xvzf fop-0.20.5-src.tar.gz
RUN cd fop-0.20.5
RUN ./build.sh

RUN cd /tmp/src
RUN rpm -i xorg-x11-deprecated-libs-6.8.2-31.i386.rpm 

RUN mv fop-0.20.5 /usr/local/fop-0.20.5

#VARIABILI D'AMBIENTE
RUN sed -i "s/'export PATH'//g" /root/.bash_profile 
RUN sed -i "s/'PATH=$PATH:$HOME/bin'//g" /root/.bash_profile
RUN echo 'PATH="/usr/local/fop-0.20.5/":$PATH:$HOME/bin' >> /root/.bash_profile
RUN echo 'export JAVA_HOME="/usr/local/j2sdk1.4.2_12/"' >> /root/.bash_profile
RUN echo 'export PATH' >> /root/.bash_profile

#AVVIO AUTOMATICO
RUN chkconfig --level 345 httpd on

EXPOSE 80
CMD ["/usr/sbin/init"]