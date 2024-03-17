#!/usr/bin/env bash
set -e

if ! grep ${SSH_USER} /etc/passwd ; then
    # Install dependencies
    apt-get install -y ${SSH_DEPENDENCIES}

	# Create the user with ssh access
	useradd -d "/home/${SSH_USER}" -m -s "/bin/bash" "${SSH_USER}"
	mkdir -p /home/${SSH_USER}/.ssh/
	chmod 700 /home/${SSH_USER}/.ssh

	# Configure ssh_config
	mkdir -p /var/run/sshd
	echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
	echo "PermitRootLogin no" >> /etc/ssh/sshd_config
	echo "AllowUsers ${SSH_USER}" >> /etc/ssh/sshd_config

	# Copy the authorized_keys
	touch /home/${SSH_USER}/.ssh/authorized_keys
	IFS=',' read -a keys <<< "${SSH_KEY}"
    	for key in "${keys[@]}"
    	do
		echo "$key" >> /home/${SSH_USER}/.ssh/authorized_keys
    	done
	chmod 600 /home/${SSH_USER}/.ssh/authorized_keys
	
	# Change the owner of the ssh folder
	chown -R ${SSH_USER}:${SSH_USER} /home/${SSH_USER}/.ssh
fi

exec "$@"
