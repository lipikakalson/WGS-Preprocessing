#!/bin/sh
#SBATCH --job-name='gatk'
#SBATCH --mem=256GB
#SBATCH --mail-user=lipika.lipika@medunigraz.at
#SBATCH --partition=cpu
#SBATCH --cpus-per-task=24
#SBATCH --output=gatk-output.o
#SBATCH --error=gatk-error.e
squeue -u 'o_lipika'

ulimit -c unlimited

ref="/home/isilon/users/o_lipika/FFPE-WGS-samples/refernces/ref/GRCh38_full_analysis_set_plus_decoy_hla.fa"
dbsnp="/home/isilon/users/o_lipika/FFPE-WGS-samples/refernces/ref/gatk/dbsnp_146.hg38.vcf.gz"
indel="/home/isilon/users/o_lipika/FFPE-WGS-samples/refernces/ref/gatk/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz"

INPUT_DIR="/home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/batch1"



for bam_file in "$INPUT_DIR"/*out_sorted_RG_dedup.bam; do
  echo "bam file: $bam_file"
  # Extract filename without path and directory part
  filename=$(basename "$bam_file")
  filename1="${bam_file%.bam}"

  sbatch <<EOF
#!/bin/bash
#SBATCH --job-name=gatk_${filename%.*}
#SBATCH --output=gatk_${filename%.*}.out
#SBATCH --error=gatk_${filename%.*}.err
#SBATCH --partition=cpu
#SBATCH --cpus-per-task=24
#SBATCH --mem=256GB

gatk BaseRecalibrator --java-options "-Xmx256G" -R $ref -I $bam_file --known-sites $dbsnp --known-sites $indel -O ${filename1}_output_file_recal1.table

gatk ApplyBQSR --java-options "-Xmx256G" -R $ref -I $bam_file --bqsr-recal-file ${filename1}_output_file_recal1.table -O ${filename1}_output_file_BQSRecalibrated.bam

gatk BaseRecalibrator --java-options "-Xmx256G" -R $ref -I ${filename1}_output_file_BQSRecalibrated.bam  --known-sites $dbsnp --known-sites $indel -O ${filename1}_output_file_recal2.table

gatk AnalyzeCovariates --java-options "-Xmx256G" -before ${filename1}_output_file_recal1.table  -after ${filename1}_output_file_recal2.table -plots ${filename1}_output_file_BQSRecalibrated_recalibration_plots.pdf


EOF

done
