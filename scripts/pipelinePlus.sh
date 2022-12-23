

echo "-------- Starting pipelinePlus at $(date +'%d %h %y, %r')... --------"

#Download all the files specified in data/filenames
#for url in $(<list_of_urls>)
#MEJORA-BONUS Download all the files in one liner
#
outdir  = ~decont/data
urlfile = data/urls 
echo "Download list of urls files."
echo wget -P $outdir -i urlfile
echo " end download files" 
##
## Incorporado en el scripts principal pipeline.sh -> quitando el bucle de descargas de las urls + cleanup.sh + Pruebas de nuevo
## NOTA: Con esta mejora no descomprimimos los ficheros fasta, se trabaja con muestras comprimidas, por el elevado tamaño de los ficheros.
## 
### MEJORA-BONUS
##
echo "Add md5 checks to the downloaded files (you can find the md5 hashes in the same URLs by adding the .md5 extension"
echo "Full points for not downloading the md5 files."
echo "comando md5sum comprobar la integridad de lo que descargas y de archivos que te interese monitorear en su integridad"
echo "md5sum –c md5sum.txt"

 echo " recorremos los ficheros descargados"
## md5sum data/C57BL_6NJ-12.5dpp.1.1s_sRNA.fastq.gz >> data/md5
## md5sum data/C57BL_6NJ-12.5dpp.1.2s_sRNA.fastq.gz >> data/md5
## md5sum data/SPRET_EiJ-12.5dpp.1.1s_sRNA.fastq.gz >> data/md5
## md5sum data/SPRET_EiJ-12.5dpp.1.2s_sRNA.fastq.gz >> data/md5
## data/md5 tiene los hash de los cuatro ficheros
##676195704ac6be35876498b013a44217  C57BL_6NJ-12.5dpp.1.1s_sRNA.fastq.gz
##593f1bf4abb267f943a55800f66d8e0c  C57BL_6NJ-12.5dpp.1.2s_sRNA.fastq.gz
##f969082a9bcd9bb6fb77cf2adf3d73e1  SPRET_EiJ-12.5dpp.1.1s_sRNA.fastq.gz
##28ed81f017f637dfdfce601cdaa4e762  SPRET_EiJ-12.5dpp.1.2s_sRNA.fastq.gz
##
for file_url in data/*.fastq.gz
do
   md5sum $file_url >> md5check.txt
done
for file_url in $(cat data/urls)
do
  
   curl -s $file_url.md5 | cut -d" " -f1 >> md5curl.txt
done
cat md5check.txt | cut -d" " -f1 > md5chekcut.txt
diff md5curl.txt md5chekcut.txt
exitstatusdiff=$(echo $?)
if [ $exitstatusdiff -ne 0 ] 
then
   echo "Warning: MD5 checks of fastq files failed ..."
fi 
## $?, el código de salida del pipe más reciente (es decir, de la última vez que se encadenaron varios comandos mediante el carácter pipe que se escribe como |).
echo
md5sum res/contaminants.fasta.gz | cut -d" " -f1 > md5file1.txt
curl -s "https://bioinformatics.cnio.es/data/courses/decont/contaminants.fasta.gz.md5" | cut -d" " -f1 > md5file2.txt
diff md5file1.txt md5file2.txt
salidadiff=$(echo $?)
if [ $salidadiff -ne 0 ]
then
   echo "Warning: MD5 checks of contaminants.fasta.gz failed ..."
fi
echo "ended add md5 checks"
echo "-------- Ended pipelinePlus at $(date +'%d %h %y, %r')... --------"

