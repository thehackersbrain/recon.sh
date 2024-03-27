#!/bin/bash


# Color Codes
GRN="\e[0;32m"
RED="\e[0;31m"
RST="\e[0m"
UDL="\e[4m"
BLD="\e[1m"
ITL="\e[3m"

TOOLNAME=$(basename "$0")

# Files
TARGETFILE="$1"
OUTFILE_A="amass-initial-subdomains.txt"
OUTFILE_SF="subfinder-initial-subdomains.txt"
SUBDFILE="initial-subdomains.txt"
PFILE="probed-subdomains.txt"
WFILE="waybackurls-urls.txt"
UUFILE="uniq-urls.txt"


log_msg() {
    local left_text="$1"
    local right_text="$2"
    local log_type="$3"
    local width=$(tput cols)
    local timestamp=$(date +'%Y-%m-%d %H:%M:%S')
    local position=$((width - ${#right_text}))

    case "$log_type" in
      0) color_code='\e[4;32m' ;; # Green
      1) color_code='\e[4;33m' ;; # Yellow
      2) color_code='\e[4;31m' ;; # Red
      *) color_code='\e[0;0m'  ;; # No color
    esac

    # Print timestamp and left text
    echo -ne "\n[$timestamp] ${BLD}${GRN}$TOOLNAME${RST} - [${ITL}$left_text${RST}]"

    # Move cursor to the rightmost side of the screen
    echo -ne "\e[${position}G"

    # Print right text at the rightmost side with underlining
    echo -e "${UDL}${color_code}${right_text}${RST}\n"
}


subdomain_enum() {
    log_msg "Subfinder" "Enumeration Started" 1
    log_msg "Amass" "Enumeration Started" 1

    (subfinder -dL $TARGETFILE -v -o $OUTFILE_SF; log_msg "Subfinder" "Enumeration completed" 0) &
    (amass enum -passive -df $TARGETFILE -o $OUTFILE_A; log_msg "Amass" "Enumeration completed" 0) &

    wait %1
    wait %2
    
    # Getting subdomains from the output files
    cat $OUTFILE_A | grep -i fqdn | cut -d " " -f1 | grep -f $TARGETFILE | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" | anew $SUBDFILE

    cat $OUTFILE_SF | grep -f $TARGETFILE | anew $SUBDFILE && log_msg "Anew (subfinder, amass)" "Initial Subdomains file created (`cat $SUBDFILE | wc -l`)" 0

    log_msg "httpx" "Looking for live hosts" 1

    cat $SUBDFILE | httpx -o $PFILE >/dev/null && log_msg "httpx" "Live hosts file saved `cat $PFILE | wc -l`" 0

    log_msg "Waybackurls" "Looking for urls" 1

    cat $PFILE | waybackurls | anew $WFILE && log_msg "Waybackurls" "Waybackurls urls saved" 0
    
    log_msg "Uro" "Finding uniqe urls" 1

    cat $WFILE | uro -o $UUFILE && log_msg "Uro" "Uniq urls saved" 0
}


help() {
  echo "Usage: $TOOLNAME <filename>" >&2
  exit 1
}


main() {
  subdomain_enum
  log_msg "Recon" "Recon completed" 0
}



if [[ "$#" -eq 2 ]]; then
  if [[ "$1" = "-v" ]] || [[ "$2" = "-v" ]]; then
    echo "Verbose Mode"
    help
  else
    help
  fi
elif [[ "$#" -eq 1 ]] && [[ "$1" == *txt ]]; then
  subdomain_enum
else
  help
fi

