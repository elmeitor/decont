# This script should index the genome file specified in the first argument ($1),
# creating the index in a directory specified by the second argument ($2).

# The STAR command is provided for you. You should replace the parts surrounded
# by "<>" and uncomment it.

# STAR --runThreadN 4 --runMode genomeGenerate --genomeDir <outdir> \
# --genomeFastaFiles <genomefile> --genomeSAindexNbases 9

# <outdit> = res/contaminants_idx = $2
# <genomefile> = res/contaminants.fasta = $1

echo "Running STAR index para fasta indicado en $1= " $1
##mkdir -p res/contaminants_idx
##STAR --runThreadN 4 --runMode genomeGenerate --genomeDir res/contaminants_idx/ --genomeFastaFiles res/contaminants.fasta --genomeSAindexNbases 9

if [ -e res/contaminants_idx/SAindex ] # Revisamos si el indice ya existe
then
   echo "res/contaminants_idx ya existe contaminante ya indexado"
else           	
echo  "creamos un directorio para el contaminants indexado en $2= " $2
## opcion -p si no existe lo crea sino no hace nada, pero no daría error en sucesivas ejecuciones
mkdir -p $2
STAR --runThreadN 4 --runMode genomeGenerate --genomeDir $2 --genomeFastaFiles $1 --genomeSAindexNbases 9
fi;
echo " final STAR index"
