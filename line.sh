#!/usr/bin/env bash
set -euo pipefail

LANG_CODE="tr"
FEEDBACK_EMAIL="zhduken@gmail.com"

C_RST='\033[0m'
C_RED='\033[31m'
C_GRN='\033[32m'
C_WHT='\033[97m'

_println() { printf "%s\n" "$*"; }
_print() { printf "%s" "$*"; }

_is_yes() {
  # returns 0 if input is an explicit yes in current language, else 1
  local a="${1:-}"
  a="${a,,}"
  case "$LANG_CODE" in
    tr) case "$a" in e|evet|y|yes) return 0 ;; *) return 1 ;; esac ;;
    en|de|fr|es) case "$a" in y|yes|j|ja|o|oui|s|si) return 0 ;; *) return 1 ;; esac ;;
    ru) case "$a" in y|yes|д|да|da) return 0 ;; *) return 1 ;; esac ;;
    ar) case "$a" in y|yes|ن|نعم) return 0 ;; *) return 1 ;; esac ;;
    zh) case "$a" in y|yes|是) return 0 ;; *) return 1 ;; esac ;;
    *) case "$a" in y|yes) return 0 ;; *) return 1 ;; esac ;;
  esac
}

_loading() {
  # _loading "Message" duration_seconds
  local msg="$1"; local dur="${2:-2}"
  local end=$(( $(date +%s) + dur ))
  local frames=('|' '/' '-' '\\')
  local i=0
  while [ $(date +%s) -lt $end ]; do
    printf "\r${C_WHT}%s ${C_GRN}%s${C_RST}" "$msg" "${frames[$((i%4))]}"
    i=$((i+1))
    sleep 0.1
  done
  printf "\r%*s\r" 80 ""
}
 

