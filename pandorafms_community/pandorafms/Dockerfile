#docker build -trameijeiras/pandorafms-community:<ver> .
FROM rameijeiras/pandorafms-base 

ENV DBNAME=pandora
ENV DBUSER=pandora
ENV DBPASS=pandora
ENV DBHOST=pandora
ENV DBPORT=3306
ENV PASSPAN=P@ndora_2018
ENV SLEEP=5
ENV RETRIES=1

workdir /tmp
# Install the Pandora server
RUN	rm -rf /etc/localtime ; ln -s /usr/share/zoneinfo/Europe/Madrid /etc/localtime 

RUN wget https://downloads.sourceforge.net/project/pandora/Tools%20and%20dependencies%20%28All%20versions%29/DEB%20Debian%2C%20Ubuntu/phantomjs ; \
	chmod +x phantomjs; \
	ln -s /tmp/phantomjs /usr/bin/

COPY  sources/ /tmp
# Install phantomjs
RUN chmod +x /tmp/run_pandora.sh 

RUN yum install -y https://downloads.sourceforge.net/project/pandora/Pandora%20FMS%207.0NG/742/RHEL_CentOS/pandorafms_console-7.0NG.742-1.noarch.rpm?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fpandora%2Ffiles%2FPandora%2520FMS%25207.0NG%2F740%2FRHEL_CentOS%2Fpandorafms_console-7.0NG.742-1.noarch.rpm; \ 
	yum install -y https://downloads.sourceforge.net/project/pandora/Pandora%20FMS%207.0NG/742/RHEL_CentOS/pandorafms_server-7.0NG.742-1.noarch.rpm; \
	yum clean all

EXPOSE 80 443 41121 162/udp

CMD sh /tmp/run_pandora.sh




