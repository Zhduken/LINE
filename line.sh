#!/bin/bash
clear
theme="green"
repo_url="https://packages.line-os.local"

function set_theme {
    if [ "$theme" = "red" ]; then echo -e "\033[1;31m$1\033[0m"
    elif [ "$theme" = "green" ]; then echo -e "\033[1;32m$1\033[0m"
    elif [ "$theme" = "purple" ]; then echo -e "\033[1;35m$1\033[0m"
    elif [ "$theme" = "cyber" ]; then echo -e "\033[38;5;51m$1\033[0m"
    else echo "$1"; fi
}

function intro {
    for i in {1..3}; do
        echo -e "\033[1;31m██\033[1;32m██\033[1;35m██\033[0m"
        sleep 0.1
    done
    set_theme "===== LINE Paket Yöneticisine Hoşgeldin ====="
    echo
}

function help_menu {
    set_theme "Komutlar:"
    echo " line store       -> Mağazayı açar"
    echo " line install X   -> Paket kurar"
    echo " line remove X    -> Paket siler"
    echo " line search X    -> Paket arar"
    echo " line list        -> Kurulu paketleri listeler"
    echo " line update      -> Güncellemeleri kontrol eder"
    echo " line settings    -> Ayarlar menüsünü açar"
    echo " line help        -> Bu menüyü gösterir"
    echo " exit             -> Çıkış"
    echo
}

function settings_menu {
    clear
    set_theme "===== LINE AYARLARI ====="
    echo "1) Tema Değiştir"
    echo "2) Repo Adresi Değiştir"
    echo "3) Güncelleme Kontrolü"
    echo "4) Geri Dön"
    read -p "> " ch
    if [ "$ch" = "1" ]; then
        clear
        echo "Temalar:"
        echo "1) Kırmızı"
        echo "2) Yeşil"
        echo "3) Mor"
        echo "4) Cyber Glow"
        read -p "> " t
        if [ "$t" = "1" ]; then theme="red"
        elif [ "$t" = "2" ]; then theme="green"
        elif [ "$t" = "3" ]; then theme="purple"
        elif [ "$t" = "4" ]; then theme="cyber"
        fi
    elif [ "$ch" = "2" ]; then
        read -p "Yeni repo URL gir: " repo_url
    elif [ "$ch" = "3" ]; then
        set_theme "Sistem güncel ✔"
        sleep 1
    fi
}

function store {
    clear
    set_theme "===== LINE STORE ====="
    echo "Kategoriler:"
    echo "1) Sistem Araçları"
    echo "2) Internet Araçları"
    echo "3) Eğlence"
    echo "4) İleri Araçlar"
    echo "5) Geri"
    read -p "> " ct
    clear
    if [ "$ct" = "1" ]; then
        echo "nano - Basit metin düzenleyici"
        echo "htop - Sistem izleme"
        echo "neofetch - Sistem bilgi gösterici"
    elif [ "$ct" = "2" ]; then
        echo "wget - Dosya indirme"
        echo "curl - Web istek aracı"
        echo "lynx - Terminal web tarayıcı"
    elif [ "$ct" = "3" ]; then
        echo "cowsay - ASCII inek"
        echo "sl - Tren animasyonu"
        echo "cmatrix - Matrix yağmuru"
    elif [ "$ct" = "4" ]; then
        echo "nmap - Ağ tarama"
        echo "wireshark - Paket analiz"
        echo "aircrack-ng - Wi-Fi kırma"
    fi
    echo
}
intro
help_menu

while true; do
    echo -n "$(set_theme LINE)> "
    read cmd arg
    if [ "$cmd" = "line" ] && [ "$arg" = "store" ]; then store
    elif [ "$cmd" = "line" ] && [ "$arg" = "help" ]; then help_menu
    elif [ "$cmd" = "line" ] && [ "$arg" = "settings" ]; then settings_menu
    elif [ "$cmd" = "exit" ]; then exit
    else set_theme "Komut anlaşılamadı."
    fi
done
