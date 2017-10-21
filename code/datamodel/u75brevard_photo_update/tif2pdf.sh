#!/bin/bash
sourcedir="/home/pgoldtho/work/brevard_tif"
mergedir="/home/pgoldtho/work/brevard_pdf/merge"
destdir="/home/pgoldtho/work/brevard_pdf"
cd "$sourcedir"
for i in *; do
  echo "Processing $i"
  cd "$i"
  f1="1"
  f2=""
  str=""
  c=0
  for f in *; do
 
    f2=`echo "$f"|sed 's/_[0-9][0-9][0-9].tif//'`
    c=$((c+1))
    if test $f2 != $f1; then
      if [ "$c" -gt 1 ]; then
        tiffcp $str "$mergedir"/"$f1".tif
        tiff2pdf -o $destdir/"$i"/"$f1".pdf $mergedir/"$f1".tif
        echo "$f1, /$i/$f1.pdf" >> "$destdir"/brevard_files.csv
      else
        if [ "$f1" -ne 1 ]; then
          str=`echo "$str"|sed 's/ //'`
          tiff2pdf -o $destdir/"$i"/"$f1".pdf "$str"
          echo "$f1, /$i/$f1.pdf" >> "$destdir"/brevard_files.csv
        fi
      fi
      str=""
      c=0
    fi
    str=`echo "$str $sourcedir/$i/$f"`
    f1=`echo "$f2"`
 
  done
  cd "$sourcedir"
done