_t() {
  local key="$1"
  case "$LANG_CODE" in
    tr)
      case "$key" in
        WELCOME) echo "LINE: Basit paket köprüsü";;
        PROMPT_LANG) echo "Select a language: 1) Türkçe  2) English  3) Deutsch  4) Español  5) Français  6) Русский  7) العربية  8) 中文 (default 1)";;
        PROMPT_MENU) echo "Komut örnekleri: line yardim | line indir <paket> | line kaldir <paket> | line guncelle | line pm | line dil | line store | line temizle | line cikis";;
        MENU_CHOICE) echo "Seçim: ";;
        HELP_TITLE) echo "Kullanım:";;
        HELP_BODY) echo $'  line yardim\n  line indir <paket_adı> [--pm <yonetici>] [--dil <kod>]\n  line kaldir <paket_adı>\n  line guncelle\n  line pm\n  line dil\n  line store\n  line geri\n  line temizle\n  line cikis' ;;
        REPL_PROMPT) echo "line> ";;
        REPL_INFO) echo "Komutların başına 'line' yazın. 'line yardim' ile yardım.";;
        DETECT_INFO) echo "Dağıtım algılanıyor...";;
        PM_CHOOSE) echo "Paket yöneticisi seçin: ";;
        PM_SUGGEST_APT) echo "Debian/Ubuntu tespit edildi. apt kullanılsın mı? [e/H]";;
        ENTER_PKG) echo "Paket adı: ";;
        INSTALLING) echo "Yükleniyor: ";;
        DONE) echo "Tamamlandı.";;
        ERR_ROOT) echo "Lütfen yönetici yetkisi için komut sudo ile çalıştırılacaktır.";;
        ERR_NO_PM) echo "Uygun paket yöneticisi bulunamadı.";;
        ERR_NO_PKG) echo "Paket adı gerekli.";;
        INFO_PM) echo "Kullanılan paket yöneticisi: ";;
        INFO_LANG_SET) echo "Dil ayarlandı: ";;
        STORE_TITLE) echo "LINE MAĞAZA";;
        STORE_CATEGORIES) echo $'Kategoriler:\n  1) Tarayıcılar (firefox, chromium)\n  2) Multimedya (vlc, mpv)\n  3) Sistem Araçları (htop, neofetch, tmux)\n  4) Geliştirici (git, nodejs, python)\n  5) Ağ (curl, wget, nmap)\n  6) Ofis (libreoffice-fresh)\n  7) Grafik (gimp, inkscape)\n  8) Ses (audacity)\n  9) Editörler (vim, neovim)\n  10) İletişim (telegram-desktop, discord)\n  11) Oyunlar (steam, lutris)\n  12) Sanallaştırma (virt-manager, qemu, edk2-ovmf)\n  13) Konteyner (docker, podman, docker-compose)\n  14) Terminal Araçları (ripgrep, fd, bat)\n  15) IDE/Code (code)\n  0) Geri' ;;
        STORE_SELECT) echo "Seçim: ";;
        STORE_LIST) echo "Liste";;
        STORE_BACK) echo "Geri";;
        STORE_INSTALL_WHICH) echo "Hangisi yüklensin?";;
        STORE_INSTALLING) echo "Yükleniyor: ";;
        STORE_DONE) echo "Tamamlandı.";;
        STORE_FAILED) echo "Başarısız: ";;
        STORE_DETECTED) echo "Algılanan paket yöneticisi: ";;
        STORE_LOADING) echo "Algılanıyor...";;
        STORE_CONTINUE) echo "Devam etmek için Enter'a basın...";;
        FEEDBACK_LABEL) echo "Geri bildirim e-postası: ";;
        *) echo "$key";;
      esac
      ;;
    en)
      case "$key" in
        WELCOME) echo "LINE: Simple package bridge";;
        PROMPT_LANG) echo "Select a language: 1) Türkçe  2) English  3) Deutsch  4) Español  5) Français  6) Русский  7) العربية  8) 中文 (default 1)";;
        PROMPT_MENU) echo "Examples: line help | line install <pkg> | line uninstall <pkg> | line update | line pm | line lang | line store | line clear | line exit";;
        MENU_CHOICE) echo "Choice: ";;
        HELP_TITLE) echo "Usage:";;
        HELP_BODY) echo $'  line help\n  line install <package> [--pm <manager>] [--lang <code>]\n  line uninstall <package>\n  line update\n  line pm\n  line lang\n  line store\n  line feedback\n  line clear\n  line exit' ;;
        REPL_PROMPT) echo "line> ";;
        REPL_INFO) echo "Prefix commands with 'line'. Use 'line help' for help.";;
        DETECT_INFO) echo "Detecting distribution...";;
        PM_CHOOSE) echo "Select package manager: ";;
        PM_SUGGEST_APT) echo "Debian/Ubuntu detected. Use apt? [y/N]";;
        ENTER_PKG) echo "Package name: ";;
        INSTALLING) echo "Installing: ";;
        DONE) echo "Done.";;
        ERR_ROOT) echo "Command will be elevated with sudo if needed.";;
        ERR_NO_PM) echo "No suitable package manager found.";;
        ERR_NO_PKG) echo "Package name is required.";;
        INFO_PM) echo "Using package manager: ";;
        INFO_LANG_SET) echo "Language set: ";;
        STORE_TITLE) echo "LINE STORE";;
        STORE_CATEGORIES) echo $'Categories:\n  1) Browsers (firefox, chromium)\n  2) Multimedia (vlc, mpv)\n  3) System Tools (htop, neofetch, tmux)\n  4) Developer (git, nodejs, python)\n  5) Network (curl, wget, nmap)\n  6) Office (libreoffice)\n  7) Graphics (gimp, inkscape)\n  8) Audio (audacity)\n  9) Editors (vim, neovim)\n  10) Communication (telegram-desktop, discord)\n  11) Gaming (steam, lutris)\n  12) Virtualization (virt-manager, qemu, edk2-ovmf)\n  13) Containers (docker, podman, docker-compose)\n  14) Terminal Tools (ripgrep, fd, bat)\n  15) IDE/Code (code)\n  0) Back' ;;
        STORE_SELECT) echo "Select: ";;
        STORE_LIST) echo "List";;
        STORE_BACK) echo "Back";;
        STORE_INSTALL_WHICH) echo "Install which?";;
        STORE_INSTALLING) echo "Installing: ";;
        STORE_DONE) echo "Done.";;
        STORE_FAILED) echo "Failed: ";;
        STORE_DETECTED) echo "Detected package manager: ";;
        STORE_LOADING) echo "Loading...";;
        STORE_CONTINUE) echo "Press Enter to continue...";;
        *) echo "$key";;
      esac
      ;;
    de)
      case "$key" in
        WELCOME) echo "LINE: Einfacher Paket-Bridge";;
        PROMPT_LANG) echo "Sprache wählen: 1) Türkçe  2) English  3) Deutsch  4) Español  5) Français  6) Русский  7) العربية  8) 中文 (Standard 1)";;
        PROMPT_MENU) echo "Beispiele: line help | line install <paket> | line uninstall <paket> | line update | line pm | line lang | line store | line clear | line exit";;
        MENU_CHOICE) echo "Auswahl: ";;
        HELP_TITLE) echo "Benutzung:";;
        HELP_BODY) echo $'  line help\n  line install <paket> [--pm <manager>] [--lang <code>]\n  line uninstall <paket>\n  line update\n  line pm\n  line lang\n  line store\n  line feedback\n  line clear\n  line exit' ;;
        REPL_PROMPT) echo "line> ";;
        REPL_INFO) echo "Befehle mit 'line' beginnen. 'line help' für Hilfe.";;
        DETECT_INFO) echo "Distribution wird erkannt...";;
        PM_CHOOSE) echo "Paketmanager wählen: ";;
        PM_SUGGEST_APT) echo "Debian/Ubuntu erkannt. apt verwenden? [j/N]";;
        ENTER_PKG) echo "Paketname: ";;
        INSTALLING) echo "Installiere: ";;
        DONE) echo "Fertig.";;
        ERR_ROOT) echo "Befehl wird bei Bedarf mit sudo erhöht.";;
        ERR_NO_PM) echo "Kein Paketmanager gefunden.";;
        ERR_NO_PKG) echo "Paketname erforderlich.";;
        INFO_PM) echo "Paketmanager: ";;
        INFO_LANG_SET) echo "Sprache gesetzt: ";;
        STORE_TITLE) echo "LINE STORE";;
        STORE_CATEGORIES) echo $'Kategorien:\n  1) Browser (firefox, chromium)\n  2) Multimedia (vlc, mpv)\n  3) System-Tools (htop, neofetch, tmux)\n  4) Entwicklung (git, nodejs, python)\n  5) Netzwerk (curl, wget, nmap)\n  6) Büro (libreoffice)\n  7) Grafik (gimp, inkscape)\n  8) Audio (audacity)\n  9) Editoren (vim, neovim)\n  10) Kommunikation (telegram-desktop, discord)\n  11) Spiele (steam, lutris)\n  12) Virtualisierung (virt-manager, qemu, edk2-ovmf)\n  13) Container (docker, podman, docker-compose)\n  14) Terminal-Tools (ripgrep, fd, bat)\n  15) IDE/Code (code)\n  0) Zurück' ;;
        STORE_SELECT) echo "Auswahl: ";;
        STORE_LIST) echo "Liste";;
        STORE_BACK) echo "Zurück";;
        STORE_INSTALL_WHICH) echo "Was installieren?";;
        STORE_INSTALLING) echo "Installiere: ";;
        STORE_DONE) echo "Fertig.";;
        STORE_FAILED) echo "Fehlgeschlagen: ";;
        STORE_DETECTED) echo "Erkannter Paketmanager: ";;
        STORE_LOADING) echo "Lade...";;
        STORE_CONTINUE) echo "Zum Fortfahren Enter drücken...";;
        *) echo "$key";;
      esac
      ;;
    es)
      case "$key" in
        WELCOME) echo "LINE: Puente de paquetes";;
        PROMPT_LANG) echo "Seleccione un idioma: 1) Türkçe  2) English  3) Deutsch  4) Español  5) Français  6) Русский  7) العربية  8) 中文 (predeterminado 1)";;
        PROMPT_MENU) echo "Ejemplos: line help | line install <paquete> | line uninstall <paquete> | line update | line pm | line lang | line store | line clear | line exit";;
        MENU_CHOICE) echo "Opción: ";;
        HELP_TITLE) echo "Uso:";;
        HELP_BODY) echo $'  line help\n  line install <paquete> [--pm <gestor>] [--lang <código>]\n  line uninstall <paquete>\n  line update\n  line pm\n  line lang\n  line store\n  line feedback\n  line clear\n  line exit' ;;
        REPL_PROMPT) echo "line> ";;
        REPL_INFO) echo "Escriba comandos con 'line'. 'line help' para ayuda.";;
        DETECT_INFO) echo "Detectando distribución...";;
        PM_CHOOSE) echo "Seleccione gestor de paquetes: ";;
        PM_SUGGEST_APT) echo "Debian/Ubuntu detectado. ¿Usar apt? [s/N]";;
        ENTER_PKG) echo "Nombre del paquete: ";;
        INSTALLING) echo "Instalando: ";;
        DONE) echo "Hecho.";;
        ERR_ROOT) echo "Se usará sudo si es necesario.";;
        ERR_NO_PM) echo "No se encontró gestor de paquetes.";;
        ERR_NO_PKG) echo "Se requiere nombre del paquete.";;
        INFO_PM) echo "Gestor de paquetes: ";;
        INFO_LANG_SET) echo "Idioma establecido: ";;
        STORE_TITLE) echo "TIENDA LINE";;
        STORE_CATEGORIES) echo $'Categorías:\n  1) Navegadores (firefox, chromium)\n  2) Multimedia (vlc, mpv)\n  3) Herramientas del sistema (htop, neofetch, tmux)\n  4) Desarrollo (git, nodejs, python)\n  5) Red (curl, wget, nmap)\n  6) Oficina (libreoffice)\n  7) Gráficos (gimp, inkscape)\n  8) Audio (audacity)\n  9) Editores (vim, neovim)\n  10) Comunicación (telegram-desktop, discord)\n  11) Juegos (steam, lutris)\n  12) Virtualización (virt-manager, qemu, edk2-ovmf)\n  13) Contenedores (docker, podman, docker-compose)\n  14) Herramientas de terminal (ripgrep, fd, bat)\n  15) IDE/Code (code)\n  0) Volver' ;;
        STORE_SELECT) echo "Seleccionar: ";;
        STORE_LIST) echo "Lista";;
        STORE_BACK) echo "Volver";;
        STORE_INSTALL_WHICH) echo "¿Cuál instalar?";;
        STORE_INSTALLING) echo "Instalando: ";;
        STORE_DONE) echo "Hecho.";;
        STORE_FAILED) echo "Falló: ";;
        STORE_DETECTED) echo "Gestor detectado: ";;
        STORE_LOADING) echo "Cargando...";;
        STORE_CONTINUE) echo "Presione Enter para continuar...";;
        *) echo "$key";;
      esac
      ;;
    fr)
      case "$key" in
        WELCOME) echo "LINE: Passerelle de paquets";;
        PROMPT_LANG) echo "Choisir la langue : 1) Türkçe  2) English  3) Deutsch  4) Español  5) Français  6) Русский  7) العربية  8) 中文 (par défaut 1)";;
        PROMPT_MENU) echo "Exemples : line help | line install <paquet> | line uninstall <paquet> | line update | line pm | line lang | line store | line clear | line exit";;
        MENU_CHOICE) echo "Choix: ";;
        HELP_TITLE) echo "Utilisation:";;
        HELP_BODY) echo $'  line help\n  line install <paquet> [--pm <gestionnaire>] [--lang <code>]\n  line uninstall <paquet>\n  line update\n  line pm\n  line lang\n  line store\n  line feedback\n  line clear\n  line exit' ;;
        REPL_PROMPT) echo "line> ";;
        REPL_INFO) echo "Préfixez les commandes par 'line'. 'line help' pour l'aide.";;
        DETECT_INFO) echo "Détection de la distribution...";;
        PM_CHOOSE) echo "Sélectionnez le gestionnaire de paquets: ";;
        PM_SUGGEST_APT) echo "Debian/Ubuntu détecté. Utiliser apt ? [o/N]";;
        ENTER_PKG) echo "Nom du paquet: ";;
        INSTALLING) echo "Installation: ";;
        DONE) echo "Terminé.";;
        ERR_ROOT) echo "sudo sera utilisé si nécessaire.";;
        ERR_NO_PM) echo "Aucun gestionnaire de paquets trouvé.";;
        ERR_NO_PKG) echo "Nom du paquet requis.";;
        INFO_PM) echo "Gestionnaire de paquets: ";;
        INFO_LANG_SET) echo "Langue définie: ";;
        STORE_TITLE) echo "BOUTIQUE LINE";;
        STORE_CATEGORIES) echo $'Catégories :\n  1) Navigateurs (firefox, chromium)\n  2) Multimédia (vlc, mpv)\n  3) Outils système (htop, neofetch, tmux)\n  4) Développement (git, nodejs, python)\n  5) Réseau (curl, wget, nmap)\n  6) Bureautique (libreoffice)\n  7) Graphisme (gimp, inkscape)\n  8) Audio (audacity)\n  9) Éditeurs (vim, neovim)\n  10) Communication (telegram-desktop, discord)\n  11) Jeux (steam, lutris)\n  12) Virtualisation (virt-manager, qemu, edk2-ovmf)\n  13) Conteneurs (docker, podman, docker-compose)\n  14) Outils terminal (ripgrep, fd, bat)\n  15) IDE/Code (code)\n  0) Retour' ;;
        STORE_SELECT) echo "Sélection: ";;
        STORE_LIST) echo "Liste";;
        STORE_BACK) echo "Retour";;
        STORE_INSTALL_WHICH) echo "Installer lequel ?";;
        STORE_INSTALLING) echo "Installation : ";;
        STORE_DONE) echo "Terminé.";;
        STORE_FAILED) echo "Échec : ";;
        STORE_DETECTED) echo "Gestionnaire détecté : ";;
        STORE_LOADING) echo "Chargement...";;
        STORE_CONTINUE) echo "Appuyez sur Entrée pour continuer...";;
        *) echo "$key";;
      esac
      ;;
    ru)
      case "$key" in
        WELCOME) echo "LINE: Мост пакетных менеджеров";;
        PROMPT_LANG) echo "Выберите язык: 1) Türkçe  2) English  3) Deutsch  4) Español  5) Français  6) Русский  7) العربية  8) 中文 (по умолчанию 1)";;
        PROMPT_MENU) echo "Примеры: line help | line install <пакет> | line uninstall <пакет> | line update | line pm | line lang | line store | line clear | line exit";;
        MENU_CHOICE) echo "Выбор: ";;
        HELP_TITLE) echo "Использование:";;
        HELP_BODY) echo $'  line help\n  line install <пакет> [--pm <менеджер>] [--lang <код>]\n  line uninstall <пакет>\n  line update\n  line pm\n  line lang\n  line store\n  line feedback\n  line clear\n  line exit' ;;
        DETECT_INFO) echo "Определение дистрибутива...";;
        PM_CHOOSE) echo "Выберите менеджер пакетов: ";;
        PM_SUGGEST_APT) echo "Обнаружен Debian/Ubuntu. Использовать apt? [y/N]";;
        ENTER_PKG) echo "Имя пакета: ";;
        INSTALLING) echo "Установка: ";;
        DONE) echo "Готово.";;
        ERR_ROOT) echo "При необходимости будет использован sudo.";;
        ERR_NO_PM) echo "Менеджер пакетов не найден.";;
        ERR_NO_PKG) echo "Требуется имя пакета.";;
        INFO_PM) echo "Менеджер пакетов: ";;
        INFO_LANG_SET) echo "Язык установлен: ";;
        STORE_TITLE) echo "LINE МАГАЗИН";;
        STORE_CATEGORIES) echo $'Категории:\n  1) Браузеры (firefox, chromium)\n  2) Мультимедиа (vlc, mpv)\n  3) Системные инструменты (htop, neofetch, tmux)\n  4) Разработка (git, nodejs, python)\n  5) Сеть (curl, wget, nmap)\n  6) Офис (libreoffice)\n  7) Графика (gimp, inkscape)\n  8) Аудио (audacity)\n  9) Редакторы (vim, neovim)\n  10) Связь (telegram-desktop, discord)\n  11) Игры (steam, lutris)\n  12) Виртуализация (virt-manager, qemu, edk2-ovmf)\n  13) Контейнеры (docker, podman, docker-compose)\n  14) Терминальные инструменты (ripgrep, fd, bat)\n  15) IDE/Code (code)\n  0) Назад' ;;
        STORE_SELECT) echo "Выбор: ";;
        STORE_LIST) echo "Список";;
        STORE_BACK) echo "Назад";;
        STORE_INSTALL_WHICH) echo "Что установить?";;
        STORE_INSTALLING) echo "Установка: ";;
        STORE_DONE) echo "Готово.";;
        STORE_FAILED) echo "Не удалось: ";;
        STORE_DETECTED) echo "Обнаружен менеджер пакетов: ";;
        STORE_LOADING) echo "Загрузка...";;
        STORE_CONTINUE) echo "Нажмите Enter для продолжения...";;
        *) echo "$key";;
      esac
      ;;
    ar)
      case "$key" in
        WELCOME) echo "LINE: جسر مديري الحزم";;
        PROMPT_LANG) echo "اختر لغة: 1) Türkçe  2) English  3) Deutsch  4) Español  5) Français  6) Русский  7) العربية  8) 中文 (الافتراضي 1)";;
        PROMPT_MENU) echo "أمثلة: line help | line install <الحزمة> | line uninstall <الحزمة> | line update | line pm | line lang | line store | line clear | line exit";;
        MENU_CHOICE) echo "اختيار: ";;
        HELP_TITLE) echo "الاستخدام:";;
        HELP_BODY) echo $'  line help\n  line install <الحزمة> [--pm <المدير>] [--lang <الرمز>]\n  line uninstall <الحزمة>\n  line update\n  line pm\n  line lang\n  line store\n  line feedback\n  line clear\n  line exit' ;;
        DETECT_INFO) echo "اكتشاف التوزيعة...";;
        PM_CHOOSE) echo "اختر مدير الحزم: ";;
        PM_SUGGEST_APT) echo "تم اكتشاف Debian/Ubuntu. استخدام apt؟ [y/N]";;
        ENTER_PKG) echo "اسم الحزمة: ";;
        INSTALLING) echo "تثبيت: ";;
        DONE) echo "تم.";;
        ERR_ROOT) echo "سيُستخدم sudo إذا لزم.";;
        ERR_NO_PM) echo "لم يتم العثور على مدير حزم.";;
        ERR_NO_PKG) echo "اسم الحزمة مطلوب.";;
        INFO_PM) echo "مدير الحزم: ";;
        INFO_LANG_SET) echo "تم ضبط اللغة: ";;
        STORE_TITLE) echo "متجر LINE";;
        STORE_CATEGORIES) echo $'الفئات:\n  1) المتصفحات (firefox, chromium)\n  2) الوسائط (vlc, mpv)\n  3) أدوات النظام (htop, neofetch, tmux)\n  4) التطوير (git, nodejs, python)\n  5) الشبكات (curl, wget, nmap)\n  6) المكتب (libreoffice)\n  7) الرسومات (gimp, inkscape)\n  8) الصوت (audacity)\n  9) المحررات (vim, neovim)\n  10) الاتصالات (telegram-desktop, discord)\n  11) الألعاب (steam, lutris)\n  12) الافتراضية (virt-manager, qemu, edk2-ovmf)\n  13) الحاويات (docker, podman, docker-compose)\n  14) أدوات الطرفية (ripgrep, fd, bat)\n  15) IDE/Code (code)\n  0) رجوع' ;;
        STORE_SELECT) echo "اختيار: ";;
        STORE_LIST) echo "قائمة";;
        STORE_BACK) echo "رجوع";;
        STORE_INSTALL_WHICH) echo "ما الذي تريد تثبيته؟";;
        STORE_INSTALLING) echo "تثبيت: ";;
        STORE_DONE) echo "تم.";;
        STORE_FAILED) echo "فشل: ";;
        STORE_DETECTED) echo "مدير الحزم المكتشف: ";;
        STORE_LOADING) echo "جارٍ التحميل...";;
        STORE_CONTINUE) echo "اضغط Enter للمتابعة...";;
        *) echo "$key";;
      esac
      ;;
    zh)
      case "$key" in
        WELCOME) echo "LINE：包管理桥";;
        PROMPT_LANG) echo "选择语言：1) Türkçe  2) English  3) Deutsch  4) Español  5) Français  6) Русский  7) العربية  8) 中文（默认 1）";;
        PROMPT_MENU) echo "示例：line help | line install <软件包> | line uninstall <软件包> | line update | line pm | line lang | line store | line clear | line exit";;
        MENU_CHOICE) echo "选择： ";;
        HELP_TITLE) echo "用法:";;
        HELP_BODY) echo $'  line help\n  line install <软件包> [--pm <管理器>] [--lang <代码>]\n  line uninstall <软件包>\n  line update\n  line pm\n  line lang\n  line store\n  line feedback\n  line clear\n  line exit' ;;
        DETECT_INFO) echo "正在检测发行版...";;
        PM_CHOOSE) echo "选择包管理器: ";;
        PM_SUGGEST_APT) echo "检测到 Debian/Ubuntu。使用 apt？ [y/N]";;
        ENTER_PKG) echo "软件包名: ";;
        INSTALLING) echo "正在安装: ";;
        DONE) echo "完成。";;
        ERR_ROOT) echo "如需将使用 sudo。";;
        ERR_NO_PM) echo "未找到包管理器。";;
        ERR_NO_PKG) echo "需要软件包名。";;
        INFO_PM) echo "包管理器：";;
        INFO_LANG_SET) echo "语言已设置：";;
        STORE_TITLE) echo "LINE 商店";;
        STORE_CATEGORIES) echo $'分类：\n  1) 浏览器 (firefox, chromium)\n  2) 多媒体 (vlc, mpv)\n  3) 系统工具 (htop, neofetch, tmux)\n  4) 开发 (git, nodejs, python)\n  5) 网络 (curl, wget, nmap)\n  6) 办公 (libreoffice)\n  7) 图形 (gimp, inkscape)\n  8) 音频 (audacity)\n  9) 编辑器 (vim, neovim)\n  10) 通讯 (telegram-desktop, discord)\n  11) 游戏 (steam, lutris)\n  12) 虚拟化 (virt-manager, qemu, edk2-ovmf)\n  13) 容器 (docker, podman, docker-compose)\n  14) 终端工具 (ripgrep, fd, bat)\n  15) IDE/Code (code)\n  0) 返回' ;;
        STORE_SELECT) echo "选择：";;
        STORE_LIST) echo "列表";;
        STORE_BACK) echo "返回";;
        STORE_INSTALL_WHICH) echo "安装哪个？";;
        STORE_INSTALLING) echo "正在安装: ";;
        STORE_DONE) echo "完成。";;
        STORE_FAILED) echo "失败：";;
        STORE_DETECTED) echo "检测到的包管理器：";;
        STORE_LOADING) echo "正在加载...";;
        STORE_CONTINUE) echo "按 Enter 继续...";;
        *) echo "$key";;
      esac
      ;;
    *) echo "$key";;
  esac
}

