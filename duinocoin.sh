#!/bin/bash

# Votre code actuel pour la vérification du ping

TOKEN="5921647050:AAGOKwgPlM70CS0l2vEhaMycNlTuG5E6pQk"
CHATID="5541683884"
WALLET="hollix"

api_telegram="https://api.telegram.org/bot$TOKEN/sendMessage?parse_mode=HTML"
api_duinocoin=$(curl -s -X GET https://server.duinocoin.com/users/$WALLET -H "Accept: application/json" | jq .)

BALANCE=$(echo $api_duinocoin | jq '.result.balance.balance')
BALANCE_FORMAT=$(echo "scale=2; $BALANCE/1" | bc -l)
WORKERS=$(echo $api_duinocoin | jq '.result.miners' | jq '.[].identifier' | tr -d '"')
NUMBER_WORKERS=$(echo $api_duinocoin | jq -r '.result.miners' | jq -r '.[].identifier' | wc -l)

function sendMessage() {
    curl -s -X POST $api_telegram -d chat_id=$CHATID -d text="$(printf "<b>$BANNER</b>\n\n \
        Balance: $BALANCE_FORMAT\n \
        Nº Workers $NUMBER_WORKERS\n \
        Names workers:\n<code>$WORKERS</code>")" >/dev/null 2>&1
}

# Gérez les commandes Telegram ici
if [[ "$1" == "/start" ]]; then
    # Code pour gérer la commande /start
    BANNER="Le bot est prêt à fonctionner !"
    sendMessage
elif [[ "$1" == "/refresh" ]]; then
    # Code pour gérer la commande /refresh
    BANNER="ᕲ DuinoCoin ✅"  # Par exemple
    sendMessage
else
    # Code pour vérifier le ping ou d'autres actions par défaut
    # ...

    # Si vous ne spécifiez pas de commande Telegram, le script effectuera d'autres actions par défaut
fi
