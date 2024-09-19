#!/bin/bash

fix_dpkg_statoverride() {
    echo "Corrigindo o erro do dpkg relacionado ao statoverride..."

    if [ -f /var/lib/dpkg/statoverride ]; then
        sudo sed -i '/hplip/d' /var/lib/dpkg/statoverride
        echo "Linhas com 'hplip' removidas do arquivo statoverride."

        sudo dpkg --configure -a

        if [ $? -eq 0 ]; then
            echo "dpkg reconfigurado com sucesso."
        else
            echo "Erro ao reconfigurar o dpkg."
            exit 1
        fi
    else
        echo "Arquivo statoverride não encontrado. Pulando a correção."
    fi
}

install_jq() {
    echo "Verificando o gerenciador de pacotes..."

    if command -v apt-get &>/dev/null; then
        echo "apt-get detectado. Instalando jq..."
        sudo apt-get update && sudo apt-get install -y jq
    elif command -v dnf &>/dev/null; then
        echo "dnf detectado. Instalando jq..."
        sudo dnf install -y jq
    elif command -v yum &>/dev/null; then
        echo "yum detectado. Instalando jq..."
        sudo yum install -y jq
    elif command -v pacman &>/dev/null; then
        echo "pacman detectado. Instalando jq..."
        sudo pacman -Syu jq --noconfirm
    elif command -v zypper &>/dev/null; then
        echo "zypper detectado. Instalando jq..."
        sudo zypper install -y jq
    else
        echo "Nenhum gerenciador de pacotes suportado detectado. Por favor, instale o jq manualmente."
        exit 1
    fi
}

if ! command -v jq &>/dev/null; then
    echo "jq não encontrado. Tentando instalar..."

    fix_dpkg_statoverride

    install_jq
else
    echo "jq já está instalado."
fi

CONFIG_FILE="/etc/v2ray/config.json"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Arquivo de configuração $CONFIG_FILE não encontrado!"
    exit 1
fi

BACKUP_FILE="${CONFIG_FILE}.bak"
cp "$CONFIG_FILE" "$BACKUP_FILE"
echo "Backup criado: $BACKUP_FILE"

jq '(.inbounds[] | .settings.clients) = []' "$CONFIG_FILE" >tmp.json

if [ $? -ne 0 ]; then
    echo "Erro ao processar o arquivo JSON com jq."
    exit 1
fi

mv tmp.json "$CONFIG_FILE"

echo "Clientes zerados com sucesso no arquivo $CONFIG_FILE."
