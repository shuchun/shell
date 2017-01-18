#!/bin/sh
# ------------------------------------
# -     sync by block                -
# -     Auth: shuchuneric@163.com    -
# ------------------------------------

tfsBase=/usr/local/tfs-2.2.16/
tfsNSIp=127.0.0.1
tfsPort=10001

tfsDistNSIp=127.0.0.1
tfsDistPort=10001



function helpInfo(){
  echo 'Usage: '$0' [status ] | [bak ] | [help]'
}


function getTfsBlockInfo(){

	echo '导出tfs block信息'
	${tfsBase}/bin/ssm -s ${tfsNSIp}:${tfsPort} -i 'block ' > /tmp/block.txt
}


function filterInfoToBlkId(){

	#
	#   BLOCK_ID   VERSION    FILECOUNT  SIZE           DEL_FILE   DEL_SIZE   SEQ_NO  COPYS
	#     21331   3297          2195  134557684          0          0       3055        2
	echo '信息处理中.....'

	awk '{if($3 > '$limit' && $3 != "FILECOUNT"){print$1}}' /tmp/block.txt > /tmp/syncBlk.txt 2>/dev/null
	lastRow=`tail -1 /tmp/syncBlk.txt | cut -d ':' -f1`
  if [[ $lastRow == "TOTAL" ]];then
    sed -i '/'"$lastRow"'/d' /tmp/syncBlk.txt
  fi
	#sed -i '1d' /tmp/comBlk.txt
}

function syncBak(){

	echo '开始迁移tfs'
  eval "${tfsBase}/bin/sync_by_blk -s ${tfsNSIp}:${tfsPort} -d ${tfsDistNSIp}:${tfsDistPort}  -f /tmp/syncBlk.txt"  >> /tmp/bakResult.txt 2>/dev/null
  echo '迁移完毕，查看压缩结果请查看/tmp/bakResult.txt'
  echo '迁移完毕,查看结果logs/sync*'
}


function delTmp(){
    rm  -f /tmp/block.txt
    rm  -f /tmp/syncBlk.txt
}

limit=0

if [[ $# > 0 ]]; then
  case "$1" in
  "status" )
    limit=0
    getTfsBlockInfo
    filterInfoToBlkId
  ;;
  "bak" )
    getTfsBlockInfo
    filterInfoToBlkId 
    syncBak
    delTmp
  ;;
  * )
   helpInfo
  ;;
  esac
else 
   helpInfo
fi


