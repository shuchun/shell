#!/bin/sh
# ------------------------------------
# -     压缩tfs已删除的文件空间      -
# -     Auth: shuchuneric@163.com    -
# ------------------------------------

#帮助信息
function helpInfo(){
  echo 'Usage: '$0' [status [-l <limitNum> ] ] | [compact [ -l <limitNum> ] ] | [help]'
}

#获取tfs块信息
function getTfsBlockInfo(){

	echo '导出tfs block信息'
	/usr/local/tfs-2.2.16/bin/ssm -s 172.0.0.1:10001 -i 'block ' > /tmp/block.txt
}

#过滤blockid
function filterInfoToBlkId(){

	#
	#   BLOCK_ID   VERSION    FILECOUNT  SIZE           DEL_FILE   DEL_SIZE   SEQ_NO  COPYS
	#     21331   3297          2195  134557684          0          0       3055        2
	echo '信息处理中.....'
	# 去除删除文件少的行
	awk '{if($5 >= '$limit' && $5 != "DEL_FILE"){print$1}}' /tmp/block.txt > /tmp/comBlk.txt 2>/dev/null
	# 获取最后一行
	lastRow=`tail -1 /tmp/comBlk.txt | cut -d ':' -f1`
        if [[ $lastRow == "TOTAL" ]];then
            # 去除最后一行统计行
	    sed -i '/'"$lastRow"'/d' /tmp/comBlk.txt
        fi
	# 去除第一行标题行
	#sed -i '1d' /tmp/comBlk.txt
}

#过滤信息
function filterInfo(){

	#
	#   BLOCK_ID   VERSION    FILECOUNT  SIZE           DEL_FILE   DEL_SIZE   SEQ_NO  COPYS
	#     21331   3297          2195  134557684          0          0       3055        2
	echo '信息处理中.....'
	# 去除删除文件少的行
	awk '{if($5 >= '$limit' && ($5 != "DEL_FILE" || FNR == 1)){print$0}}' /tmp/block.txt > /tmp/comBlk.txt 2>/dev/null
	# 获取最后一行
	lastRow=`tail -1 /tmp/comBlk.txt | cut -d ':' -f1`
        if [[ $lastRow == "TOTAL" ]];then
            # 去除最后一行统计行
	    sed -i '/'"$lastRow"'/d' /tmp/comBlk.txt
        fi
	# 去除第一行标题行
	#sed -i '1d' /tmp/comBlk.txt
        echo '请查看/tmp/comBlk.txt'
}

#压缩
function compact(){

	# 开始清理
	echo '开始压缩tfs'
	for i in $(cat /tmp/comBlk.txt);do eval "/usr/local/tfs-2.2.16/bin/admintool -s 172.0.0.1:10001 -i ' compactblk "$i" '"  >> /tmp/execResult.txt; done 2>/dev/null
        echo '压缩完毕，查看压缩结果请查看/tmp/execResult.txt'
}

#删除中间文件
function delTmp(){
    rm  -f /tmp/block.txt
    rm  -f /tmp/comBlk.txt
}

#删除文件限制数量
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


