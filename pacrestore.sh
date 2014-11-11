#! /bin/bash 

function print_help(){
  echo "This scripts restores package installed via pacman"
  echo "And backed-up using pacbackup"
  echo "Usage : "
  echo "pacrestore.sh -b <path_to_pacbackup_file>"
  echo "By default, the backup file should be in the current directory"
}

function _run(){
  if $dry_run; then
    echo $@
  else
    $@
  fi
}

function install_from_repo(){
  _run sudo pacman -S ${1}
}

function install_from_aur(){
  echo ${1}
  # _run bash <(curl aur.sh) -si ${1}
}

function parse_file(){
  local isAUR=false
  while read -r line
  do
    if [[ $line != \#* ]] && [ -n "$line" ]; then
      if [[ $line == \[* ]]; then
        echo -e "\nRestoring Packages from ${line:1:${#line}-2}"
        if [[ $line == "[AUR]" ]]; then
          isAUR=true
        else
          isAUR=false
        fi
      else
        if [ "$isAUR" == true ]; then
          install_from_aur $line
        else
          install_from_repo $line
        fi
      fi
    fi
  done < "$1"
}

backup_file="./pkglist"
dry_run=false

while getopts "h?b:n?" opt; do
    case "$opt" in
    h|\?)
        print_help
        exit 0
        ;;
    b)  backup_file=$OPTARG
        ;;
    n)  dry_run=true
        ;;
    esac
done

if $dry_run;then
  echo "Running in Dry-Run Mode"
  echo ${dry_run}
fi


parse_file $backup_file
