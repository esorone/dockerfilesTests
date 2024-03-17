FROM kalilinux/kali-rolling

WORKDIR /media/esorone/Docker/Kali/

# change repository to https
RUN echo "deb http://http.kali.org/kali kali-rolling main contrib non-free non-free-firmware" > /etc/apt/sources.list
RUN apt update -q --fix-missing

# Install Nano text editor
RUN apt-get install nano -y
RUN apt-get install openssh-server sudo -y

#RUN mkdir /var/run/sshd
RUN useradd -rm -d /home/esorone -s /bin/bash -g root -G sudo -u 1000 test 



# Create a new user named kali and set passwords
RUN useradd -ms /bin/bash kali
RUN echo 'kali:kali' | chpasswd 
RUN echo 'root:kali' | chpasswd
RUN echo "kali ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/kali
RUN usermod -aG sudo kali

# Run some commands at the beginning
ENTRYPOINT service ssh restart 








