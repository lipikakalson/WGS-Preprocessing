#!/bin/sh
#SBATCH --job-name='cram2fq'
#SBATCH --cpus-per-task=40
#SBATCH --mem=512GB
#SBATCH --mail-user=lipika.lipika@medunigraz.at
#SBATCH --partition=cpu
#SBATCH --cpus-per-task=24
#SBATCH --error=error-cram2fq.e
#SBATCH --output=output-cram2fq.o

squeue -u 'o_lipika'

reference="/home/isilon/users/o_lipika/FFPE-WGS-samples/BAM/data/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna"
output_folder="fastq"

mkdir -p "$output_folder"

for cram_file in *.cram; do
    echo "Processing $cram_file"
    # Extract the sample name without the file extension
    sample_name=$(basename "$cram_file" .cram)

    # Run samtools fastq for each CRAM file
    samtools -@24 fastq --reference "$reference" -1 "$output_folder/${sample_name}_out.R1.fastq" -2 "$output_folder/${sample_name}_out.R2.fastq" "$cram_file"
    
    echo "Conversion completed for $cram_file"
done
