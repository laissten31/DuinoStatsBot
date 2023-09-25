#!/bin/bash

# Vérifier la connectivité Internet avec un ping
/bin/ping -c2 "1.1.1.1" >/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Pas de connexion Internet."
    exit 1
fi

# Variables DuinoCoin
TOKEN="5921647050:AAGOKwgPlM70CS0l2vEhaMycNlTuG5E6pQk"
CHATID="5541683884"
WALLET="hollix"

# Fonction pour envoyer un message Telegram
send_message() {
    local text="$1"
    curl -s -X POST "https://api.telegram.org/bot$TOKEN/sendMessage?parse_mode=HTML" \
        -d "chat_id=$CHATID" \
        -d "text=$text"
}

# Fonction pour actualiser les données et envoyer le message
refresh_data() {
    # Appel à l'API DuinoCoin pour obtenir les données
    api_duinocoin=$(curl -s -X GET "https://server.duinocoin.com/users/$WALLET" -H "Accept: application/json")

    # Extraction des données
    BALANCE=$(jq -r '.result.balance.balance' <<< "$api_duinocoin")
    WORKERS=$(jq -r '.result.miners[].identifier' <<< "$api_duinocoin")
    NUMBER_WORKERS=$(jq -r '.result.miners | length' <<< "$api_duinocoin")

    # Date et heure actuelles
    current_time=$(date "+%H:%M:%S")

    # Construction du message
    message="<b>DuinoCoin Dashboard</b>

Balance: $BALANCE
Nº Workers: $NUMBER_WORKERS
Workers: $WORKERS
Date et heure actuelles: $current_time"

    # Envoi du message Telegram
    send_message "$message"
}

# Commande /start
if [ "$1" == "/start" ]; then
    echo "Bot prêt à fonctionner !"
    exit 0
fi

# Commande /refresh
if [ "$1" == "/refresh" ]; then
    refresh_data
    exit 0
fi

# Vérifier les arguments passés
if [ $# -eq 0 ]; then
    echo "Utilisation : $0 [/start|/refresh]"
    exit 1
fi
