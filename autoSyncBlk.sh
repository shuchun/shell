#!/bin/sh
# ------------------------------------
# -     按块迁移tfs                  -
# -     Auth: shuchuneric@163.com    -
# ------------------------------------

#帮助信息
function helpInfo(){
  echo 'Usage: '$0' [status ] | [bak ] | [help]'
}

#获取block信息
function getTfsBlockInfo(){

	echo '导出tfs block信息'
	/usr/local/tfs-2.2.16/bin/ssm -s x.x.x.x:port -i 'block ' > /tmp/block.txt
}

#过滤没有文件的block
function filterInfoToBlkId(){

	#
	#   BLOCK_ID   VERSION    FILECOUNT  SIZE           DEL_FILE   DEL_SIZE   SEQ_NO  COPYS
	#     21331   3297          2195  134557684          0          0       3055        2
	echo '信息处理中.....'
	# 去除删除文件少的行
	awk '{if($3 > '$limit' && $3 != "FILECOUNT"){print$1}}' /tmp/block.txt > /tmp/syncBlk.txt 2>/dev/null
	# 获取最后一行
	lastRow=`tail -1 /tmp/syncBlk.txt | cut -d ':' -f1`
        if [[ $lastRow == "TOTAL" ]];then
            # 去除最后一行统计行
	    sed -i '/'"$lastRow"'/d' /tmp/syncBlk.txt
        fi
	# 去除第一行标题行
	#sed -i '1d' /tmp/comBlk.txt
}

#开始迁移
function syncBak(){

	# 开始清理
	echo '开始迁移tfs'
        eval "/usr/local/tfs-2.2.16/bin/sync_by_blk -s x.x.x.x:port -d y.y.y.y:yport  -f /tmp/syncBlk.txt"  >> /tmp/bakResult.txt 2>/dev/null
        echo '迁移完毕，查看压缩结果请查看/tmp/bakResult.txt'
        echo '迁移完毕,查看结果logs/sync*'
}

#清理临时文件
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


