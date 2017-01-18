#!/bin/sh
# ------------------------------------
# -     Compact tfs space		     -
# -     Auth: shuchuneric@163.com    -
# ------------------------------------

tfsBase=/u03/taobao/tfs_2.2.16/
tfsNSIp=127.0.0.1
tfsPort=10001

#help info
function helpInfo(){
  echo 'Usage: '$0' [status [-l <limitNum> ] ] | [compact [ -l <limitNum> ] ] | [help]'
}

#get tfs block info
function getTfsBlockInfo(){

	echo '导出tfs block信息'
	${tfsBase}/bin/ssm -s ${tfsNSIp}:${tfsPort} -i 'block ' > /tmp/block.txt
}

#filter blockid
function filterInfoToBlkId(){

	#
	#   BLOCK_ID   VERSION    FILECOUNT  SIZE           DEL_FILE   DEL_SIZE   SEQ_NO  COPYS
	#     21331   3297          2195  134557684          0          0       3055        2
	echo '信息处理中.....'
	# filter delete file  
	awk '{if($5 >= '$limit' && $5 != "DEL_FILE"){print$1}}' /tmp/block.txt > /tmp/comBlk.txt 2>/dev/null
	# filter last line
	lastRow=`tail -1 /tmp/comBlk.txt | cut -d ':' -f1`
        if [[ $lastRow == "TOTAL" ]];then
            # delete summary line 
	    sed -i '/'"$lastRow"'/d' /tmp/comBlk.txt
        fi
	# delete title line
	#sed -i '1d' /tmp/comBlk.txt
}

#filter line
function filterInfo(){

	#
	#   BLOCK_ID   VERSION    FILECOUNT  SIZE           DEL_FILE   DEL_SIZE   SEQ_NO  COPYS
	#     21331   3297          2195  134557684          0          0       3055        2
	echo '信息处理中.....'

	awk '{if($5 >= '$limit' && ($5 != "DEL_FILE" || FNR == 1)){print$0}}' /tmp/block.txt > /tmp/comBlk.txt 2>/dev/null
	# filter delete file  
	lastRow=`tail -1 /tmp/comBlk.txt | cut -d ':' -f1`
    if [[ $lastRow == "TOTAL" ]];then
        # delete total line
    sed -i '/'"$lastRow"'/d' /tmp/comBlk.txt
    fi
	# delete title line
	#sed -i '1d' /tmp/comBlk.txt
    echo '请查看/tmp/comBlk.txt'
}

# compact
function compact(){

	# begin compact
	echo '开始压缩tfs'
	for i in $(cat /tmp/comBlk.txt);do 
		eval "${tfsBase}/bin/admintool -s ${tfsNSIp}:${tfsPort} -i ' compactblk "$i" '"  >> /tmp/execResult.txt; 
	done 2>/dev/null
    echo '压缩完毕，查看压缩结果请查看/tmp/execResult.txt'
}

# delete tmp file
function delTmp(){
    rm  -f /tmp/block.txt
    rm  -f /tmp/comBlk.txt
}

# default unlimit
limit=0

if [[ $# > 0 ]]; then
  case "$1" in
  "status" )
    if [[ $# == 3 && $2 == "-l" ]]; then
       limit=$3 
    fi

    getTfsBlockInfo
    filterInfo
  ;;
  "compact" )
    if [[ $# == 3 && $2 == "-l" ]]; then
       limit=$3 
    fi
    getTfsBlockInfo
    filterInfoToBlkId 
    compact
    delTmp
  ;;
  * )
   helpInfo
  ;;
  esac
else 
   helpInfo
fi


