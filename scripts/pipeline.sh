
echo "-------- Starting pipeline at $(date +'%d %h %y, %r')... --------"

#Download all the files specified in data/filenames
#for url in $(<list_of_urls>) #TODO
## 
##for url in $(cat data/urls)
##do
##    bash scripts/download.sh $url data yes
##done
## 
## Incorporación de bonus - Descarga de ficheros con unas sola linea -> lo incluimos en un scripts independiente - borrado completo y ejecución de nuevo
#MEJORA-BONUS Download all the files in one liner
#
echo "Download list of urls files."
wget -P data -i data/urls
echo " end download files"
##exit 1 Pruebas decargas muestras mejora de una sola linea ok
# Download the contaminants fasta file, uncompress it, and
# filter to remove all small nuclear RNAs
#bash scripts/download.sh <contaminants_url> res yes #TODO
echo "Download the contaminants fasta file."
bash scripts/download.sh https://bioinformatics.cnio.es/data/courses/decont/contaminants.fasta.gz res yes "small nuclear RNA"
echo " end Download contaminants."

# Index the contaminants file
### probado ok bash scripts/index.sh res/contaminants.fasta res/contaminants_idx
### prueba volvemos a indexar ahora ya el contaminants filtered
echo "Running index the contaminants file."
bash scripts/index.sh res/contaminants.fasta res/contaminants_idx
echo "end STAR index..."
## exit 1 #pruebas hasta contaminante filtrado e indexado ok

# Merge the samples into a single file
#for sid in $(<list_of_sample_ids>) #TODO
#for sid in $(cat basename   ### hacerlo con basename
#for sid in $(ls data/*.fastq.gz | cut -d"-" -f1 | sort )
if [ -d out/merged ] # Revisamos si el directorios del merge ya existe
then
   echo "out/merged ya existe ya realizado el merged"
else            

echo "Merge the samples into a single file."
for sid in $(ls data/*fastq.gz | xargs basename -a | cut -d"-" -f1 | sort -u) 
do
    echo "merge sample $sid files"
    bash scripts/merge_fastqs.sh data out/merged $sid
    echo "end merge $sid"
done
echo "end merge"
fi
echo "prueba de ejecución hasta merged comprobando si ya se ha ejecutado antes ok"
##exit 1 pruebas merged ok
###
# TODO: run cutadapt for all merged files
# cutadapt -m 18 -a TGGAATTCTCGGGTGCCAAGG --discard-untrimmed \
#     -o <trimmed_file> <input_file> > <log_file>
######
if [ -d out/trimmed ] # Revisamos si el directorio del trimmed ya existe
then
   echo "out/trimmed ya existe ya realizado el cutadapt"
else         
	mkdir -p out/trimmed
	mkdir -p log/cutadapt
	echo "run cutadapt for all merged files..."
	for fname in out/merged/*.fastq.gz
	do
    	# basename deja solo el nombre corto y le quita la extensión final si se indica
    	sid=$(basename $fname .fastq.gz)
    	if [ -e out/trimmed/${sid}.trimmed.fastq.gz ] # Check output already exists   
    	then
        	echo "$sid already trimmed"
        continue        
    	fi
    	echo "Trimming sample $sid..."
    	cutadapt \
        	-m 18 \
        	-a TGGAATTCTCGGGTGCCAAGG \
        	--discard-untrimmed \
        	-o out/trimmed/${sid}.trimmed.fastq.gz out/merged/${sid}.fastq.gz \
        	> log/cutadapt/${sid}.log
	done
	echo "Done cutadapt"
fi
##exit 1 prueba hasta el cutadapt comprobando salidas ya existentes ok
# TODO: run STAR alignment
#### --readFilesCommand zcat    \  #  --readFilesCommand gunzip -c
echo 
echo "Running STAR alignment..."
echo
for fname in out/trimmed/*.fastq.gz
do
    sid=$(basename $fname .trimmed.fastq.gz)
    if [ -e out/star/$sid/ ] # Check output already exists
    then
        echo "$sid already aligned"
        continue	
    fi
    echo "Decontaminating sample $sid..."
    mkdir -p out/star/${sid}
    STAR \
        --runThreadN 4 \
        --genomeDir res/contaminants_idx \
        --outReadsUnmapped Fastx  \
        --readFilesIn out/trimmed/${sid}.trimmed.fastq.gz \
        --readFilesCommand gunzip -c  \
        --outFileNamePrefix out/star/${sid}/
done 
echo "end of STAR of trimed files MAPEO"
echo
# TODO: create a log file containing information from cutadapt and star logs
# (this should be a single log file, and information should be *appended* to it on each run)
# - cutadapt: Reads with adapters and total basepairs
# - star: Percentages of uniquely mapped reads, reads mapped to multiple loci, and to too many loci
# tip: use grep to filter the lines you're interested in
echo "create a log file containing information from cutadapt and star logs"
if [ -e pipeline\Log.out ] # Check output already exists
then
    echo "Log file already exists"
    exit 0
fi
for fname in log/cutadapt/*.log
do
    mkdir -p log/pipelineLog
    sid=$(basename $fname .log)
    echo "${sid}" >> log/pipelineLog/Log.out
    ## log de cutadapt para cada muestra tratada
    cat log/cutadapt/${sid}.log | egrep "Reads with |Total basepairs" >> log/pipelineLog/Log.out
    ## log de star para cada muestra mapeada
    cat out/star/${sid}/Log.final.out | egrep "reads %|% of reads mapped to (multiple|too)" >> log/pipelineLog/Log.out
    echo >> log/pipelineLog/Log.out
done
echo "end of log file for cutadapt and star..."

echo "-------- Pipeline finished at $(date +'%d %h %y, %r')..."