_read_lang() {
  local inp
  _println "$(_t PROMPT_LANG)"
  _print "> "; read -r inp || true
  inp="${inp:-1}"
  case "$inp" in
    1|tr|TR|Türkçe|turkce) LANG_CODE="tr" ;;
    2|en|EN|English) LANG_CODE="en" ;;
    3|de|DE|Deutsch) LANG_CODE="de" ;;
    4|es|ES|Español) LANG_CODE="es" ;;
    5|fr|FR|Français) LANG_CODE="fr" ;;
    6|ru|RU|Русский) LANG_CODE="ru" ;;
    7|ar|AR|العربية) LANG_CODE="ar" ;;
    8|zh|ZH|中文) LANG_CODE="zh" ;;
    *) LANG_CODE="tr" ;;
  esac
}

_print_help() {
  _println "$(_t HELP_TITLE)"
  _println "$(_t HELP_BODY)"
}

_detect_pm() {
  local pm=""
  if [ -r /etc/os-release ]; then
    . /etc/os-release || true
  fi
  if [ "${ID:-}" = "arch" ] || [[ "${ID_LIKE:-}" == *"arch"* ]]; then
    pm="pacman"
  elif [[ "${ID_LIKE:-}${ID:-}" == *"debian"* ]] || [[ "${ID:-}" == "ubuntu" ]]; then
    pm="apt"
  fi
  if [ -z "$pm" ]; then
    local candidates=(pacman apt dnf zypper xbps-install apk emerge nix-env brew)
    for c in "${candidates[@]}"; do if command -v "$c" >/dev/null 2>&1; then pm="$c"; break; fi; done
  fi
  if [ -z "$pm" ]; then
    _println "$(_t ERR_NO_PM)"; return 1
  fi
  echo "$pm"
}

