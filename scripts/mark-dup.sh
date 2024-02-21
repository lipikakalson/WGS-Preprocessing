#!/bin/bash
#SBATCH --job-name='mark-duplicates'
#SBATCH --mail-user=lipika.lipika@medunigraz.at
#SBATCH --partition=cpu
#SBATCH --error=mark-duplicates.e
#SBATCH --output=mark-duplicates.o

# Define the directory containing input files
INPUT_DIR="/home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed"
# Define the output directory
OUTPUT_DIR="/home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed"
TMP_FILE="/home/isilon/patho_anemone-meso/tmp"

# Ensure picard.jar is in the PATH or specify its full path
PICARD_JAR="/home/gpfs/o_lipika/PhD-analysis/picard.jar"

ulimit -c unlimited

# Loop through all files in the directory
for bam_file in "$INPUT_DIR"/*out_sorted_RG.bam; do
  echo "bam file: $bam_file"
  # Extract filename without path and directory part
  filename=$(basename "$bam_file")
  filename1="${bam_file%.bam}"

  mkdir -p "$TMP_FILE/$filename"
  tmp="$TMP_FILE/$filename"


  
  sbatch <<EOF
#!/bin/bash
#SBATCH --job-name=markdup_${filename%.*}
#SBATCH --output=markdup_${filename%.*}.out
#SBATCH --error=markdup_${filename%.*}.err
#SBATCH --partition=cpu
#SBATCH --cpus-per-task=36

java -jar "$PICARD_JAR" UmiAwareMarkDuplicatesWithMateCigar -I "${INPUT_DIR}/${filename}" -O "${filename1}_dedup.bam" -M "${filename1}_duplicate_metrics.txt" -UMI_METRICS "${filename1}_umi_metrics.txt" --BARCODE_TAG BC --TMP_DIR "$tmp" --REMOVE_DUPLICATES true

rm -r "$tmp"
EOF

done

