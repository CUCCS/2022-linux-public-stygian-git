#!/usr/bin/env bash

#help doc
function help {
    echo "-q Q               对jpeg格式图片进行图片质量因子为Q的压缩"
    echo "-r R               对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩成R分辨率"
    echo "-w font_size text  对图片批量添加自定义文本水印"
    echo "-p text            统一添加文件名前缀，不影响原始文件扩展名"
    echo "-s text            统一添加文件名后缀，不影响原始文件扩展名"
    echo "-t                 将png/svg图片统一转换为jpg格式图片"
    echo "-h                 帮助文档"
}

# 对jpeg格式图片进行图片质量压缩
function QualityCompress {
    Q=$1  
    for i in *;do    # tranverse all files
        type=${i##*.} #delete the last . and characters on the left,get file type
        if [[ ${type} != "jpeg" ]]; then continue; fi;
        convert "${i}" -quality "${Q}" "${i}" 
        echo "${i} is compressed."
    done
}

#对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩分辨率
function CompressResolution {
    R=$1
    for i in *;do
        type=${i##*.}
        if [[ ${type} != "jpeg" && ${type} != "png" && ${type} != "svg" ]]; then continue; fi;
        convert "${i}" -resize "${R}" "${i}" 
        echo "${i} is resized."
    done
}

#对图片批量添加自定义文本水印
function watermarking {
     for i in *;do
        type=${i##*.}
        if [[ ${type} != "jpeg" && ${type} != "png" && ${type} != "svg" ]]; then continue; fi;
        convert "${i}" -pointsize "$1" -fill black -gravity center -draw "text 10,10 '$2'" "${i}"
        echo "${i} is watermarked with $2."
    done
}

#统一添加文件名前缀，不影响原始文件扩展名
function addprefix {
     for i in *;do
        type=${i##*.}
        if [[ ${type} != "jpeg" && ${type} != "png" && ${type} != "svg" ]]; then continue; fi;
        mv "${i}" "$1""${i}"
        echo "${i} is prefixed as $1${i}."
    done
}

#统一添加文件名后缀，不影响原始文件扩展名
function addsuffix {
     for i in *;do
        type=${i##*.}
        if [[ ${type} != "jpeg" && ${type} != "png" && ${type} != "svg" ]]; then continue; fi;
        newname=${i%.*}$1"."${type}
        mv "${i}" "${newname}"
        echo "${i} is sufixed as ${newname}."
    done
}

#将png/svg图片统一转换为jpg格式图片
function transformtojpg {
    for i in *;do
        type=${i##*.}
        if [[ ${type} != "png" && ${type} != "svg" ]]; then continue; fi;
        newtype=${i%.*}".jpg"
        convert "${i}" "${newtype}"
        echo "${i} is transformed to ${newtype}"
    done
}

#使用0命令行参数方式使用不同功能
while [ "$1" != "" ];do
case "$1" in
    "-q")
        QualityCompress "$2"
        exit 0
        ;;
    "-r")
        CompressResolution "$2"
        exit 0
        ;;
    "-w")
        watermarking "$2" "$3"
        exit 0
        ;;
    "-p")
        addprefix "$2"
        exit 0
        ;;
    "-s")
        addsuffix "$2"
        exit 0
        ;;
    "-t")
        transformtojpg
        exit 0
        ;;
    "-h")
        help
        exit 0
        ;;
esac
done
