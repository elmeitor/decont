xecho "-------- Starting pipeline at $(date +'%d %h %y, %r')... --------"

#Download all the files specified in data/filenames
#for url in $(<list_of_urls>) #TODO
echo "Download list of urls files."
##wget -P ~/decont/data -i urls.txt
for url in $(cat data/urls)
do
    bash scripts/download.sh $url data yes
done
echo " end download files"
# exit 1 Pruebas decargas muestras
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
exit 1

# Merge the samples into a single file
#for sid in $(<list_of_sample_ids>) #TODO
#for sid in $(cat basename   ### hacerlo con basename
#for sid in $(ls data/*.fastq.gz | cut -d"-" -f1 | sort )
echo "Merge the samples into a single file."
for sid in $(ls data/*fastq.gz | xargs basename -a | cut -d"-" -f1 | sort -u) 
do
    echo "merge sample $sid files"
    bash scripts/merge_fastqs.sh data out/merged $sid
    echo "end merge $sid"
done
echo "end merge"
###
# TODO: run cutadapt for all merged files
# cutadapt -m 18 -a TGGAATTCTCGGGTGCCAAGG --discard-untrimmed \
#     -o <trimmed_file> <input_file> > <log_file>
######
mkdir -p out/trimmed
mkdir -p log/cutadapt
echo "run cutadapt for all merged files..."
for fname in out/merged/*.fastq.gz
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
echo "Done"

    # TODO: run STAR for all trimmed files pa pruebas
    ####echo "run STAR para alinemiento"
    ####for fname in out/trimmed/*.fastq.gz
    ####do
    # you will need to obtain the sample ID from the filename
    ##sid=#TODO
    ####sid = $(basename $fname .trimmed.fastq.gz)
    ####if [ -e out/star/$sid/ ] # Check output already exists 
    ####then
    ####    echo "$sid already aligned"
    ####    continue        
    ####fi
    ####echo "run STAR para mapear con el contaminante indexado..."
    ####echo "Decontaminating sample $sid..."
    #### mkdir -p out/star/$sid
    ####STAR --runThreadN 4 \ 
    #### --genomeDir res/contaminants_idx \
    #### --outReadsUnmapped Fastx 
    #### --readFilesIn out/trimmed/${sid}.trimmed.fastq.gz \ # <input_file> \
    #### --readFilesCommand zcat    \  #  --readFilesCommand gunzip -c
    #### --outFileNamePrefix out/star/${sid}/      # <output_directory> habría que anteponer prefijo para ficheros de salida? blah_
    ####done
    ####echo "end of STAR of trimed files MAPEO"
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

#### por aqui esta parte me ha dado error....
# TODO: create a log file containing information from cutadapt and star logs
# (this should be a single log file, and information should be *appended* to it on each run)
# - cutadapt: Reads with adapters and total basepairs
# - star: Percentages of uniquely mapped reads, reads mapped to multiple loci, and to too many loci
# tip: use grep to filter the lines you're interested in
echo "create a log file containing information from cutadapt and star logs"
if [ -e Log.out ] # Check output already exists
then
    echo "Log file already exists"
    exit 0
fi
for fname in log/cutadapt/*.log
do
    sid=$(basename $fname .log)
    echo "${sid}" >> Log.out
    ## log de cutadapt para cada muestra tratada
    cat log/cutadapt/${sid}.log | egrep "Reads with |Total basepairs" >> Log.out
    ## log de star para cada muestra mapeada
    cat out/star/${sid}/Log.final.out | egrep "reads %|% of reads mapped to (multiple|too)" >> Log.out
    echo >> Log.out
done
echo "end of log file for cutadapt and star..."

echo "-------- Pipeline finished at $(date +'%d %h %y, %r')... --------

