# [shell](https://github.com/shuchun/shell)   

# 说明    
* autoCpTFS.sh   压缩淘宝tfs块空间脚本   

# 使用    
**autoCpTFS**    

------ | ---------- | ------------- | ----------------------    
 命令  |   参数     |   说明        | 示例     
 status | -l <limitNum>  |  查看tfs块的文件占用情况，limitNum 指定删除文件占用数量过滤条件  |  sh ./autoCpTFS.sh status 或者 sh ./autoCpTFS.sh status -l 500 (删除文件>= 500个的block)     
compact |  -l <limitNum> |  压缩tfs块，limitNum 指定删除文件占用数量过滤条件 |  sh ./autoCpTFS.sh compact 或者 sh ./autoCpTFS.sh compact -l 500 (压缩删除文件>= 500个的block)       
help   |     |   帮助   | sh ./autoCpTFS.sh help 或者 sh ./autoCpTFS.sh -h        

