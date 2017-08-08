FROM registry.access.redhat.com/rhscl/httpd-24-rhel7
MAINTAINER David Shrader

RUN yum --enablerepo rhel-7-server-optional-rpms install -y mod_proxy_html

