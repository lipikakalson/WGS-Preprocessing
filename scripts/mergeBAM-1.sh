#!/bin/sh
#SBATCH --job-name='merge1'
#SBATCH --mail-user=lipika.lipika@medunigraz.at
#SBATCH --partition=cpu
#SBATCH --output=merge/output-merge.o
#SBATCH --error=merge/error-merge.e
#SBATCH --mem=96GB

squeue -u 'o_lipika'

fastq_dir="/home/isilon/patho_anemone-meso/fastq/trimmed"

# Set the reference genome file
reference_genome="/home/isilon/users/o_lipika/FFPE-WGS-samples/refernces/ref/GRCh38_full_analysis_set_plus_decoy_hla.fa"
alt_file="/home/isilon/users/o_lipika/FFPE-WGS-samples/refernces/ref/GRCh38_full_analysis_set_plus_decoy_hla.fa.alt"

# Align reads to the new reference genome
for file1 in $fastq_dir/*_sorted.*.bam; do
    
    filename1="${file1##*/}"
    #echo "filename1" $filename1

    #sample_name=$(echo "$filename1" | sed 's/_sorted[._0-9]*//')
    sample_name=$(echo "${filename1%_sorted*}" | sed 's/\.bam$//')
    #echo "sample_name" $sample_name

    rg_file="$fastq_dir/${sample_name}_RG.txt"
    sample_file="$fastq_dir/${sample_name}_lane.txt"
    touch "$rg_file"
    touch "$sample_file"


    for bam_file in $fastq_dir/$sample_name*.bam; do
	echo $bam_file >> "$sample_file"
        samtools view -H $bam_file | grep '^@RG' >> $rg_file
    done

    sort -u -o "$rg_file" "$rg_file"
    sort -u -o "$sample_file" "$sample_file"

    echo "Processed $file1"

done

