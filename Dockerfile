FROM alpine:latest
EXPOSE 22

# install packages
RUN apk add bash tcsh zsh openssh rsync openrc

# add non-root user
RUN ssh-keygen -A&&\
    adduser -D -h /home/testuser testuser &&\
    echo "testuser:passw0rd" | chpasswd

RUN rc-update add sshd

HEALTHCHECK --interval=10 --start-period=5 --retries=5\
  CMD rc-service sshd status

# generate key pair and change password
USER testuser
RUN ssh-keygen -t rsa -b 1024 -f ${HOME}/.ssh/id_rsa &&\
    cp ${HOME}/.ssh/id_rsa.pub ${HOME}/.ssh/authorized_keys

USER root
CMD ["/sbin/init"]
