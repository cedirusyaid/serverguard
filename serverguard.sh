#!/bin/bash

# Load konfigurasi dari file .env dengan cara yang aman
if [ -f .env ]; then
    set -a
    source .env
    set +a
else
    echo "Error: File .env tidak ditemukan!"
    exit 1
fi

# Fungsi untuk mengirim pesan ke Telegram
send_telegram_message() {
    local message="$1"
    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
        -d "chat_id=$TELEGRAM_CHAT_ID" \
        -d "text=$message"
}

# Fungsi untuk memeriksa status server
check_servers() {
    for server in $SERVERS; do
        if ping -c 1 -W 2 "$server" &> /dev/null; then
            echo "$(date) - $server is UP" >> "$LOG_FILE"
        else
            echo "$(date) - WARNING: $server is DOWN!" >> "$LOG_FILE"
            send_telegram_message "⚠️ *Server Down Alert!* ⚠️%0A%0AServer: $server%0AWaktu: $(date)"
        fi
    done
}

# Jalankan pengecekan
check_servers

#cek perubahan