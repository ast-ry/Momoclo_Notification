#!/bin/sh

echo "更新チェック開始"

### 更新対象URLおよびwget後のファイル名を定義 ###
title1='ももクロ_オフィシャル'
url1='http://www.momoclo.net/'
url_1='http://www.momoclo.net/'
f1='momoclo'

title2='ビリビリ everyday'
url2='http://feedblog.ameba.jp/rss/ameblo/takagi-sd'
url_2='http://ameblo.jp/takagi-sd/'
f2='reni'

title3='でこちゃん日記'
url3='http://feedblog.ameba.jp/rss/ameblo/momota-sd'
url_3='http://ameblo.jp/momota-sd/'
f3='kanako'

title4='ももパワー充電所'
url4='http://feedblog.ameba.jp/rss/ameblo/ariyasu-sd'
url_4='http://ameblo.jp/ariyasu-sd/'
f4='momoka'

title5='楽しおりん生活'
url5='http://feedblog.ameba.jp/rss/ameblo/tamai-sd'
url_5='http://ameblo.jp/tamai-sd/'
f5='shiori'

title6='あーりんのほっぺ'
url6='http://feedblog.ameba.jp/rss/ameblo/sasaki-sd'
url_6='http://ameblo.jp/sasaki-sd/'
f6='ayaka'

dir='index3'

#### 作業ディレクトリに移動.存在しなければ新たに作成 ###
if [ -d $dir ];then
  cd $dir
  echo "  $dirに移動します"
else
  mkdir $dir
  echo "  $dirを作成します"
  cd $dir
  echo "  $dirに移動します"
fi

### 更新チェック開始  ###
while true;do
  if [ -e $f1 ];then
    while true;do
      for i in 1 2 3 4 5 6;do
        url=`eval echo '$url'$i`
        filename=`eval echo '$f'$i`
        title=`eval echo '$title'$i`
        url_=`eval echo '$url_'$i`
	# DLしたファイルのサイズを取得
        size=`wc -c < $filename`
        f_size=`expr $size`
	# 各ファイルのmd5ハッシュ値をチェック
        md5sum $filename > md5_$i.out
        wget -O $filename $url 1>/dev/null 2>/dev/null
        c=`md5sum -c md5_$i.out 2>/dev/null`
	# ファイルサイズが500Byte以上およびmd5チェックによる差分が
	# 確認できた場合に更新ありとしてtweet
        if [ $f_size -ge 500 ];then
          if [ "$filename: FAILED" = "$c" ];then
	    echo "[$title] `date +%X` 更新あり $url_ #momoclo" | tw --pipe
          fi
        fi
      done
      sleep 300
    done
  else
    for i in 1 2 3 4 5 6;do
      eval wget -O \$f$i \$url$i 1>/dev/null 2>/dev/null
    done
  fi
  sleep 300
done
