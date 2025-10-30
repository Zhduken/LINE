#!/usr/bin/env bash
clear

# Renkler
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
CYAN="\033[1;36m"
MAGENTA="\033[1;35m"
BOLD="\033[1m"
RESET="\033[0m"


echo -e "${BOLD}${CYAN}LINE${RESET} / Gelişmiş Paket Köprüsü"
echo -e "Komut listesi için line yardım yazın."
echo ""


check_package(){ local pkg="$1"; if ! apt-cache show "$pkg" >/dev/null 2>&1; then echo -e "${RED}Paket bulunamadı: $pkg${RESET}"; return 1; fi; return 0; }

confirm(){ local prompt="$1"; while true; do printf "%s (E/H): " "$prompt"; read -r ans; case "$ans" in [Ee]*) return 0;; [Hh]*) return 1;; *) echo "Lütfen E veya H girin.";; esac; done; }


paket_yukle(){ local pkg="$1"; [ -z "$pkg" ] && { echo -e "${YELLOW}Paket adı verilmedi.${RESET}"; return 1; }; if check_package "$pkg"; then if confirm "Paket $pkg yüklemek istiyor musunuz?"; then echo -e "${BLUE}Yükleniyor: $pkg${RESET}"; sudo apt update -qq; sudo apt install -y "$pkg"; else echo -e "${YELLOW}İptal edildi.${RESET}"; fi; fi; }
paket_kaldir(){ local pkg="$1"; [ -z "$pkg" ] && { echo -e "${YELLOW}Paket adı verilmedi.${RESET}"; return 1; }; if dpkg -s "$pkg" >/dev/null 2>&1; then if confirm "Paket $pkg kaldırılacak, onaylıyor musunuz?"; then echo -e "${YELLOW}Kaldırılıyor: $pkg${RESET}"; sudo apt remove -y "$pkg"; else echo -e "${YELLOW}İptal edildi.${RESET}"; fi; else echo -e "${RED}Paket kurulu değil: $pkg${RESET}"; fi; }
paket_yukselt(){ local pkg="$1"; [ -z "$pkg" ] && { echo -e "${YELLOW}Paket adı verilmedi.${RESET}"; return 1; }; if check_package "$pkg"; then if confirm "Paket $pkg yükseltilecek, onaylıyor musunuz?"; then echo -e "${CYAN}Yükseltiliyor: $pkg${RESET}"; sudo apt update -qq; sudo apt install --only-upgrade -y "$pkg"; else echo -e "${YELLOW}İptal edildi.${RESET}"; fi; fi; }
paket_ara(){ local pkg="$1"; [ -z "$pkg" ] && { echo -e "${YELLOW}Aramak için paket adı girin.${RESET}"; return 1; }; apt search "$pkg" | head -n 20; }
paket_goruntule(){ local pkg="$1"; [ -z "$pkg" ] && { echo -e "${YELLOW}Görüntülemek için paket adı girin.${RESET}"; return 1; }; if check_package "$pkg"; then apt show "$pkg"; fi; }

line_yardim(){
    echo -e "${MAGENTA}===== LINE Yardım =====${RESET}"
    echo "line paket <paket>    -> Paket yükle"
    echo "line kaldır <paket>   -> Paket kaldır"
    echo "line yükselt <paket>  -> Paket yükselt"
    echo "line ara <paket>      -> Paket ara"
    echo "line show <paket>     -> Paket detaylarını göster"
    echo "line store            -> Kategorilerden hızlı kurulum"
    echo "line yardım           -> Yardım menüsü"
    echo "line exit             -> Çıkış yap"
    echo ""
    echo -e "${YELLOW}Daha fazla komut için: line bilgi${RESET}"
}


line_store(){
    declare -A KATEGORILER
    KATEGORILER[tarayicilar]="firefox chromium midori"
    KATEGORILER[editors]="nano vim codeblocks"
    KATEGORILER[gelistirici]="git build-essential python3-pip"

    echo -e "${CYAN}Kategoriler:${RESET}"
    i=1
    declare -A kat_index
    for cat in "${!KATEGORILER[@]}"; do
        echo "[$i] $cat"
        kat_index[$i]=$cat
        ((i++))
    done

    printf "Kategori seçin (id ile): "; read -r secilen_id
    if ! [[ "$secilen_id" =~ ^[0-9]+$ ]] || [ -z "${kat_index[$secilen_id]}" ]; then echo -e "${RED}Geçersiz seçim.${RESET}"; return; fi
    secilen="${kat_index[$secilen_id]}"

    echo -e "${YELLOW}Paketler (${secilen}):${RESET}"
    i=1
    declare -A pkg_index
    for p in ${KATEGORILER[$secilen]}; do
        echo "[$i] $p"
        pkg_index[$i]=$p
        ((i++))
    done

    printf "Kurmak istediğiniz paket id: "; read -r pkg_id
    if ! [[ "$pkg_id" =~ ^[0-9]+$ ]] || [ -z "${pkg_index[$pkg_id]}" ]; then echo -e "${RED}Geçersiz seçim.${RESET}"; return; fi
    paket_yukle "${pkg_index[$pkg_id]}"
}

hata_mesaji(){ echo -e "${RED}Yanlış komut! line yardım ile bakın.${RESET}"; }


parse_and_run(){
    local line="$*"
    [ -z "$line" ] && return 0
    set -- $line
    cmd="$1"; shift
    args="$*"

    
    case "$cmd" in
        line)
            sub="$1"; shift
            case "$sub" in
                paket) paket_yukle "$*";;
                kaldır) paket_kaldir "$*";;
                yükselt) paket_yukselt "$*";;
                ara) paket_ara "$*";;
                show) paket_goruntule "$*";;
                yardım) line_yardim;;
                store) line_store;;
                exit) exit 0;;
                *) hata_mesaji;;
            esac
            ;;
        *) hata_mesaji;;
    esac
}

# Ana loop
while true; do
    printf "%bline> ${RESET}" "${GREEN}"
    if ! IFS= read -r user_input; then echo ""; continue; fi
    parse_and_run "$user_input"
done
