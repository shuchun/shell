# [shell](https://github.com/shuchun/shell)   

# 说明    
* autoCpTFS.sh   压缩淘宝tfs块空间脚本   
* autoSyncBlk.sh	tfs迁移脚本按块迁移     
* autoSyncFile.sh	tfs迁移脚本按文件迁移    

# 使用    
**autoCpTFS**    



  
 命令    |     参数     |     说明        |    示例     
------   |   ----------   |   -------------   |   ----------------------  
status | -l <limitNum>  |  查看tfs块的文件占用情况，limitNum 指定删除文件占用数量过滤条件  |  ```sh ./autoCpTFS.sh status``` 或者 ```sh ./autoCpTFS.sh status -l 500``` (删除文件>= 500个的block)     
compact |  -l <limitNum> |  压缩tfs块，limitNum 指定删除文件占用数量过滤条件 |  ```sh ./autoCpTFS.sh compact``` 或者 ```sh ./autoCpTFS.sh compact -l 500``` (压缩删除文件>= 500个的block)       
help   |     |   帮助   | ```sh ./autoCpTFS.sh help``` 或者 ```sh ./autoCpTFS.sh -h ```   

----------------------------------     
**autoSyncBlk**    


 命令    |     参数     |     说明        |    示例     
------   |   ----------   |   -------------   |   ----------------------  
status   |  无          |    查看tfs块的文件占用情况   |   ```sh ./autoSyncBlk.sh status```     
bak      |  无          |    开始按块迁移      |   ```sh ./autoSyncBlk.sh  bak```     
help     |              |   帮助              |   ```sh autoSyncBlk.sh  help```     

----------------------------------      
**autoSyncFile**

 命令    |     参数     |     说明        |    示例     
------   |   ----------   |   -------------   |   ----------------------  
status   |  无          |    查看tfs块的文件占用情况   |   ```sh ./autoSyncFile.sh status```     
getFile      |  无          |    获取所有的tfs文件名      |   ```sh ./autoSyncFile.sh  bak```     
bakFile      |  无          |    开始迁移      |   ```sh ./autoSyncFile.sh  bak```     
help     |              |   帮助              |   ```sh autoSyncFile.sh  help```   






> 注意：使用前需要根据自己的tfs服务器部署与配置修改脚本的tfs目录位置以及NS的ip与端口    
命令参数间无先后顺序         

