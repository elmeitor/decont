

echo "-------- Starting pipelinePlus at $(date +'%d %h %y, %r')... --------"

#Download all the files specified in data/filenames
#for url in $(<list_of_urls>)
#MEJORA-BONUS Download all the files in one liner
#
outdir  = ~decont/data
urlfile = data/urls 
echo "Download list of urls files."
wget -P $outdir -i urlfile
echo " end download files" 
##
## Incorporado en el scripts principal pipeline.sh -> quitando el bucle de descargas de las urls + cleanup.sh + Pruebas de nuevo
## NOTA: Con esta mejora no descomprimimos los ficheros fasta, se trabaja con muestras comprimidas, por el elevado tamaño de los ficheros.
## 
### MEJORA-BONUS
##
echo "Add md5 checks to the downloaded files (you can find the md5 hashes in the same URLs by adding the .md5 extension"
echo "Full points for not downloading the md5 files."
 
for url in $(cat data/urls)
do 
   curl -sL url | md5sum | cut -d ' ' -f 1 | $outdir/md5
done
## for url in $(cat $file_url)
##    do
##     echo $(curl ${url}.md5 | grep s_sRNA. | cut -d " " -f1)      
##     md5sum -c <(echo $(curl ${url}.md5 | grep s_sRNA. | cut -d " " -f1) $outdir/$(basename $url))
##    done
## $?, el código de salida del pipe más reciente (es decir, de la última vez que se encadenaron varios comandos mediante el carácter pipe que se escribe como |).

    if [ "$?" -ne 0 ] # Exits if md5sum is not ok
    then
        echo "md5sum checked failed" && exit 1
    fi
echo "ended add md5 checks"
echo "-------- Ended pipelinePlus at $(date +'%d %h %y, %r')... --------"

