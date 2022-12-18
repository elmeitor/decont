# This script should download the file specified in the first argument ($1),
# place it in the directory specified in the second argument ($2),
# and *optionally*:
# - uncompress the downloaded file with gunzip if the third
#   argument ($3) contains the word "yes"
# - filter the sequences based on a word contained in their header lines:
#   sequences containing the specified word in their header should be **excluded**
#
# Example of the desired filtering:
#
#   > this is my sequence
#   CACTATGGGAGGACATTATAC
#   > this is my second sequence
#   CACTATGGGAGGGAGAGGAGA
#   > this is another sequence
#   CCAGGATTTACAGACTTTAAA
#
#   If $4 == "another" only the **first two sequence** should be output

# usar el comando wget para descargar varios archivos a la vez
# se crea un documento de texto y ubicamos las URL de descarga allí
# para ello se usa -i para obtener todos los archivos almacenados en  un archivo de texto
# de esta manera me ha descargado todos los ficheros en la carpeta de descarga... 
# ahora con -P le decimos donde queremos dejar los ficheros descargados 
# wget -i urls.txt -> opción sin bucle mejora
###### con esta opcion he descargado las muestras
######wget -P ~/decont/data -i urls.txt
######wget -i $url -p $outdir  #para poder llamarlo genericamente desde pipeline
#  $1  primer argumento fichero a descargar
#  $2  segundo argumento directorio lugar donde se va a realizar la descarga
#  $3  opcion decomprimir  if $3 == 'yes' -> gunzip -k $1...
#  
#### download.sh urls.txt ~/decont/data yes
echo "dentro de download.sh para $url= " $1 " $outdir= " $2 " $comp= " $3 
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
