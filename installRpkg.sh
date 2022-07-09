#!/bin/sh
set -e
#DOT_DIRECTORY="${HOME}"
DOT_DIRECTORY=$(pwd)

usage() {
  name=`basename $0`
  cat <<EOF
Usage:
  $name [arguments] [command]
Commands:
  install
  update
Arguments:
  -h Print help
EOF
  exit 1
}

while getopts :fh opt; do
  case ${opt} in
    h)
      usage
      ;;
  esac
done
shift $((OPTIND - 1))

install_pkg() {
  while read line
  do
    echo $line
    export line
    Rscript --vanilla ${DOT_DIRECTORY}/R/Rpkg.R $line
  done < ${DOT_DIRECTORY}/R/Rpkg.list
}

update_pkg() {
  Rscript --vanilla ${DOT_DIRECTORY}/R/Rpkg.R
}

command=$1
[ $# -gt 0 ] && shift

case $command in
  install)
    install_pkg
    ;;
  update*)
    update_pkg
    ;;
  *)
    usage
    ;;
esac
