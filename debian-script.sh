#!/bin/bash

# Função para verificar se o pacote está instalado
package_installed() {
    dpkg -l | grep -E "^ii\s+$1\s+" &> /dev/null
}

# Definição de cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Iniciando instalação dos aplicativos...${NC}"

# Verificação e instalação do VSCode
if ! package_installed code; then
    echo -e "${YELLOW}Instalando o VSCode...${NC}"
    sudo apt install -y code
else
    echo -e "${GREEN}O VSCode já está instalado.${NC}"
fi

# Verificação e instalação do Node.js via Snap
if ! package_installed node; then
    echo -e "${YELLOW}Instalando o Node.js via Snap...${NC}"
    sudo snap install node --classic
else
    echo -e "${GREEN}O Node.js já está instalado.${NC}"
fi

# Verificação e instalação do Postman
if ! command -v postman &> /dev/null; then
    echo -e "${YELLOW}Instalando o Postman...${NC}"
    sudo snap install postman
else
    echo -e "${GREEN}O Postman já está instalado.${NC}"
fi

# Verificação e instalação do Google Chrome
if ! package_installed google-chrome-stable; then
    echo -e "${YELLOW}Instalando o Google Chrome via pacote .deb...${NC}"
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i google-chrome-stable_current_amd64.deb
    sudo apt-get install -f
else
    echo -e "${GREEN}O Google Chrome já está instalado.${NC}"
fi

# Verificação e instalação do Remmina
if ! package_installed remmina; then
    echo -e "${YELLOW}Instalando o Remmina...${NC}"
    sudo apt install -y remmina
else
    echo -e "${GREEN}O Remmina já está instalado.${NC}"
fi

# Verificação e instalação do Gnome Tweaks
if ! package_installed gnome-tweaks; then
    echo -e "${YELLOW}Instalando o Gnome Tweaks...${NC}"
    sudo apt install -y gnome-tweaks
else
    echo -e "${GREEN}O Gnome Tweaks já está instalado.${NC}"
fi

# Verificação e instalação do Git
if ! command -v git &> /dev/null; then
    echo -e "${YELLOW}Instalando o Git...${NC}"
    sudo apt install -y git
else
    echo -e "${GREEN}O Git já está instalado.${NC}"
fi

# Verificação e instalação do Docker
if ! command -v docker &> /dev/null; then
    echo -e "${YELLOW}Instalando o Docker...${NC}"
    sudo apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        software-properties-common

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io

    # Adicionar usuário ao grupo do Docker (opcional - para evitar usar sudo ao rodar comandos Docker)
    sudo usermod -aG docker $USER
else
    echo -e "${GREEN}O Docker já está instalado.${NC}"
fi

# Instala o Oh My Zsh
echo "Instalando Oh My Zsh..."
echo -e "\n" | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Define o tema Agnoster
echo "Configurando tema Agnoster..."
sudo apt install fonts-powerline -y
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/' ~/.zshrc

# Define o Zsh como shell padrão
echo "Definindo Zsh como shell padrão..."
chsh -s $(which zsh)

# Configuração do Git
echo -e "${YELLOW}Configurando o Git...${NC}"
echo -n -e "${YELLOW}Digite seu nome de usuário do GitHub: ${NC}"
read github_user
echo -n -e "${YELLOW}Digite seu e-mail associado ao GitHub: ${NC}"
read github_email

git config --global user.name "$github_user"
git config --global user.email "$github_email"

# Pergunta se deseja reiniciar
echo -e "${YELLOW}Deseja reiniciar a máquina agora? (s/n)${NC}"
read resposta_reiniciar

if [[ "$resposta_reiniciar" == "s" || "$resposta_reiniciar" == "S" ]]; then
    echo -e "${YELLOW}Reiniciando a máquina...${NC}"
    sudo reboot
else
    echo -e "${GREEN}Instalação concluída. Reinicie a máquina para aplicar as alterações.${NC}"
fi
