#!/usr/bin/env bash
clear

CFG="$HOME/.line_config"
mkdir -p "$(dirname "$CFG")"
[ -f "$CFG" ] || cat >"$CFG" <<EOF
AUTO_UPDATE=no
SUDO_AUTO=no
THEME=default
EOF

# RENK FONKSİYONU
color() {
  case "$1" in
    red) echo -e "\033[1;31m$2\033[0m";;
    green) echo -e "\033[1;32m$2\033[0m";;
    cyan) echo -e "\033[1;36m$2\033[0m";;
    yellow) echo -e "\033[1;33m$2\033[0m";;
    magenta) echo -e "\033[1;35m$2\033[0m";;
    *) echo "$2";;
  esac
}

read_config(){ source "$CFG"; }
write_config(){ cat >"$CFG" <<EOF
AUTO_UPDATE=$AUTO_UPDATE
SUDO_AUTO=$SUDO_AUTO
THEME=$THEME
EOF
}

# GİRİŞ EKRANI
intro(){
  color cyan "===== Gelişmiş Paket Köprüsü ====="
  echo
}

# YARDIM MENÜSÜ
help_menu(){
  color magenta "===== YARDIM MENÜSÜ ====="
  echo "line paket <isim>      -> Paket yükle"
  echo "line kaldır <isim>     -> Paket kaldır"
  echo "line yükselt <isim>    -> Paket yükselt"
  echo "line ara <kelime>      -> Paket ara"
  echo "line show <isim>       -> Paket detayları"
  echo "line store             -> Mağazayı aç"
  echo "line store search <q>  -> Store içinde arama"
  echo "line store all         -> Tüm uygulamaları listele"
  echo "line store önerilen    -> Önerilen uygulamalar"
  echo "line update            -> Sistemi güncelle"
  echo "line onar              -> Kırık paketleri düzelt"
  echo "line logs              -> Apt loglarını göster"
  echo "line ayarlar           -> Ayar menüsü"
  echo "line exit              -> Çıkış"
  echo
  echo "Örnekler:"
  echo " line paket firefox"
  echo " line store"
  echo " line store search browser"
  echo
}

# AYARLAR
settings_menu(){
  read_config
  color magenta "===== AYARLAR ====="
  echo "1) Tema ($THEME)"
  echo "2) AUTO_UPDATE ($AUTO_UPDATE)"
  echo "3) SUDO_AUTO ($SUDO_AUTO)"
  echo "4) Sıfırla"
  echo "5) Geri"
  read -p "> " ch
  case "$ch" in
    1) read -p "Tema (default/red/green/cyan/magenta): " t; THEME="$t"; write_config ;;
    2) read -p "AUTO_UPDATE (yes/no): " t; AUTO_UPDATE="$t"; write_config ;;
    3) read -p "SUDO_AUTO (yes/no): " t; SUDO_AUTO="$t"; write_config ;;
    4) echo -e "AUTO_UPDATE=no\nSUDO_AUTO=no\nTHEME=default" >"$CFG";;
  esac
}

# PAKET İŞLEMLERİ
check_package(){ apt-cache show "$1" >/dev/null 2>&1; }
confirm(){ [ "$SUDO_AUTO" = "yes" ] && return 0; read -p "$1 (E/H): " a; [[ "$a" =~ [Ee] ]]; }
paket_yukle(){ check_package "$1" && confirm "Yükle: $1?" && sudo apt install -y "$1" || echo "Paket bulunamadı"; }
paket_kaldir(){ dpkg -s "$1" >/dev/null 2>&1 && confirm "Kaldır: $1?" && sudo apt remove -y "$1" || echo "Kurulu değil"; }
paket_yukselt(){ check_package "$1" && confirm "Yükselt: $1?" && sudo apt install --only-upgrade -y "$1"; }
paket_ara(){ apt search "$*" | head -n 40; }
paket_goruntule(){ apt show "$1"; }

