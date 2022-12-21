
echo "dentro de download2.sh para $url= " $1 " $outdir= " $2 " $comp= " $3 
 if [-e $2 ] # Check output already exists 
    then
        echo "$2 already exists"
        exit        
 fi
 echo "como no existe salida run download"
 wget -i $1 -p $2 $3
 if [$3 eq 'yes']
 then
   gunzip -k $2/$(basename $1) ##$out_dir/$(basename $file_url)
 
 else
   echo "no se solicita la descompresión de los ficheros"
 fi
 echo "fin download.sh"

echo

