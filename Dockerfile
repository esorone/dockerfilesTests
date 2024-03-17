FROM kalilinux/kali-rolling

WORKDIR /media/esorone/Docker/Kali/

# change repository to https
RUN echo "deb http://http.kali.org/kali kali-rolling main contrib non-free non-free-firmware" > /etc/apt/sources.list
RUN apt update -q --fix-missing

# Install Nano text editor
RUN apt-get install nano -y
RUN apt-get install openssh-server sudo -y

RUN useradd -rm -d /home/esorone -s /bin/bash -g root -G sudo -u 1000 test 


#RUN  echo 'esorone:esorone' | chpasswd
ARG SSH_USER=esorone
RUN service ssh start
# Copy the shell script into the container
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 22

CMD ["/usr/sbin/sshd","-D"]




