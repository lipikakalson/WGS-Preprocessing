#!/bin/bash
#SBATCH --job-name='trimmer'
#SBATCH --mail-user=lipika.lipika@medunigraz.at
#SBATCH --partition=cpu
#SBATCH --error=trimmer/error-trimmer.e
#SBATCH --output=trimmer/output-trimmer.o


# Define the directory containing input files
INPUT_DIR="/home/isilon/patho_anemone-meso/fastq/fq-split/"
# Define the directory to save trimmed files
OUTPUT_DIR="/home/isilon/patho_anemone-meso/fastq/trimmed"

# Loop through all files in the directory
for file1 in "$INPUT_DIR"*.R1.*fastq.gz; do
  # Extract filename without path and directory part
  # Replace _R1 with _R2 to get R2 filename using sed
  filename1="${file1##*/}"
  dir_part="${file1%/*}"
  echo $file1
  
  # Replace _R1 with _R2 to get R2 filename
  filename2=$(echo "$filename1" | sed 's/R1/R2/g')

  r2_file="$dir_part/$filename2"
  echo "$r2_file"
  
  sbatch <<EOF
#!/bin/bash
#SBATCH --job-name=trim_${filename1}
#SBATCH --output=trimmer/output-trim_${filename1}.o
#SBATCH --error=trimmer/error-trim_${filename1}.e
#SBATCH --partition=cpu
#SBATCH --cpus-per-task=12

java -Djava.io.tmpdir="$TEMPDIR" -Dsamjdk.threads=12 -jar /home/gpfs/o_lipika/PhD-analysis/agent/lib/trimmer-3.0.5.jar \
    -fq1 $file1 \
    -fq2 $r2_file \
    -v2 \
    -out_loc $OUTPUT_DIR

EOF
done