PM_CACHED=""
_ensure_pm() {
  if [ -z "${PM_CACHED:-}" ]; then
    PM_CACHED="$(_detect_pm)"
  fi
  echo "$PM_CACHED"
}

_pm_id() {
  local id="unknown"
  if [ -r /etc/os-release ]; then
    . /etc/os-release || true
    id="${ID:-unknown}"
  fi
  echo "$id"
}

_pkg_map() {
  # Usage: _pkg_map <generic_name>
  local name="$1"
  local pm="$(_ensure_pm)"
  local id="$(_pm_id)"
  case "$name" in
    firefox) echo "firefox" ;;
    chromium)
      case "$id" in ubuntu|debian) echo "chromium" ;; fedora) echo "chromium" ;; arch|manjaro) echo "chromium" ;; *) echo "chromium" ;; esac ;;
    brave) echo "brave" ;;
    vlc) echo "vlc" ;;
    mpv) echo "mpv" ;;
    obs-studio) echo "obs-studio" ;;
    kdenlive) echo "kdenlive" ;;
    htop) echo "htop" ;;
    neofetch) echo "neofetch" ;;
    tmux) echo "tmux" ;;
    btop) echo "btop" ;;
    lsd) echo "lsd" ;;
    git) echo "git" ;;
    nodejs)
      case "$pm" in apt|dnf) echo "nodejs npm" ;; pacman) echo "nodejs npm" ;; *) echo "nodejs" ;; esac ;;
    python3)
      case "$pm" in apt|dnf) echo "python3" ;; pacman) echo "python" ;; *) echo "python3" ;; esac ;;
    go) echo "go" ;;
    rust) case "$pm" in apt) echo "rustc cargo" ;; dnf|pacman) echo "rust" ;; *) echo "rust" ;; esac ;;
    curl) echo "curl" ;;
    wget) echo "wget" ;;
    nmap) echo "nmap" ;;
    traceroute) echo "traceroute" ;;
    libreoffice|libreoffice-fresh)
      case "$pm" in pacman) echo "libreoffice-fresh" ;; apt) echo "libreoffice" ;; dnf) echo "libreoffice" ;; *) echo "libreoffice" ;; esac ;;
    gimp) echo "gimp" ;;
    inkscape) echo "inkscape" ;;
    krita) echo "krita" ;;
    audacity) echo "audacity" ;;
    pulseaudio) echo "pulseaudio" ;;
    pavucontrol) echo "pavucontrol" ;;
    vim) echo "vim" ;;
    neovim) echo "neovim" ;;
    micro) echo "micro" ;;
    telegram-desktop) echo "telegram-desktop" ;;
    discord) echo "discord" ;;
    signal-desktop) echo "signal-desktop" ;;
    steam) echo "steam" ;;
    lutris) echo "lutris" ;;
    virt-manager) echo "virt-manager" ;;
    qemu) echo "qemu" ;;
    edk2-ovmf) echo "edk2-ovmf" ;;
    docker) echo "docker" ;;
    podman) echo "podman" ;;
    docker-compose)
      case "$pm" in apt) echo "docker-compose" ;; dnf) echo "docker-compose" ;; pacman) echo "docker-compose" ;; *) echo "docker-compose" ;; esac ;;
    ripgrep) echo "ripgrep" ;;
    fd)
      case "$pm" in apt) echo "fd-find" ;; *) echo "fd" ;; esac ;;
    bat) echo "bat" ;;
    code) echo "code" ;;
    *) echo "$name" ;;
  esac
}

