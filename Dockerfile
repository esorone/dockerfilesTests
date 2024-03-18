FROM kalilinux/kali-rolling

WORKDIR /media/esorone/Docker/Kali/

# Setup variables
ENV VNCPASSWORD "esorone"

# change repository to https
RUN echo "deb http://http.kali.org/kali kali-rolling main contrib non-free non-free-firmware" > /etc/apt/sources.list
RUN apt update -q --fix-missing

# Install packages
RUN apt-get install nano -y
RUN apt-get install openssh-server sudo -y
RUN apt-get install supervisor -y
RUN sudo apt install net-tools -y


# Configure SSH for password login
RUN mkdir -p /var/run/sshd
RUN sed -i '/PasswordAuthentication no/c\PasswordAuthentication yes' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Setup default user
RUN useradd --create-home -s /bin/bash -m esorone && echo "esorone:esorone" | chpasswd && adduser esorone sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN mkdir -p /var/run/sshd /var/log/supervisor

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Setup VNC for supervisor
RUN mkdir -p /esorone/.vnc
RUN apt-get install -y xfce4 xfce4-goodies x11vnc xvfb
RUN apt-get install autocutsel
RUN x11vnc -storepasswd $VNCPASSWORD /home/esorone/.vnc/passwd
RUN chmod 600 /home/esorone/.vnc/passwd

RUN echo '#!/bin/bash' >> /home/esorone/.vnc/newvnclauncher.sh
RUN echo "/usr/bin/vncserver :1 -name vnc -geometry 1600x1200 -randr 1600x1200,1440x900,1024x768" >> /home/esorone/.vnc/newvnclauncher.sh
RUN chmod +x /home/esorone/.vnc/newvnclauncher.sh

#RUN echo "[program:vncserver]" >> /etc/supervisor/conf.d/supervisord.conf
#RUN echo "command=/bin/bash /root/.vnc/newvnclauncher.sh" >> /etc/supervisor/conf.d/supervisord.conf
#RUN echo "" >> /etc/supervisor/conf.d/supervisord.conf

# start supervisor
EXPOSE 5900

CMD ["/usr/bin/supervisord"]






