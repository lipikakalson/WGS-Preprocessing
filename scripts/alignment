#!/bin/sh
#SBATCH --job-name='alignment'
#SBATCH --mem=256GB
#SBATCH --mail-user=lipika.lipika@medunigraz.at
#SBATCH --partition=cpu
#SBATCH --output=output-alignment.o
#SBATCH --error=error-alignment.e

squeue -u 'o_lipika'

fastq_dir="/home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed"

# Set the reference genome file
reference_genome="/home/isilon/users/o_lipika/FFPE-WGS-samples/refernces/ref/GRCh38_full_analysis_set_plus_decoy_hla.fa"
alt_file="/home/isilon/users/o_lipika/FFPE-WGS-samples/refernces/ref/GRCh38_full_analysis_set_plus_decoy_hla.fa.alt"

# Loop through all files in the directory
for file1 in "$fastq_dir"/*.R1.*.fastq.gz; do
    # Check if the corresponding R2 file exists
    file2=$(echo "$file1" | sed 's/R1/R2/g')
    echo "$file1"
    echo "$file2"
    if [ -f "$file2" ]; then
        # Submit alignment job for each pair of FASTQ files
        sbatch <<EOF
#!/bin/bash
#SBATCH --job-name=alignment_${file1##*/}
#SBATCH --output=alignment_${file1##*/}.out
#SBATCH --error=alignment_${file1##*/}.err
#SBATCH --partition=cpu
#SBATCH --cpus-per-task=48

# Align reads to the new reference genome
./bwa-mem2 mem -C -t 48 $reference_genome $file1 $file2 > "${file1%.R1.*.fastq.gz}.sam" | k8 bwa-postalt.js $alt_file
echo "alignment done"
echo ""

# Convert SAM to BAM format
samtools view -@48 -b -o "${file1%.R1.*.fastq.gz}.bam" "${file1%.R1.*.fastq.gz}.sam"
echo "sam to bam done"
echo " "

# Sort the BAM file
samtools sort -@48 -o "${file1%.R1.*.fastq.gz}_sorted.bam" "${file1%.R1.*.fastq.gz}.bam"
echo "sort done"
echo " "

# Index the sorted BAM file
# samtools index -@48 "${file1%.R1.*.fastq.gz}_sorted.bam"
# echo "indexing done"

rm "${file1%.R1.*.fastq.gz}.sam" "${file1%.R1.*.fastq.gz}.bam"
EOF
    fi
done
