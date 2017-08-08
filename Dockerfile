FROM registry.access.redhat.com/rhscl/httpd-24-rhel7
MAINTAINED BY David Shrader

RUN yum --enablerepo rhel-7-server-optional-rpms install -y mod_proxy_html && rm -rf /var/yum/cache/* && yum clean all

