FROM registry.access.redhat.com/rhscl/httpd-24-rhel7
MAINTAINER David Shrader

USER root
RUN yum update -y
RUN yum --enablerepo rhel-7-server-optional-rpms install -y mod_proxy_html

