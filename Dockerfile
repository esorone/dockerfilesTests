FROM kalilinux/kali-rolling

WORKDIR /media/esorone/Docker/Kali/

# change repository to https
RUN echo "deb http://http.kali.org/kali kali-rolling main contrib non-free non-free-firmware" > /etc/apt/sources.list
RUN apt update -q --fix-missing

# Install Nano text editor
RUN apt-get install nano -y
RUN apt-get install openssh-server sudo -y
RUN apt-get install supervisor -y

RUN mkdir -p /var/run/sshd /var/log/supervisor

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN useradd -rm -d /home/esoronw -s /bin/bash -g root -G sudo -u 1001 esorone
USER esorone
WORKDIR /home/esorone

# start supervisor

CMD ["/usr/bin/supervisord"]