_install_generic() {
  # Accepts a generic package key and installs mapped package(s)
  local gen="$1"
  local mapped
  mapped="$(_pkg_map "$gen")"
  # shellcheck disable=SC2206
  local pkgs=( $mapped )
  for p in "${pkgs[@]}"; do
    _install_pkg "$p" || return 1
  done
}

_install_pkg() {
  local pkg="$1"; shift || true
  local pm_override=""
  while [ $# -gt 0 ]; do
    case "$1" in
      --pm) pm_override="$2"; shift 2;;
      *) shift;;
    esac
  done
  local pm
  if [ -n "$pm_override" ]; then pm="$pm_override"; else pm="$(_ensure_pm)"; fi
  local sudo_cmd=""
  case "$pm" in
    pacman|apt|dnf|zypper|xbps-install|apk|emerge) sudo_cmd="sudo" ;;
    *) sudo_cmd="" ;;
  esac
  case "$pm" in
    pacman) $sudo_cmd pacman -S --needed --noconfirm "$pkg" ;;
    apt) $sudo_cmd apt update -y && $sudo_cmd apt install -y "$pkg" ;;
    dnf) $sudo_cmd dnf install -y "$pkg" ;;
    zypper) $sudo_cmd zypper install -y "$pkg" ;;
    xbps-install) $sudo_cmd xbps-install -y "$pkg" ;;
    apk) $sudo_cmd apk add "$pkg" ;;
    emerge) $sudo_cmd emerge "$pkg" ;;
    nix-env) nix-env -iA "$pkg" ;;
    brew) brew install "$pkg" ;;
    *) _println "$(_t ERR_NO_PM)"; return 1 ;;
  esac
}

