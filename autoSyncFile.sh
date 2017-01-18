#!/bin/sh
# ------------------------------------
# -     Sync by filename             -
# -     Auth: shuchuneric@163.com    -
# ------------------------------------

tfsBase=/usr/local/tfs-2.2.16/
tfsNSIp=127.0.0.1
tfsPort=10001

tfsDistNSIp=127.0.0.1
tfsDistPort=10001

#help info
function helpInfo(){
  echo 'Usage: '$0' [status | getFile  | bakFile | [help]'
}

#get tfs  block info
function getTfsBlockInfo(){

	echo '导出tfs block信息'
	${tfsBase}/bin/ssm -s ${tfsNSIp}:${tfsPort} -i 'block ' > /tmp/block.txt
}

#filter unused block
function filterInfoToBlkId(){

	#
	#   BLOCK_ID   VERSION    FILECOUNT  SIZE           DEL_FILE   DEL_SIZE   SEQ_NO  COPYS
	#     21331   3297          2195  134557684          0          0       3055        2
	echo '信息处理中.....'
	# 
	awk '{if($3 >= '$limit' && $3 != "FILECOUNT"){print$1}}' /tmp/block.txt > /tmp/comBlk.txt 2>/dev/null
	# 
	lastRow=`tail -1 /tmp/comBlk.txt | cut -d ':' -f1`
        if [[ $lastRow == "TOTAL" ]];then
            # delete total line
	    sed -i '/'"$lastRow"'/d' /tmp/comBlk.txt
        fi
	# delete title line
	#sed -i '1d' /tmp/comBlk.txt
}

#get spec block info
function getFileByBlk(){
  # get file list
	echo '获取tfs fileName'
	for i in $(cat /tmp/comBlk.txt);do 
     eval "${tfsBase}/bin/tfstool -s ${tfsNSIp}:${tfsPort} -i ' lsf "$i" '"  > /tmp/tmpFile.txt 2>/dev/null;
     awk '{if($1 !="FileList" && $1 != "Total" && $1 != ""){print $1}}' /tmp/tmpFile.txt >> /tmp/syncFile.txt 2>/dev/null;
  done 2>/dev/null
  echo '文件获取完成/tmp/syncFile.txt'
 
}

# begin sync
function syncFile(){

	echo '开始迁移tfs'
  eval "${tfsBase}/bin/sync_by_file -s ${tfsNSIp}:${tfsPort} -d ${tfsDistNSIp}:${tfsDistPort}  -f /tmp/syncFile.txt -m 20161024 -l info"  >> /tmp/filResult.log 2>/dev/null

  echo '迁移完毕，查看迁移结果请查看/tmp/fileResult.log'
  echo '或者查看bin/log/sync*'
}

# clear tmp file
function delTmp(){
    rm  -f /tmp/block.txt
    rm  -f /tmp/comBlk.txt
    rm  -f /tmp/tmpFile.txt
    rm  -f /tmp/syncFile.txt
}

limit=1

if [[ $# > 0 ]]; then
  case "$1" in
  "status" )
    if [[ $# == 3 && $2 == "-l" ]]; then
       limit=$3 
    fi

    getTfsBlockInfo
    filterInfoToBlkId
  ;;
  "getFile" )
   getTfsBlockInfo
   filterInfoToBlkId
   getFileByBlk
  ;;
  "bakFile" )
    getTfsBlockInfo
    filterInfoToBlkId
    getFileByBlk
    syncFile
    delTmp
  ;;
  * )
   helpInfo
  ;;
  esac
else 
   helpInfo
fi


