#!/bin/bash

echo "--- Iniciando verificação para Hibernação ---"

# 1. Identificar o dispositivo de swap ativo
# O swapon traz o caminho (ex: /dev/sda3 ou /swap.img)
SWAP_DEVICE=$(swapon --show=NAME --noheadings | head -n 1)

if [ -z "$SWAP_DEVICE" ]; then
    echo "ERRO: Nenhuma área de swap ativa encontrada no sistema."
    exit 1
fi

# 2. Verificar se o dispositivo ativo é uma PARTIÇÃO
IS_PART=$(lsblk -no TYPE "$SWAP_DEVICE")

if [ "$IS_PART" != "part" ]; then
    echo "ERRO: O swap ativo ($SWAP_DEVICE) não é uma partição (tipo: $IS_PART)."
    echo "A hibernação em arquivos de swap (.img) requer passos extras de offset não inclusos aqui."
    exit 1
fi

echo "Dispositivo de swap ativo e válido detectado: $SWAP_DEVICE"

# 3. Verificar o tamanho da Swap vs RAM (em Megabytes para maior precisão)
RAM_SIZE=$(free -m | awk '/^Mem:/{print $2}')
SWAP_SIZE=$(free -m | awk '/^Swap:/{print $2}')

echo "RAM: ${RAM_SIZE}MB | Swap: ${SWAP_SIZE}MB"

if [ "$SWAP_SIZE" -lt "$RAM_SIZE" ]; then
    echo "AVISO: Sua partição Swap é menor que a memória RAM."
    echo "Isso geralmente impede que a hibernação funcione corretamente."
    read -p "Deseja continuar mesmo assim? (s/n): " cont
    [[ "$cont" != "s" ]] && exit 1
fi

# 4. Alterar o /etc/default/grub com segurança
GRUB_FILE="/etc/default/grub"
RESUME_PARAM="resume=$SWAP_DEVICE"

if grep -q "resume=" "$GRUB_FILE"; then
    echo "O parâmetro 'resume' já existe no GRUB. Verifique manualmente para evitar duplicidade."
else
    echo "Fazendo backup e configurando o GRUB..."
    sudo cp "$GRUB_FILE" "${GRUB_FILE}.bak"
    
    # Adiciona o parâmetro antes das aspas de fechamento da linha correta
    sudo sed -i "/GRUB_CMDLINE_LINUX_DEFAULT=/ s/\"$/ $RESUME_PARAM\"/" "$GRUB_FILE"
    
    echo "Atualizando o GRUB (update-grub)..."
    sudo update-grub
    echo "Sucesso! O sistema agora está configurado para retomar de: $SWAP_DEVICE"
fi

# 5. Garantir que o polkitd-pkla esteja instalado para suporte a hibernação
sudo apt install polkitd-pkla
if [[ ! -f /etc/polkit-1/rules.d/10-enable-hibernate.rules ]]
then
    echo "Criando regra polkit para permitir hibernação sem senha..."
    sudo touch /etc/polkit-1/rules.d/10-enable-hibernate.rules
    echo 'polkit.addRule(function(action, subject) {
    if (action.id == "org.freedesktop.login1.hibernate" ||
        action.id == "org.freedesktop.login1.hibernate-multiple-sessions" ||
        action.id == "org.freedesktop.upower.hibernate" ||
        action.id == "org.freedesktop.login1.handle-hibernate-key" ||
        action.id == "org.freedesktop.login1.hibernate-ignore-inhibit")
    {
        return polkit.Result.YES;
    }
});' | sudo tee /etc/polkit-1/rules.d/10-enable-hibernate.rules > /dev/null
fi

# 6. No Gnome, instalar extensão para botão de hibernação
if [[ -f /usr/bin/gnome-session ]]
then 
    echo This is a gnome system! Installing Gnome extension to show Hibernate button...
    echo Installing gnome-extensions-cli, a CLI Gnome extensions tool...
    sudo apt -y install python3-pip
    # On new versions of pip (Ubuntu 23 or higher), this variable is necessary to install gnome-extensions-cli
    export PIP_BREAK_SYSTEM_PACKAGES=1
    pip3 install --upgrade gnome-extensions-cli
    # Adding path only for this session
    export PATH=$PATH:~/.local/bin
    echo Installing Hibernate Status Button...
    gext install hibernate-status@dromi
fi

echo "--- Processo concluído! Recomenda-se reiniciar o computador. ---"
