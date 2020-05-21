FROM centos:6.6

ARG GIT_VERSION

ENV GIT_VERSION=${GIT_VERSION}

RUN yum install -y yum-plugin-ovl

RUN yum install -y \
	libicu \
	epel-release \
	libunwind \
	openssl \
	libnghttp2 \
	libidn \
	krb5 \
	libuuid \
	lttng-ust \
	tar \
	libcurl \
	wget \
	curl \
	zlib \
	git

COPY files/libunwind-1.1-3.el6.x86_64.rpm /tmp/

RUN rpm -Uvh /tmp/libunwind-1.1-3.el6.x86_64.rpm

COPY files/dotnet-install.sh /root/

RUN /root/dotnet-install.sh 

ENV DOTNET_CLI_TELEMETRY_OPTOUT=true

ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=true

COPY ./Calamari /app

WORKDIR /app

ENV PATH=$PATH:/root/.dotnet:/root/.dotnet/tools

ENV DOTNET_ROOT=/root/.dotnet

COPY files/gitversion.sh .gitversion.sh

RUN ./.gitversion.sh

RUN git checkout $(cat .gitversion.txt)

WORKDIR /app/source

RUN dotnet publish Calamari -c Release -f netcoreapp3.1 -o ./artifacts --self-contained -r rhel.6-x64 /p:Version=$(cat ../.gitversion.txt)

RUN rm -rf /artifacts/* && \
	mkdir -p /artifacts && \
	cp -r /app/source/Calamari/artifacts/ / && \
	cp /app/.gitversion.txt /artifacts && \
	echo 'copied files to /artifacts'
