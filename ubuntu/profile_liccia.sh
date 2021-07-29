# LICCiA User Environment
export LICCIA_MAIN=/opt/liccia
export LICCIA_BIN=$LICCIA_MAIN/bin
export LICCIA_DATADIR=$LICCIA_MAIN/data
export LICCIA_LOGFILE=$LICCIA_MAIN/liccia.log
export PATH=$PATH:$LICCIA_BIN

function liccia_log(){
  echo "[`date +%Y-%m-%dT%T%z`] $*" | tee -a $LICCIA_LOGFILE
}
export -f liccia_log

