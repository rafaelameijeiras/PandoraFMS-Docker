#docker build -t rameijeiras/pandorafms-base .
FROM centos:7

RUN { \
        echo '[artica_pandorafms]'; \
        echo 'name=CentOS7 - PandoraFMS official repo'; \
        echo 'baseurl=http://firefly.artica.es/centos7'; \
        echo 'gpgcheck=0'; \
        echo 'enabled=1'; \
} > /etc/yum.repos.d/pandorafms.repo

RUN yum install -y --setopt=tsflags=nodocs \
	https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
	http://rpms.remirepo.net/enterprise/remi-release-7.rpm \
	yum-utils ; yum clean all

RUN yum-config-manager --enable remi-php72

# Install console
RUN yum install -y --setopt=tsflags=nodocs \
	php \
	php-mcrypt \php-cli \
	php-gd \
	php-curl \
	php-mysqli \
	php-ldap \
	php-zip \
	php-fileinfo \
	php-snmp \
	php-mbstring \
	php-pecl-zip \
	php-xmlrpc \
	php-yaml \
	libxslt \
	wget \
	php-xml \
	httpd \
	mod_php \
	atk \
	avahi-libs \
	cairo \
	cups-libs \
	fribidi \
	gd \
	gdk-pixbuf2 \
	ghostscript \
	ghostscript-fonts \
	graphite2 \
	graphviz \
	gtk-update-icon-cach \
	gtk2 \
	harfbuzz \
	hicolor-icon-theme \
	hwdata \
	jasper-libs \
	lcms2 \
	libICE \
	libSM \
	libXaw \
	libXcomposite \
	libXcursor \
	libXdamage \
	libXext \
	libXfixes \
	libXft \
	libXi \
	libXinerama \
	libXmu \
	libXrandr \
	libXrender \
	libXt \
	libXxf86vm \
	libcroco \
	libdrm \
	libfontenc \
	libglvnd \
	libglvnd-egl \
	libglvnd-glx \
	libpciaccess \
	librsvg2 \
	libthai \
	libtool-ltdl \
	libwayland-client \
	libwayland-server \
	libxshmfence \
	mesa-libEGL \
	mesa-libGL \
	mesa-libgbm \
	mesa-libglapi \
	pango \
	perl-Net-Telnet \
	pixman \
	xorg-x11-fonts-75dpi \
	xorg-x11-fonts-misc \
	poppler-data ; yum clean all

# Install server

RUN yum install -y http://www6.atomicorp.com/channels/atomic/centos/7/x86_64/RPMS/wmi-1.3.14-4.el7.art.x86_64.rpm --setopt=tsflags=nodocs; yum clean all

RUN yum install -y --setopt=tsflags=nodocs \
	vim \
	fping \
	nmap \
	perl-IO-Compress \
	nmap \
	sudo \
	mysql \
	net-snmp-utils; yum clean all

EXPOSE 80 443 41121 162/udp
