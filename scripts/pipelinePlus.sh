
echo "-------- Starting pipelinePlus at $(date +'%d %h %y, %r')... --------"

#Download all the files specified in data/filenames
#for url in $(<list_of_urls>)
#MEJORA-BONUS Download all the files in one liner
#
echo "Download list of urls files."
wget -P ~/decont/data -i data/urls
echo " end download files" 
##
## Incorporado en el scripts principal pipeline.sh -> quitando el bucle de descargas de las urls + cleanup.sh + Pruebas de nuevo
## NOTA: Con esta mejora no descomprimimos los ficheros fasta, se trabaja con muestras comprimidas, por el elevado tamaño de los ficheros.
## 
echo "-------- Ended pipelinePlus at $(date +'%d %h %y, %r')... --------"

