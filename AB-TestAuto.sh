#!/bin/sh

# 变量定义
method="GET"
title=""
outputFile="ab_test_graph.png"
c=100
n=100
step=50
countNum=1
postParam=""
options="a"
url=""
cookie="a=b"
gnuplotDataFile=()
graph="false"
domain="ab"
lastPath=""
needAb="true"

getDomain(){
  domain=${url#*//}
  lastPath=${domain##*/}
  domain=${domain%.*}
  domain=${domain%.*}

  if [[ $lastPath = "" ]];then
     domain="ab_request_"$domain
  else 
     domain="ab_request_"$domain"-"$lastPath
  fi
}
showEnv(){
 echo "AB test evn:" 
 echo "------------------------------------"
 echo "test url:"$url
 echo "test method:"$method
 echo "test request count:"$n
 echo "test multiple requests count:"$c
 if [ $method = "POST" ];then
   echo "post test param file:"$postParam
 fi
 echo "------------------------------------"
}

#初始化循环测试
startABTest(){
   getDomain
   requestSumaryFile=$domain".out"
   for((i=0;i<$countNum;i++));do
     tmpN=$[ $n+$i*$step ]
     tmpC=$[ $c+$i*$step ]
     if [ $options = "a" ];then
      tmpFileName="ab_"$tmpN"_"$tmpC".dat"
      exec `ab -n $tmpN -c $tmpC -C $cookie -g $tmpFileName $url >> $requestSumaryFile`
     elif [ $options = "n" ];then
      tmpFileName="ab_"$tmpN"_"$c".dat"
      exec `ab -n $tmpN -c $c  -C $cookie -g $tmpFileName $url >> $requestSumaryFile`
     elif [ $options = "c" ];then
      tmpFileName="ab_"$n"_"$tmpC".dat"
      exec `ab -n $n -c $tmpC -C $cookie  -g $tmpFileName $url >> $requestSumaryFile`
     fi
     echo "save gnuplot data file > "$tmpFileName
     gnuplotDataFile[i]=$tmpFileName
   done
   echo "Request Result Summary Log File:"${requestSumaryFile}
}

#graph
graphPlot(){
    gnuPlotShellFile="tmpGnuPlot.sh"
    echo "#!/bin/bash" > ${gnuPlotShellFile}
    echo "set terminal png" >> ${gnuPlotShellFile}
    echo "set title 'ab test ${title}' " >> ${gnuPlotShellFile}
    echo "set output '${outputFile}'" >> ${gnuPlotShellFile}
    echo "set grid y" >> ${gnuPlotShellFile}
    echo "set size 1,0.7" >> ${gnuPlotShellFile}
    echo "set xlabel 'request'" >> ${gnuPlotShellFile}
    echo "set ylabel 'response time (ms)'" >> ${gnuPlotShellFile}
    fileCount=${#gnuplotDataFile[@]}
    index=0;
    plot="plot " 
    for file in "${gnuplotDataFile[@]}";do
        plot=${plot}"'${file}' using 9 smooth sbezier with lines title '${file}'" 
        let ++index
        if [ $index -ne $fileCount ];then
           plot=${plot}","
        fi
    done
    echo ""${plot} >> ${gnuPlotShellFile}
    exec `gnuplot ${gnuPlotShellFile}`
    exec `rm -f ${gnuPlotShellFile}`
}

while getopts "c:f:n:t:s:o:w:p:u:C:i:g" arg
do 
   case $arg in 
	c) #总并发数
          c=$OPTARG
        ;;
        f) #输出文件名
          outputFile=$OPTARG
        ;;
        n) #总请求数
          n=$OPTARG
        ;;
        t) #标题
          title=$OPTARG
        ;;
        s) #增长步长
          step=$OPTARG
        ;;
        o) #增加项 n/c/a  n总连接增加,c总并发增加,a全部增加
          options=$OPTARG
        ;;
        w) #总次数
          countNum=$OPTARG
        ;;
        p) #post 请求参数文件
          postParam=$OPTARG
          method="POST"
        ;;
        u) #ab test url
          url=$OPTARG
        ;;
        C) #ab cookie param
          cookie=$OPTARG
        ;;
        g) #graph
          graph="true"
        ;;
        i) #gnuplot 数据文件
          gnuplotDataFile[0]=$OPTARG
          needAb="false"
        ;;
   esac
done

if [ $needAb = "true" ];then
   showEnv
   startABTest
fi
if [ $graph = "true" ];then
   graphPlot
fi
