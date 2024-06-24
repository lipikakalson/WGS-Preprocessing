#!/bin/bash
#SBATCH --job-name='mark-duplicates'
#SBATCH --mail-user=lipika.lipika@medunigraz.at
#SBATCH --partition=cpu
#SBATCH --error=markdup/mark-duplicates.e
#SBATCH --output=markdup/mark-duplicates.o

# Define the directory containing input files
INPUT_DIR="/home/isilon/patho_anemone-meso/fastq/merged/batch2"
# Define the output directory
OUTPUT_DIR="/home/isilon/patho_anemone-meso/fastq/dedup"
TMP_FILE="/home/isilon/patho_anemone-meso/tmp"

# Ensure picard.jar is in the PATH or specify its full path
PICARD_JAR="/home/gpfs/o_lipika/PhD-analysis/picard.jar"

ulimit -c unlimited

# Loop through all files in the directory
for bam_file in "$INPUT_DIR"/*merged.bam; do
  echo "bam file: $bam_file"
  # Extract filename without path and directory part
  filename=$(basename "$bam_file")
  filename1="${bam_file%.bam}"

  #mkdir -p "$TMP_FILE/$filename"
  #tmp="$TMP_FILE/$filename"


  
  sbatch <<EOF
#!/bin/bash
#SBATCH --job-name=markdup_${filename%.*}
#SBATCH --output=markdup/markdup_${filename%.*}.out
#SBATCH --error=markdup/markdup_${filename%.*}.err
#SBATCH --partition=cpu
#SBATCH --cpus-per-task=24

java -Djava.io.tmpdir="$TEMPDIR" -Dsamjdk.threads=24 -jar "$PICARD_JAR" MarkDuplicates -I "${INPUT_DIR}/${filename}" -O "${filename1}_dedup.bam" -M "${filename1}_duplicate_metrics.txt" --BARCODE_TAG RX --TMP_DIR $TEMP

#java -jar "$PICARD_JAR" MarkDuplicates -I /home/isilon/patho_anemone-meso/fastq/merged/batch1/D6039-9__D6039-9_S3_230904_A01664_0191_BHKW72DSX7_merged.bam -O /home/isilon/patho_anemone-meso/fastq/merged/batch1/D6039-9__D6039-9_S3_230904_A01664_0191_BHKW72DSX7_merged_dedup_markduplicates.bam  --BARCODE_TAG RX -M D6039-9_output_duplicate_metrics_md.txt  --TMP_DIR /home/isilon/patho_anemone-meso/tmp/D6039-9__tmp_md

rm -r "$tmp"
EOF

done

