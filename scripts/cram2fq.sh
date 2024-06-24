#!/bin/sh
#SBATCH --job-name='cram2fq'
#SBATCH --cpus-per-task=24
#SBATCH --mem=256GB
#SBATCH --mail-user=lipika.lipika@medunigraz.at
#SBATCH --partition=cpu
#SBATCH --error=cram2fq/error-cram2fq.e
#SBATCH --output=cram2fq/output-cram2fq.o

squeue -u 'o_lipika'

input="/home/isilon/users/o_lipika/FFPE-WGS-samples/cram-files/batch2/"
reference="/home/isilon/users/o_lipika/FFPE-WGS-samples/refernces/ref-karl/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna"
output_folder="/home/isilon/patho_anemone-meso/fastq/fq-files"

for cram_file in "$input"*.cram; do
    echo "Processing $cram_file"
    # Extract the sample name without the file extension
    sample_name=$(basename "$cram_file" .cram)

    sbatch <<EOF
#!/bin/bash
#SBATCH --job-name=cram2fq_${sample_name}
#SBATCH --output=cram2fq/cram2fq_${sample_name}.out
#SBATCH --error=cram2fq/cram2fq_${sample_name}.err
#SBATCH --partition=cpu
#SBATCH --cpus-per-task=24

# Run samtools fastq for each CRAM file
echo "Conversion started"
samtools fastq -@24 -t --reference "$reference" -1 "$output_folder/${sample_name}.R1.fastq" -2 "$output_folder/${sample_name}.R2.fastq" "$cram_file"

echo "Conversion completed for $cram_file"

# Zip the produced FASTQ files
gzip "$output_folder/${sample_name}.R1.fastq" & 
gzip "$output_folder/${sample_name}.R2.fastq" &

wait

echo "Conversion and compression completed for $cram_file"

EOF
done
