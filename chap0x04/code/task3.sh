#!/usr/bin/env bash
# help doc
function help {
    echo "-o      统计访问来源主机TOP 100和分别对应出现的总次数"
    echo "-i      统计访问来源主机TOP 100 IP和分别对应出现的总次数"
    echo "-u      统计最频繁被访问的URL TOP 100"
    echo "-c      统计不同响应状态码的出现次数和对应百分比"
    echo "-f      分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数"
    echo "-g URL  给定URL输出TOP 100访问来源主机"
    echo "-h      帮助文档"
}

# 统计访问来源主机TOP 100和分别对应出现的总次数
function Top100_hostcount {
    printf "%40s\t%s\n" "TOP100_host" "count"
    awk -F "\t" '
    NR>1 {host[$1]++;}
    END { for(i in host) {printf("%40s\t%d\n",i,host[i]);} }
    ' web_log.tsv | sort -g -k 2 -r | head -100
}

# 统计访问来源主机TOP 100 IP和分别对应出现的总次数
function Top100_IPcount {
    printf "%20s\t%s\n" "TOP100_IP" "count"
    awk -F "\t" '
    NR>1 {if(match($1, /^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$/)) ip[$1]++;}
    END { for(i in ip) {printf("%20s\t%d\n",i,ip[i]);} }
    ' web_log.tsv | sort -g -k 2 -r | head -100
}

# 统计最频繁被访问的URL TOP 100
function Top100_URLcount {
    printf "%55s\t%s\n" "TOP100_URL" "count"
    awk -F "\t" '
    NR>1 {url[$5]++;}
    END { for(i in url) {printf("%55s\t%d\n",i,url[i]);} }
    ' web_log.tsv | sort -g -k 2 -r | head -100
}

# 统计不同响应状态码的出现次数和对应百分比
function StateCode {
    awk -F "\t" '
    BEGIN {printf("code\tcount\tpercentage\n");}
    NR>1 {code[$6]++;}
    END { for(i in code) {printf("%d\t%d\t%f%%\n",i,code[i],100.0*code[i]/(NR-1));} }
    ' web_log.tsv
}

# 分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数
function StateCode4xx {
    printf "%55s\t%s\n" "code=403 URL" "count"
    awk -F "\t" '
    NR>1 { if($6=="403") code[$5]++;}
    END { for(i in code) {printf("%55s\t%d\n",i,code[i]);} }
    ' web_log.tsv | sort -g -k 2 -r | head -10

    printf "%55s\t%s\n" "code=404 URL" "count"
    awk -F "\t" '
    NR>1 { if($6=="404") code[$5]++;}
    END { for(i in code) {printf("%55s\t%d\n",i,code[i]);;} }
    ' web_log.tsv | sort -g -k 2 -r | head -10
}

# 给定URL输出TOP 100访问来源主机
function Top100_URL_host {
    printf "%40s\t%s\n" "TOP100_host" "count"
    awk -F "\t" '
    NR>1 {if("'"$1"'"==$5) {host[$1]++;} }
    END { for(i in host) {printf("%40s\t%d\n",i,host[i]);} }
    ' web_log.tsv | sort -g -k 2 -r | head -100
}


while [ "$1" != "" ];do
    case "$1" in
       "-o")
      Top100_hostcount
      exit 0
      ;;
       "-i")
      Top100_IPcount
      exit 0
      ;;
       "-u")
      Top100_URLcount
      exit 0
      ;;
       "-c")
      StateCode
      exit 0
      ;; 
       "-f")
      StateCode4xx
      exit 0
      ;;
       "-g")
      Top100_URL_host "$2"
      exit 0
      ;;
       "-h")
      help
      exit 0
      ;;
    esac
done