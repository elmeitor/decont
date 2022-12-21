echo "-------- Starting pipeline at $(date +'%d %h %y, %r')... --------"

#Download all the files specified in data/filenames
#for url in $(<list_of_urls>) #MEJORA Download all the files in one liner
#para ello en la misma carpeta muevo el fichero con las urls 
echo "Download list of urls files."
wget -P ~/decont/data -i urls.txt
echo " end download files" 
