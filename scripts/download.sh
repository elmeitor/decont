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
######wget -i $urls -p $outdir sustituiría al bucle en el pipeline
 
#  $1  primer argumento fichero a descargarr#  $2  segundo argumento directorio lugar donde se va a realizar la descarga
#  $3  opcion decomprimir  if $3 == 'yes' -> gunzip -k data/*fastq.gz
#  $4  filtrado de muestras 
#### bash download.sh urls.txt ~/decont/data yes "Small_nuclear"
echo "dentro de download.sh para $url= " $1 " $outdir= " $2 " $desc= " $3  "$filter_samples " $4
url=$1
outdir=$2
desc=$3
##filter_samples=$4
 
 if [ -e $outdir/$(basename $url) ] # Check output already exists obligatorio blancos entre corchetes 
    then
        echo "$outdir/$(basename $url) already exists"
        exit        
 fi
 echo "como no existe fichero en salida run download" $outdir
 echo "descarga del fichero..." $url
 #########   solucion trasladada al pipeline wget -P ~/decont/data -i urls.txt
 ##wget -P ~/decont/data -i $url
 ##wget -nc -P $url $outdir
 wget -q -P $outdir $url  

 if [ "$desc" == "yes" ]
 then
   echo "Uncompressing samples..."
   gunzip -k $outdir/$(basename $url)
   ##mkdir -p data/uncomp
   ##mv data/*.fastq data/uncomp  
 else
   echo "no se solicita la descompresión de los ficheros" $desc
 fi
 echo "fin download.sh"

echo
# apartado $4 
fichero=$(basename $url .gz) 
#Filter small nuclear sequences
if [ ! -z "$4" ] # si no es vacio el $4  
then
echo "dentro de la opción 4 de filtrado"
##Recomendación usar el paquete seqkit de Conda para este filtrado
echo "seqkit grep -vrnp '$4' $outdir/$fichero > $outdir/$fichero.filtered"
seqkit grep -vrnp "$4" $outdir/$fichero > $outdir/$fichero.filtered
fi
echo

