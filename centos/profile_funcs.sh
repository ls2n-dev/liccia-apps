function liccia_log(){
  TAG='INFO'
  case "$1" in
    INFO | CMD)  TAG=$1; shift ;;
    ERROR) TAG="*ERROR*"; shift ;;
  esac
  echo "[`date +%Y-%m-%dT%T%z`] $TAG $*" | tee -a $LICCIA_LOGFILE
}
export -f liccia_log
