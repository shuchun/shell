# [shell](https://github.com/shuchun/shell)   


> 注意：使用前需要根据自己的tfs服务器部署与配置修改脚本的tfs目录位置以及NS的ip与端口    
命令参数间无先后顺序 

# 说明    
* autoCpTFS.sh   压缩淘宝tfs块空间脚本   
* autoSyncBlk.sh	tfs迁移脚本按块迁移     
* autoSyncFile.sh	tfs迁移脚本按文件迁移    
* downloadFile.sh   批量下载tfs文件到本地    
* AB-TestAuto.sh   ab测试并生成GnuPlot图表    

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


---------------------------------    
**downloadFile**

> 首先需要准备一个文件用于提供批量下载tfs文件的列表和对应的tfs文件下载到本地的文件名，中间用','号分隔
格式如下： 
下载到本地的文件名 ,  tfs服务器上的文件名    
342422199602103914,T1EcKTBCLv1RXrhCrK.jpg    


**AB-TestAuto.sh**    


 命令    |     参数     |     说明        |    示例     
------   |   ----------   |   -------------   |   ----------------------  
-f | -f output.png  |  生成的GnuPlot图表文件名称  |  ```sh ./AB-TestAuto.sh -f output.png```     
-c |  -c num |  ab测试并发数,默认100 |  ```sh ./AB-TestAuto.sh -c 100```       
-C |  -C Cookie |  ab测试cookie,只能设置一组key-value |  ```sh ./AB-TestAuto.sh -C a=b```       
-n   |  -n num  |  ab测试总请求数,默认100   | ```sh ./AB-TestAuto.sh -n 100```   
-t   |  -t title  |  gnuplot生成图表文件的标题   | ```sh ./AB-TestAuto.sh -t title```   
-s   |  -s stepNum  |  ab测试多次循环每次增加量   | ```sh ./AB-TestAuto.sh -s 100```   
-o   |  -o option  |  配置ab测试多次循环每次增加并发还是总请求数，a、n、c   | ```sh ./AB-TestAuto.sh -o a```   
-w   |  -w loopNum  |  ab测试循环次数   | ```sh ./AB-TestAuto.sh -w 3```   
-u   |  -u url  |  ab测试链接路径   | ```sh ./AB-TestAuto.sh -u http://github.com/```   
-p   |  -p postParamFile  |  ab测试post提交的参数文件   | ```sh ./AB-TestAuto.sh -p post.txt```   
-g   |  -g  |  ab测试结束是否使用GnuPlot回执图表   | ```sh ./AB-TestAuto.sh -g```   
-i   |  -i  |  GnuPlot指定ab测试数据文件做为数据文件回执图表   | ```sh ./AB-TestAuto.sh -i test.dat```   

>eg1:   
sh ./AB-TestAuto.sh -n 1000 -c 100 -w 20 -s 10 -o c -t github-index -u http://github.com/ -f github-index.png -C test=test -g  
ab测试http://github.com/路径(-u)，指定100个并发(-c)，总请求1000次(-n)，请求时设置cookie(-C)，
ab测试重复执行20次(-w)，每次并发数(-o c)增加10个(-s)，ab测试结束后绘制图表(-g),
图表标题(-t)为github-index，生成的图表文件(-f)为github-index.png     

>eg2:   
sh ./AB-TestAuto.sh -t github-index_100_1000 -f github-index.png -i ab_1000_100.dat  -g   
使用ab测试数据文件ab_1000_100.dat(-i)做为GnuPlot的数据文件绘制图表(-g),
图表的标题(-t)为github-index,图表文件(-f)为github-index.png





        

