FROM alpine:latest
EXPOSE 22

# install packages
RUN apk add bash tcsh zsh openssh rsync

# add non-root user
RUN ssh-keygen -A&&\
    adduser -D -h /home/testuser testuser &&\
    echo "testuser:passw0rd" | chpasswd

# generate key pair and change password
USER testuser
RUN ssh-keygen -t rsa -b 1024 -f ${HOME}/.ssh/id_rsa &&\
    cp ${HOME}/.ssh/id_rsa.pub ${HOME}/.ssh/authorized_keys

USER root
CMD ["/usr/sbin/sshd", "-D"]
