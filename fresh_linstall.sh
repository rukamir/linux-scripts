#!/bin/bash
# curl -Ssf [link] | sh
if [ $(id -u) = 0 ]; then
   echo "Do not run as root!"
   exit 1
fi

sudo apt update -y && apt upgrade -y

# Install NodeJS
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash - \
	&& sudo apt install -y nodejs build-essential

# Install Golang
wget "https://dl.google.com/go/go1.11.linux-amd64.tar.gz" -O ~/Downloads/go1.11.tar.gz \
	&& sudo tar -C /usr/local -xzf ~/Downloads/go1.11.tar.gz \
	&& echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.bashrc

cat <<EOT >> ~/.bashrc
export PATH=$PATH:/usr/local/go/bin
EOT

# Install other stuff I need
sudo apt install -y vim tree docker-ce sshfs vlc git curl \
    python python3 youtube-dl default-jre default-jdk gradle
    
# Install docker-ce
sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
	&& curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - \
	&& sudo apt-key fingerprint 0EBFCD88 \
	&& sudo add-apt-repository \
	   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
	   $(lsb_release -cs) \
	   stable" \
	&& sudo apt-get update && sudo apt-get install docker-ce

# Install docker compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
	&& sudo chmod +x /usr/local/bin/docker-compose

# Install current VS Code
wget "https://go.microsoft.com/fwlink/?LinkID=760868" -O ~/Downloads/vs-code-current.deb \
	&& sudo dpkg -i ~/Downloads/vs-code-current.deb

# Install Discord
wget "https://discordapp.com/api/download?platform=linux&format=deb" -O ~/Downloads/discord-current.deb \
	&& sudo dpkg -i ~/Downloads/discord-current.deb

# Install ExpressVPN
wget "https://download.expressvpn.xyz/clients/linux/expressvpn_1.4.5_amd64.deb" -O ~/Downloads/expressvpn_1.4.5_amd64.deb \
	&& sudo dpkg -i ~/Downloads/expressvpn_1.4.5_amd64.deb

# If something broke
sudo apt --fix-broken install

# Gimme some keys
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""

# Folder management
mkdir ~/workspace
mkdir ~/scripts
rm -rf ~/Public
rm -rf ~/Templates

# Bash stuff
cat <<EOT >> ~/.bashrc
alias netstats="sudo netstat -tupln"
alias dockstop="sudo docker container stop"
alias dockls="sudo docker container ls"
alias gs="git status"
alias gaa="git add ."
export PATH=$PATH:$HOME/scripts
EOT

source ~/.bashrc
