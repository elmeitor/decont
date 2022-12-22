##Add a "cleanup.sh" script that removes created files.
## It should take zero or more of the following arguments: "data", "resources", "output", "logs".
## If no argumAdd a "cleanup.sh" script that removes created files.
## It should take zero or more of the following arguments: "data", "resources", "output", "logs".
## If no arguments are passed then it should remove everything.
##
## En esta primera versión de cleanup las entradas esperadas son:
##opc1: bash scripts/cleanup.sh  -> sin parametros borra todo 
##opc2: bash scripts/cleanup.sh data noresources nooutput nologs -> borra data
##opc3: bash scripts/cleanup.sh nodata resources nooutput nologs -> borra resouces 
##opc4: bash scripts/cleanup.sh nodata noresources output nologs -> borra output 
##opc5: bash scripts/cleanup.sh nodata noresources nooutput logs -> borra logs
##
## prueba 1: con echo ok
##
## prueba 2: opc5 sin echo y vuelta a ejecutar el pipeline.sh ok En esta prueba al borrar todos los log, borra log cutadapt y salen a medias
##
## prueba 3: opc4 sin echo + opc5 sin echo y vuelta a ejecutar el pipeline.sh ok En esta prueba al borrar output, se borran out.merged out.star out.trimmed.
##
## prueba 4: opc3 sin echo + opc4 + opc5  y vuelta a ejecutar el pipeline.sh
## 
## prueba 5: opc2 sin echo + opc3 + opc4 + opc5 , equivalente a sin parametros ya que borraría todo y vuelta a ejecutar el pipeline.sh desde el inicio 
##
## prueba 6: opc1 sin echo -> borrado de todos los ficheros creados -> ejecución de todo pipeline.sh PRUEBATOTAL!
##
##$1 = "data"
##$2 = "resources"
##$3 = "output"
##$4 = "logs"
if [ "$#" == 0 ] # should remove everything
then
  echo "no hay argumento debe borrar todo $#"
  rm -rf data/*.fastq data/*.fastq.gz ## borraría los ficheros de muestra descargados y sus descomprimidos 
  rm -rf res/contaminants*            ## borraría resultado descarga y del index del contaminante
  rm -rf log/*                        ## borraría log/cutadapt log/pipelineLog
  rm -rf out/*                        ## borraría out/merged out/star out/trimmed
else
 if [ $1 == "data" ]
 then
    echo "borramos el fichero data que contiene las descargas de las muestras de RNA"
    rm -rf data/*.fastq data/*.fastq.gz
    echo " fin del borrado directorio data"
 fi;
 if [ $2 == "resources" ]
 then 
    echo "borramos el fichero resources que contiene las descargas de las muestras de RNA"
    rm -rf res/contaminants*
    echo " fin del borrado directorio res" 
 fi;
 if [ $3 == "output" ]
 then 
   echo "borramos el fichero output que contiene las descargas de las muestras de RNA"
   rm -rf out/*
   echo " fin del borrado directorio out" 
 fi;
 if [ $4 == "logs" ]
 then 
   echo "borramos el fichero logs que contiene las descargas de las muestras de RNA"
   rm -rf log/*
   echo " fin del borrado directorio logs" 
 fi;
fi;
echo "fin del cleanup.sh" 


    
