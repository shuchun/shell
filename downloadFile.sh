#!/bin/bash

tfsBase=/usr/local/tfs-2.2.16/
tfsNSIp=127.0.0.1
tfsPort=10001

localFileDir=/var/tfsSync/
downLogDir=/var/tfsSync/log/
#-- download fileName -+----- tfs fileName ----|
#342422199602103914,T1EcKTBCLv1RXrhCrK.jpg

for file in $(cat /var/tfs/tfs.txt);do
  #echo ${file}
  arr[0]=`echo ${file} | cut -d "," -f2`
  arr[1]=`echo ${file} | cut -d "," -f1`
  suffix=`echo ${arr[0]} | awk -F "." '{print("."$NF)}'`  
  arr[1]=${arr[1]}${suffix}

  tname=`echo ${arr[0]} | awk ' gsub(/'"$suffix"'/, ""){print($0)}'`
  #echo ${arr[0]}
  #echo ${arr[1]}
  #tname=`echo ${file} | awk '{gsub(/'"$b"'/,"")}{print($0)}'`
  #echo ${tname}


  #echo '-------------------------------'
  fileStat=`${tfsBase}/bin/tfstool -s $tfsNSIp:$tfsPort -i " stat ${tname} " | grep success `
  #echo ${zip}
  if [[ -n  $fileStat ]];then
     #echo "get file "${arr[0]}
     echo "get file "${file} >> ${downLogDir}/download.log
     eval "${tfsBase}/bin/tfstool -s ${tfsNSIp}:${tfsPort} -i 'get ${tname} ${localFileDir}/${arr[1]}'" 2>/dev/null
  else 
      echo "delete file "${arr[0]}
      echo "delete file "${file}  >> ${downLogDir}/delete_file.log
  fi 
done 2>/dev/null
