#!/bin/bash
#SBATCH --job-name='demux'
#SBATCH --mail-user=lipika.lipika@medunigraz.at
#SBATCH --partition=cpu
#SBATCH --error=demux/error-demux.e
#SBATCH --output=demux/output-demux.o


# Define the directory containing input files
INPUT_DIR="/home/isilon/patho_anemone-meso/fastq/fq-files/"
# Define the directory to save trimmed files
OUTPUT_DIR="/home/isilon/patho_anemone-meso/fastq/fq-split"

ulimit -c unlimited

# Loop through all files in the directory
for file1 in "$INPUT_DIR"*.fastq.gz; do
  # Extract filename without path and directory part
  # Replace _R1 with _R2 to get R2 filename using sed
  filename1="${file1##*/}"
  sample_name1=$(basename "$filename1" .fastq.gz)
  dir_part="${file1%/*}"
  echo $file1
  
  # Replace _R1 with _R2 to get R2 filename
  filename2=$(echo "$filename1" | sed 's/R1/R2/g')
  sample_name2=$(basename "$filename2" .fastq.gz)

  r2_file="$dir_part/$filename2"
  echo "$r2_file"
  
  sbatch <<EOF
#!/bin/bash
#SBATCH --job-name=demux_${sample_name1}
#SBATCH --output=demux/output-demux_$sample_name1}.o
#SBATCH --error=demux/error-demux_${sample_name1}.e
#SBATCH --partition=cpu
#SBATCH --cpus-per-task=12


zcat $file1 | /home/gpfs/o_lipika/PhD-analysis/fastq-split/fastqSplit -k 3 -p -prefix ${sample_name1}. &
zcat $r2_file | /home/gpfs/o_lipika/PhD-analysis/fastq-split/fastqSplit -k 3 -p -prefix ${sample_name2}. &

wait



EOF
done
