# This script should merge all files from a given sample (the sample id is
# provided in the third argument ($3)) into a single file, which should be
# stored in the output directory specified by the second argument ($2).
#
# The directory containing the samples is indicated by the first argument ($1).
echo "Script que fusiona las muestras"
echo "Directorio donde están las muestras sampledir= " $1
echo "Directorio salida del merge outdir= " $2
echo "Identificación de la muestra sampleid = " $3

indir=$1
outdir=$2
sampleid=$3

if [ -e $outdir/${sampleid}.fastq.gz ] # Check if output already exists
then
    echo "Merged $sampleid file already exists"
    exit 0	
fi

mkdir -p $outdir
cat $indir/${sampleid}*.fastq.gz > $outdir/${sampleid}.fastq.gz
