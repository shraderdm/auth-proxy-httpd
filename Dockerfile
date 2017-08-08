#FROM registry.access.redhat.com/rhscl/httpd-24-rhel7
#MAINTAINER David Shrader

#USER root
#RUN yum remove -y httpd
#RUN yum update -y
#RUN yum --enablerepo rhel-7-server-optional-rpms install -y mod_proxy_html && yum clean all

FROM sha256:c8b1a95b13d00df9f843f31cd496b4783bf9963a3dff8718a3adabc8980dcde9    
                                                                                
# Apache HTTP Server image.                                                     
#                                                                               
# Volumes:                                                                      
#  * /var/www - Datastore for httpd                                             
#  * /var/log/httpd24 - Storage for logs when $HTTPD_LOG_TO_VOLUME is set       
# Environment:                                                                  
#  * $HTTPD_LOG_TO_VOLUME (optional) - When set, httpd will log into /var/log/httpd24                                                                           

MAINTAINER David Shrader

USER root

ENV HTTPD_VERSION=2.4                                                           
                                                                                
ENV SUMMARY="Platform for running Apache HTTP $HTTPD_VERSION Server or building httpd-based application" \                                                      
    DESCRIPTION="Apache HTTP $HTTPD_VERSION available as docker container, is a powerful, efficient, \                                                          
and extensible web server. Apache supports a variety of features, many implemented as compiled modules \                                                        
which extend the core functionality. \                                          
These can range from server-side programming language support to authentication schemes. \                                                                      
Virtual hosting allows one Apache installation to serve many different Web sites."                                                                              


LABEL summary="$SUMMARY" \                                                      
      description="$DESCRIPTION" \                                              
      io.k8s.description="$SUMMARY" \                                           
      io.k8s.display-name="Apache HTTP $HTTPD_VERSION" \                        
      io.openshift.expose-services="8080:http,8443:https" \                     
      io.openshift.tags="builder,httpd,httpd24"                                 
                                                                                
LABEL name="rhscl/httpd-24-rhel7" \                                             
      version="$HTTPD_VERSION" \                                                
      release="36.2" \                                                          
      com.redhat.component="httpd24-docker" \                                   
      architecture="x86_64"                                                     
                                                                                
EXPOSE 80                                                                       
EXPOSE 443                                                                      
EXPOSE 8080                                                                     
EXPOSE 8443    

RUN yum install -y yum-utils gettext hostname && \                              
    yum-config-manager --enable rhel-server-rhscl-7-rpms && \                   
    yum-config-manager --enable rhel-7-server-optional-rpms && \                
    yum-config-manager --enable rhel-7-server-ose-3.5-rpms

RUN INSTALL_PKGS="nss_wrapper bind-utils httpd24 httpd24-mod_ssl httpd24-mod_proxy_html" && \          
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \                                                                     
    yum clean all                                                               
                                                                                
ENV HTTPD_CONTAINER_SCRIPTS_PATH=/usr/share/container-scripts/httpd/ \          
    HTTPD_APP_ROOT=/opt/app-root \                                              
    HTTPD_CONFIGURATION_PATH=${HTTPD_APP_ROOT}/etc/httpd.d \                    
    HTTPD_MAIN_CONF_PATH=/etc/httpd/conf \                                      
    HTTPD_MAIN_CONF_D_PATH=/etc/httpd/conf.d \                                  
    HTTPD_VAR_RUN=/var/run/httpd \                                              
    HTTPD_DATA_PATH=/var/www \                                                  
    HTTPD_DATA_ORIG_PATH=/opt/rh/httpd24/root/var/www \                         
    HTTPD_LOG_PATH=/var/log/httpd24 \                                           
    HTTPD_SCL=httpd24                                                           

# When bash is started non-interactively, to run a shell script, for example it 
# looks for this variable and source the content of this file. This will enable 
# the SCL for all scripts without need to do 'scl enable'.                      
ENV BASH_ENV=${HTTPD_APP_ROOT}/scl_enable \                                     
    ENV=${HTTPD_APP_ROOT}/scl_enable \                                          
    PROMPT_COMMAND=". ${HTTPD_APP_ROOT}/scl_enable"                             
                                                                                
#COPY ./s2i/bin/ $STI_SCRIPTS_PATH                                               
#COPY ./root /                                                                   
                                                                                
RUN /usr/libexec/httpd-prepare                                                  
                                                                                
USER 1001                                                                       
                                                                                
VOLUME ["${HTTPD_DATA_PATH}"]                                                   
VOLUME ["${HTTPD_LOG_PATH}"]                                                    
                                                                                
CMD ["/usr/bin/run-httpd"]                                                      
                              