_remove_pkg() {
  local pkg="$1"; shift || true
  local pm="$(_ensure_pm)"
  local sudo_cmd=""
  case "$pm" in
    pacman|apt|dnf|zypper|xbps-install|apk|emerge) sudo_cmd="sudo" ;;
    *) sudo_cmd="" ;;
  esac
  case "$pm" in
    pacman) $sudo_cmd pacman -R --noconfirm "$pkg" ;;
    apt) $sudo_cmd apt remove -y "$pkg" ;;
    dnf) $sudo_cmd dnf remove -y "$pkg" ;;
    zypper) $sudo_cmd zypper remove -y "$pkg" ;;
    xbps-install) $sudo_cmd xbps-remove -y "$pkg" ;;
    apk) $sudo_cmd apk del "$pkg" ;;
    emerge) $sudo_cmd emerge -C "$pkg" ;;
    nix-env) nix-env -e "$pkg" ;;
    brew) brew uninstall "$pkg" ;;
    *) _println "$(_t ERR_NO_PM)"; return 1 ;;
  esac
}

_update_system() {
  local pm="$(_ensure_pm)"
  local sudo_cmd=""
  case "$pm" in
    pacman|apt|dnf|zypper|xbps-install|apk|emerge) sudo_cmd="sudo" ;;
    *) sudo_cmd="" ;;
  esac
  case "$pm" in
    pacman) $sudo_cmd pacman -Syu --noconfirm ;;
    apt) $sudo_cmd apt update -y && $sudo_cmd apt upgrade -y ;;
    dnf) $sudo_cmd dnf upgrade -y ;;
    zypper) $sudo_cmd zypper update -y ;;
    xbps-install) $sudo_cmd xbps-install -Su ;;
    apk) $sudo_cmd apk update && $sudo_cmd apk upgrade ;;
    emerge) $sudo_cmd emerge --update --deep --newuse @world ;;
    nix-env) nix-env -u ;;
    brew) brew update && brew upgrade ;;
    *) _println "$(_t ERR_NO_PM)"; return 1 ;;
  esac
}

