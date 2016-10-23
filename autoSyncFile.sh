#!/bin/sh
# ------------------------------------
# -     按文件迁移tfs文件            -
# -     Auth: shuchuneric@163.com    -
# ------------------------------------


#打印帮助信息
function helpInfo(){
  echo 'Usage: '$0' [status | getFile  | bakFile | [help]'
}

#获取tfs  block信息
function getTfsBlockInfo(){

	echo '导出tfs block信息'
	/usr/local/tfs-2.2.16/bin/ssm -s x.x.x.x:port -i 'block ' > /tmp/block.txt
}

#过滤没有文件的未用块
function filterInfoToBlkId(){

	#
	#   BLOCK_ID   VERSION    FILECOUNT  SIZE           DEL_FILE   DEL_SIZE   SEQ_NO  COPYS
	#     21331   3297          2195  134557684          0          0       3055        2
	echo '信息处理中.....'
	# 去除删除文件少的行
	awk '{if($3 >= '$limit' && $3 != "FILECOUNT"){print$1}}' /tmp/block.txt > /tmp/comBlk.txt 2>/dev/null
	# 获取最后一行
	lastRow=`tail -1 /tmp/comBlk.txt | cut -d ':' -f1`
        if [[ $lastRow == "TOTAL" ]];then
            # 去除最后一行统计行
	    sed -i '/'"$lastRow"'/d' /tmp/comBlk.txt
        fi
	# 去除第一行标题行
	#sed -i '1d' /tmp/comBlk.txt
}

#获取指定块的文件列表
function getFileByBlk(){
       	# 开始根据blockId获取文件名列表
	echo '获取tfs fileName'
	for i in $(cat /tmp/comBlk.txt);do 
           eval "/usr/local/tfs-2.2.16/bin/tfstool -s x.x.x.x:port -i ' lsf "$i" '"  > /tmp/tmpFile.txt 2>/dev/null;
           awk '{if($1 !="FileList" && $1 != "Total" && $1 != ""){print $1}}' /tmp/tmpFile.txt >> /tmp/syncFile.txt 2>/dev/null;
        done 2>/dev/null
        echo '文件获取完成/tmp/syncFile.txt'
 
}

#迁移文件
function syncFile(){

	# 开始迁移
	echo '开始迁移tfs'
  eval "/usr/local/tfs-2.2.16/bin/sync_by_file -s x.x.x.x:port -d y.y.y.y:yport  -f /tmp/syncFile.txt -m 20161024 -l info"  >> /tmp/filResult.log 2>/dev/null

  echo '迁移完毕，查看迁移结果请查看/tmp/fileResult.log'
  echo '或者查看bin/log/sync*'
}

#清理临时文件
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