line_update(){ confirm "Tüm sistemi güncellemek istiyor musunuz?" && sudo apt update && sudo apt upgrade -y; }
line_onar(){ sudo apt --fix-broken install -y; sudo dpkg --configure -a; }
line_logs(){ sudo tail -n 200 /var/log/apt/history.log; }

# STORE VERİLERİ
declare -A STORE
STORE[tarayicilar]="firefox:Popüler chromium:Chromium tabanlı brave:Gizlilik vivaldi:Özelleştirilebilir"
STORE[editörler]="nano:Hafif vim:Gelişmiş neovim:Modern code:VSCode codeblocks:C++ IDE"
STORE[oyunlar]="steam:Oyun lutris:Oyun yöneticisi heroic:Epic retroarch:Emülatör minecraft-launcher:Minecraft"
STORE[medya]="vlc:Medya oynatıcı obs-studio:Yayın kdenlive:Düzenleme mpv:Hafif spotify:Müzik"
STORE[sistem]="htop:İzleyici btop:Gelişmiş neofetch:Bilgi fastfetch:Hızlı timeshift:Yedek"
STORE[sunucu]="apache2:Web nginx:Web openssh-server:SSH mariadb-server:SQL redis:Cache"
STORE[sohbet]="discord:Oyun telegram-desktop:Telegram signal:Şifreli slack:İş zoom:Görüntülü"

RECOMMEND=("firefox" "htop" "vlc" "steam" "discord")

line_store(){
  echo "===== STORE ====="
  echo "1) Kategoriye göre"
  echo "2) Önerilenler"
  echo "3) Tüm uygulamalar"
  echo "4) Arama"
  echo "5) Geri"
  read -p "> " c
  case "$c" in
    1)
      i=1
      declare -A idx
      for k in "${!STORE[@]}"; do echo "$i) $k"; idx[$i]="$k"; ((i++)); done
      read -p "Kategori seçin: " catid
      [ -z "${idx[$catid]}" ] && echo "Geçersiz" && return
      catname=${idx[$catid]}
      apps=${STORE[$catname]}
      j=1
      declare -A pidx
      for a in $apps; do name="${a%%:*}"; desc="${a#*:}"; echo "$j) $name - $desc"; pidx[$j]="$name"; ((j++)); done
      read -p "Seçim (1 2 3 veya all): " sel
      if [[ "$sel" == "all" ]]; then for n in "${pidx[@]}"; do paket_yukle "$n"; done
      else for s in $sel; do paket_yukle "${pidx[$s]}"; done
      fi;;
    2) for a in "${RECOMMEND[@]}"; do paket_yukle "$a"; done;;
    3) for cat in "${!STORE[@]}"; do
         echo "[$cat]"
         for a in ${STORE[$cat]}; do name="${a%%:*}"; desc="${a#*:}"; echo "$name - $desc"; done
       done;;
    4) read -p "Arama kelimesi: " q
       for cat in "${!STORE[@]}"; do
         for a in ${STORE[$cat]}; do name="${a%%:*}"; desc="${a#*:}"; [[ "$name" == *$q* || "$desc" == *$q* ]] && echo "$cat / $name - $desc"
         done
       done;;
  esac
}

parse(){
cmd=$1
shift
case "$cmd" in
line)
  sub=$1
  shift
  case "$sub" in
    paket) paket_yukle "$1";;
    kaldır) paket_kaldir "$1";;
    yükselt) paket_yukselt "$1";;
    ara) paket_ara "$*";;
    show) paket_goruntule "$1";;
    store) line_store;;
    update) line_update;;
    onar) line_onar;;
    logs) line_logs;;
    ayarlar) settings_menu;;
    help) help_menu;;
    exit) exit 0;;
    *) echo "Bilinmeyen subkomut";;
  esac;;
*) echo "Komut başına line ekleyin";;
esac
}

intro
help_menu

while true; do
  echo -n "$(color green LINE)> "
  read -r l1 l2 l3
  parse $l1 $l2 $l3
done