_clear_screen() { command -v clear >/dev/null 2>&1 && clear || printf "\033c"; }

_feedback() {
  printf "${C_WHT}%s${C_RST}%s\n" "$(_t FEEDBACK_LABEL)" "$FEEDBACK_EMAIL"
}

_repl() {
  _clear_screen
  printf "${C_GRN}%s${C_RST}\n\n" "$(_t WELCOME)"; _println ""
  printf "${C_WHT}%s${C_RST}\n" "$(_t PROMPT_MENU)"; _println ""
  _println "$(_t REPL_INFO)"
  while true; do
    printf "${C_GRN}%s${C_RST}" "$(_t REPL_PROMPT)"; local line; IFS= read -r line || break
    [ -z "${line:-}" ] && continue
    case "$line" in
      line\ *) ;;
      *) _println "$(_t REPL_INFO)"; continue ;;
    esac
    local tokens=( $line )
    local cmd="${tokens[1]:-}"
    case "$cmd" in
      yardim|help|-h|--help)
        _print_help ;;
      indir|install)
        local pkg="${tokens[2]:-}"
        [ -z "$pkg" ] && { printf "${C_RED}%s${C_RST}\n" "$(_t ERR_NO_PKG)"; continue; }
        _println "$(_t INSTALLING)$pkg"; _install_pkg "$pkg" ; _println "$(_t DONE)" ;;
      kaldir|remove|sil|uninstall)
        local pkg="${tokens[2]:-}"
        [ -z "$pkg" ] && { printf "${C_RED}%s${C_RST}\n" "$(_t ERR_NO_PKG)"; continue; }
        _remove_pkg "$pkg" ; _println "$(_t DONE)" ;;
      guncelle|update)
        _update_system ; _println "$(_t DONE)" ;;
      pm)
        local pm="$(_ensure_pm)"; _println "$(_t INFO_PM)$pm" ;;
      dil|lang)
        _read_lang; _println "$(_t INFO_LANG_SET)$LANG_CODE" ;;
      geri|feedback)
        _feedback ;;
      store)
        _store ;;
      temizle|clear)
        _clear_screen ;;
      cikis|exit|quit)
        break ;;
      *)
        _print_help ;;
    esac
  done
}

