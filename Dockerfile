# extend the official jenkins slave base image
FROM registry.redhat.io/openshift4/ose-jenkins:v4.7

USER root

# specify wanted version of python
ENV PYTHON_VERSION=3.6.1 \
    LANG=de_CH.UTF-8

# install python
RUN set -x \
    && sed -i 's/override_install_langs=en_US.utf8/#override_install_langs=en_US.utf8/g' /etc/yum.conf \
    && dnf update -y glibc-common \
    && localedef -c -i de_CH -f UTF-8 de_CH.UTF-8 \
    && echo "LANG=de_CH.UTF-8" > /etc/locale.conf \
#    && chown -R root:root /var/lib/jenkins \
    && INSTALL_PKGS="gcc make openssl-devel zlib-devel" \
    && dnf install -y --setopt=tsflags=nodocs $INSTALL_PKGS wget \
    && dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
    && cd /tmp \
    && wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz \
    && tar xf Python-${PYTHON_VERSION}.tgz \
    && cd Python-${PYTHON_VERSION} \
    && ./configure \
    && make altinstall \
    && cd .. \
    && rm -rf Python-${Python_VERSION} \
    && dnf install -y --setopt=tsflags=nodocs python3-pip uwsgi uwsgi-plugin-python3 postgresql-devel python3-devel \
    && dnf remove -y $INSTALL_PKGS \
    && dnf clean all \
    && rm -rf /var/cache/dnf
#    && chown 1001:0 /var/lib/jenkins

RUN groupadd -r www-data \
	&& useradd -r -d /var/www/ -s /sbin/nologin -g www-data www-data

ADD . /srv/qwc_service
RUN pip3 install --no-cache-dir -r /srv/qwc_service/requirements.txt \
    && chmod u+x /srv/qwc_service/* \
    && chown 1001:0 /srv/qwc_service

# switch to non-root for openshift usage
USER 1001
