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

function initialize_aur(){
  _run curl aur.sh > aur.sh
  _run sudo chmod +x aur.sh
  _run aur.sh -si package-query yaourt
}

function install_from_repo(){
  _run sudo pacman -S ${1}
}

function install_from_aur(){
  _run yaourt -S ${1}
}

function cleanup(){
  if ! $keep_yaourt; then
    _run sudo pacman -R yaourt
  fi
  if ! $keep_query_package; then
    _run sudo pacman -R query-package
  fi
  _run rm aur.sh
}

keep_yaourt=false
keep_query_package=false

function restore_pkg_from_file(){
  local isAUR=false
  while read -r line
  do
    if [[ $line != \#* ]] && [ -n "$line" ]; then
      if [[ $line == \[* ]]; then
        echo -e "\nRestoring Packages from ${line:1:${#line}-2}"
        if [[ $line == "[AUR]" ]]; then
          isAUR=true
          initialize_aur
        else
          isAUR=false
        fi
      else
        if $isAUR; then
          if [[ $line == *yaourt* ]]; then
            keep_yaourt=true
            keep_query_package=true
          fi
          if [[ $line == *query-package* ]]; then
            keep_query_package=true
          fi
          install_from_aur $line
        else
          install_from_repo $line
        fi
      fi
    fi
  done < "$1"

  echo "keep_yaourt = ${keep_yaourt}"
  echo "keep_query_package = ${keep_query_package}"
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
fi

restore_pkg_from_file $backup_file

cleanup