_store() {
  while true; do
    _clear_screen
    printf "${C_GRN}%s${C_RST}\n\n" "$(_t STORE_TITLE)"
    _loading "$(_t STORE_LOADING)" 2
    local pm_detected="$(_ensure_pm)"
    printf "${C_WHT}%s${C_RST} ${C_GRN}%s${C_RST}\n\n" "$(_t STORE_DETECTED)" "$pm_detected"
    printf "${C_WHT}%s${C_RST}\n" "$(_t STORE_CATEGORIES)"
    printf "%s" "$(_t STORE_SELECT)"; local sel; read -r sel || break
    case "$sel" in
      0) break ;;
      1) local apps=(firefox chromium brave) ;;
      2) local apps=(vlc mpv obs-studio kdenlive) ;;
      3) local apps=(htop neofetch tmux btop lsd) ;;
      4) local apps=(git nodejs python3 go rust) ;;
      5) local apps=(curl wget nmap traceroute) ;;
      6) local apps=(libreoffice) ;;
      7) local apps=(gimp inkscape krita) ;;
      8) local apps=(audacity pulseaudio pavucontrol) ;;
      9) local apps=(vim neovim micro) ;;
      10) local apps=(telegram-desktop discord signal-desktop) ;;
      11) local apps=(steam lutris) ;;
      12) local apps=(virt-manager qemu edk2-ovmf) ;;
      13) local apps=(docker podman docker-compose) ;;
      14) local apps=(ripgrep fd bat) ;;
      15) local apps=(code) ;;
      *) continue ;;
    esac
    while true; do
      _clear_screen
      printf "${C_GRN}%s${C_RST} - %s\n\n" "$(_t STORE_TITLE)" "$(_t STORE_LIST)"
      local i=1
      for a in "${apps[@]}"; do printf "  %d) %s\n" "$i" "$a"; i=$((i+1)); done
      printf "  0) %s\n\n" "$(_t STORE_BACK)"
      printf "%s " "$(_t STORE_INSTALL_WHICH)"; local s; read -r s || break
      [ "$s" = "0" ] && break
      if [[ "$s" =~ ^[0-9]+$ ]] && [ "$s" -ge 1 ] && [ "$s" -le ${#apps[@]} ]; then
        local pkg="${apps[$((s-1))]}"
        printf "${C_WHT}%s %s${C_RST}\n" "$(_t STORE_INSTALLING)" "$pkg"
        _install_generic "$pkg" || { printf "${C_RED}%s%s${C_RST}\n" "$(_t STORE_FAILED)" "$pkg"; read -r -p "$(_t STORE_CONTINUE)" _; }
        printf "${C_GRN}%s${C_RST}\n" "$(_t STORE_DONE)"; read -r -p "$(_t STORE_CONTINUE)" _
      fi
    done
  done
}

main() {
  local args=("$@")
  local i=0
  while [ $i -lt ${#args[@]} ]; do
    case "${args[$i]}" in
      --dil|--lang) LANG_CODE="${args[$((i+1))]:-tr}"; i=$((i+2)); continue ;;
      *) i=$((i+1)); ;;
    esac
  done
  case "$LANG_CODE" in tr|en|de|es|fr|ru|ar|zh) : ;; *) LANG_CODE="tr" ;; esac

  if [ $# -eq 0 ]; then
    _read_lang
    _repl
    exit 0
  fi

  case "${1:-}" in
    yardim|help|-h|--help)
      _print_help ;;
    geri|feedback)
      _feedback ;;
    indir)
      shift || true
      local pkg="${1:-}"
      [ -z "$pkg" ] && { _println "$(_t ERR_NO_PKG)"; exit 1; }
      _println "$(_t DETECT_INFO)"
      _println "$(_t INSTALLING)$pkg"
      _install_pkg "$pkg" "$@"
      _println "$(_t DONE)" ;;
    store)
      _read_lang; _store ;;
    kaldir|remove|sil)
      shift || true
      local pkg="${1:-}"
      [ -z "$pkg" ] && { _println "$(_t ERR_NO_PKG)"; exit 1; }
      _remove_pkg "$pkg" ; _println "$(_t DONE)" ;;
    guncelle|update)
      _update_system ; _println "$(_t DONE)" ;;
    pm)
      _println "$(_t INFO_PM)$(_ensure_pm)" ;;
    dil|lang)
      _read_lang; _println "$(_t INFO_LANG_SET)$LANG_CODE" ;;
    temizle|clear)
      _clear_screen ;;
    cikis|exit|quit)
      exit 0 ;;
    *)
      _print_help ;;
  esac
}

main "$@"

    
