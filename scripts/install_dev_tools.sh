#!/bin/bash

set -x

# Update sync
# sudo apt-get update

# Install uuid
sudo apt-get install -y uuid-dev

# Install terminator
sudo apt-get install terminator -y

# Install zsh
sudo apt-get install zsh -y

# Oh my zsh
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

# Install VSCode shit
sudo curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get update -y
sudo apt-get install -y code

# Install node shit
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.9/install.sh | bash
echo export NVM_DIR="$HOME/.nvm" >> /home/vagrant/.bashrc
echo export NVM_DIR="$HOME/.nvm" >> /home/vagrant/.zshrc
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
nvm install node
npm install -g gulp
node -v

# Install Go
GO_VER=1.22.5
wget "https://go.dev/dl/go${GO_VER}.linux-amd64.tar.gz"
sudo tar -C /usr/local -xzf "go${GO_VER}.linux-amd64.tar.gz"
echo export PATH=$PATH:/usr/local/go/bin >> /home/vagrant/.bashrc
echo export PATH=$PATH:/usr/local/go/bin >> /home/vagrant/.zshrc

# Install Pyenv
sudo apt install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
curl https://pyenv.run | bash
echo -e 'export PYENV_ROOT="$HOME/.pyenv"\nexport PATH="$PYENV_ROOT/bin:$PATH"' >> /home/vagrant/.bashrc
echo -e 'eval "$(pyenv init --path)"\neval "$(pyenv init -)"' >> /home/vagrant/.bashrc
echo -e 'export PYENV_ROOT="$HOME/.pyenv"\nexport PATH="$PYENV_ROOT/bin:$PATH"' >> /home/vagrant/.zshrc
echo -e 'eval "$(pyenv init --path)"\neval "$(pyenv init -)"' >> /home/vagrant/.zshrc
source /home/vagrant/.bashrc
pyenv --version
pyenv install 3.9.19

# Install pipenv
sudo apt install -y python3-venv python3-pip
python3 -m pip install --user pipx
python3 -m pipx ensurepath --force
# Add to path
cat <<STUFF >> /home/vagrant/.zshrc 
# PYENV SHIT
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PYTHON_BIN_PATH="$(python3 -m site --user-base)/bin"
export PATH="$PATH:$PYTHON_BIN_PATH"
export PATH="$PATH:/home/vagrant/.local/bin"
STUFF
source /home/vagrant/.zshrc
pipx install pipenv
pipenv --version

# Install docker
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER
newgrp docker
# Check sys settings
sudo sysctl net.bridge.bridge-nf-call-iptables
# Should equal 1

# Java 21 + 11 and Maven
sudo apt install openjdk-21-jdk maven -y
# Installs to /usr/lib/jvm/java-21-openjdk-amd64

# Install Java 11
sudo add-apt-repository ppa:openjdk-r/ppa
sudo apt-get update
sudo apt install openjdk-11-jdk
# Installs to /usr/lib/jvm/java-11-openjdk-amd64

# Java Alternatives
update-java-alternatives --list
# Set
sudo update-alternatives --config java
sudo update-alternatives --config javac

# Update JAVA_HOME
if [ -z "${JAVA_HOME}" ]
then
    JAVA_HOME=$(readlink -nf $(which java) | xargs dirname | xargs dirname)
    if [ ! -e "$JAVA_HOME" ]
    then
        JAVA_HOME=""
    fi
    export JAVA_HOME=$JAVA_HOME
fi

# Install Rust
curl --proto '=https' --tlsv1.3 https://sh.rustup.rs -sSf | sh


# Install Azure CLI
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -sLS https://packages.microsoft.com/keys/microsoft.asc |
  gpg --dearmor | sudo tee /etc/apt/keyrings/microsoft.gpg > /dev/null
sudo chmod go+r /etc/apt/keyrings/microsoft.gpg
AZ_DIST=$(lsb_release -cs)
echo "Types: deb
URIs: https://packages.microsoft.com/repos/azure-cli/
Suites: ${AZ_DIST}
Components: main
Architectures: $(dpkg --print-architecture)
Signed-by: /etc/apt/keyrings/microsoft.gpg" | sudo tee /etc/apt/sources.list.d/azure-cli.sources
sudo apt-get update
sudo apt-get install azure-cli

# Add paths to Oh My Zsh
cat > $ZSH_CUSTOM/paths.zsh <<EOF
export PATH="$PATH:/home/vagrant/.local/bin"

# PYENV SHIT
export PYTHON_BIN_PATH="/home/vagrant/.local/bin"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# JAVA
export JAVA_HOME="$(jrunscript -e 'java.lang.System.out.println(java.lang.System.getProperty("java.home"));')"

# GO
export PATH=$PATH:/usr/local/go/bin

# NVM
export NVM_DIR=/home/vagrant/.nvm
EOF

# Install Postman & newman
sudo snap install postman

## MANUAL/INTERACTIVE STEPS AFTER LOGIN
# Make default shell
sudo chsh -s $(which zsh)
# Set GB keyboard
setxkbmap -layout gb

# Install pgAdmin
curl -fsS https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo gpg --dearmor -o /usr/share/keyrings/packages-pgadmin-org.gpg
sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/packages-pgadmin-org.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list && apt update'
sudo apt install -y pgadmin4