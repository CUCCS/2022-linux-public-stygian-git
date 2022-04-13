#!/usr/bin/env bash
# help doc
function help {
    echo "-s                 统计不同年龄区间范围(20岁以下、[20-30]、30岁以上)的球员数量、百分比"
    echo "-p                 统计不同场上位置的球员数量、百分比"
    echo "-n                 名字最长的球员是谁？名字最短的球员是谁？"
    echo "-a                 年龄最大的球员是谁？年龄最小的球员是谁？"
    echo "-h                 帮助文档"
}

#统计不同年龄区间范围(20岁以下、[20-30]、30岁以上)的球员数量、百分比
function age_range {
    awk -F "\t" '
        BEGIN {a=0; b=0; c=0;}
        $6!="Age" {
            if($6>=0&&$6<20) {a++;}
            else if($6<=30) {b++;}
            else {c++;}
        }
        END {
            sum=a+b+c;
            printf("Age\tCount\tPercentage\n");
            printf("<20\t%d\t%f%%\n",a,a*100.0/sum);
            printf("[20,30]\t%d\t%f%%\n",b,b*100.0/sum);
            printf(">30\t%d\t%f%%\n",c,c*100.0/sum);
        }' worldcupplayerinfo.tsv
}

# 统计不同场上位置的球员数量、百分比
function position_count {
    awk -F "\t" '
        BEGIN {sum=0}
        $5!="Position" {
            pos[$5]++;
            sum++;
        }
        END {
            printf("    Position\tCount\tPercentage\n");
            for(i in pos) {
                printf("%13s\t%d\t%f%%\n",i,pos[i],pos[i]*100.0/sum);
            }
        }' worldcupplayerinfo.tsv
}

#名字最长的球员是谁？名字最短的球员是谁？
function name_length {
    awk -F "\t" '
        BEGIN {max=-1; min=9999;}
        $9!="Player" {
            len=length($9);
            names[$9]=len;
            max=len>max?len:max;
            min=len<min?len:min;
        }
        END {
            for(i in names) {
                if(names[i]==max) {
                    printf("The longest name is %s.\n", i);
                } else  if(names[i]==min) {
                    printf("The shortest name is %s.\n", i);
                }
            }
        }' worldcupplayerinfo.tsv
}
# 年龄最大的球员是谁？年龄最小的球员是谁？
function age_comparison {
    awk -F "\t" '
        BEGIN {max=-1; min=999;}
        $6!="Age"  {
            age=$6;
            names[$9]=age;
            max=age>max?age:max;
            min=age<min?age:min;
        }
        END {
            printf("The oldest age is %d,the name is\n", max);
            for(i in names) {
                if(names[i]==max) { printf("%s\n", i); }
            }
            printf("The youngest age is %d,the name is\n", min);
            for(i in names) {
                if(names[i]==min) { printf("%s\n", i); }
            }
        }' worldcupplayerinfo.tsv
}

while [ "$1" != "" ];do
    case "$1" in
        "-s")
            age_range
            exit 0
            ;;
        "-p")
            position_count
            exit 0
            ;;
        "-n")
            name_length
            exit 0
            ;;
        "-a")
            age_comparison
            exit 0
            ;;
        "-h")
            help
            exit 0
            ;;
    esac
done