#!/bin/sh
#SBATCH --job-name='merge'
#SBATCH --mem=256GB
#SBATCH --mail-user=lipika.lipika@medunigraz.at
#SBATCH --partition=cpu
#SBATCH --output=merge/output-merge.o
#SBATCH --error=merge/error-merge.e

squeue -u 'o_lipika'

fastq_dir="/home/isilon/patho_anemone-meso/fastq/trimmed"

# Set the reference genome file
reference_genome="/home/isilon/users/o_lipika/FFPE-WGS-samples/refernces/ref/GRCh38_full_analysis_set_plus_decoy_hla.fa"
alt_file="/home/isilon/users/o_lipika/FFPE-WGS-samples/refernces/ref/GRCh38_full_analysis_set_plus_decoy_hla.fa.alt"

# Align reads to the new reference genome
for file1 in $fastq_dir/*lane.txt; do
    
    filename1="${file1##*/}"
    #echo "filename1" $filename1

    sample_name=$(echo "$filename1" | sed 's/_lane.txt//')
    #sample_name=$(echo "${filename1%_sorted*}" | sed 's/\.bam$//')
    echo "sample_name" $sample_name

    #rg_file="$fastq_dir/${sample_name}_RG.txt"
    #sample_file="$fastq_dir/${sample_name}_lane.txt"


    sbatch <<EOF
#!/bin/bash
#SBATCH --job-name=merge_${sample_name##*/}
#SBATCH --output=merge/merge_${sample_name##*/}.out
#SBATCH --error=merge/merge_${sample_name##*/}.err
#SBATCH --partition=cpu
#SBATCH --cpus-per-task=12

samtools merge -@12 -r $fastq_dir/${sample_name}_merged.bam -b $file1 

EOF
done
