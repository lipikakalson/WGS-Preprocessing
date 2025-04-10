#!/bin/sh
#SBATCH --job-name='gatk'
#SBATCH --mail-user=lipika.lipika@medunigraz.at
#SBATCH --partition=cpu
#SBATCH --output=gatk/gatk-output.o
#SBATCH --error=gatk/gatk-error.e
squeue -u 'o_lipika'

ulimit -c unlimited

ref="/home/isilon/users/o_lipika/FFPE-WGS-samples/refernces/ref/GRCh38_full_analysis_set_plus_decoy_hla.fa"
dbsnp="/home/isilon/users/o_lipika/FFPE-WGS-samples/refernces/ref/gatk/new/dbsnp_146.hg38.vcf.gz"
indel="/home/isilon/users/o_lipika/FFPE-WGS-samples/refernces/ref/gatk/new/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz"

INPUT_DIR="/home/isilon/patho_anemone-meso/fastq/dedup/samtools"

for bam_file in "$INPUT_DIR"/*dedup.bam; do
  echo "bam file: $bam_file"
  # Extract filename without path and directory part
  filename=$(basename "$bam_file")
  filename1="${bam_file%.bam}"

  sbatch <<EOF
#!/bin/bash
#SBATCH --job-name=${filename%.*}_BQSR
#SBATCH --output=gatk/o_${filename%.*}.o
#SBATCH --error=gatk/e_${filename%.*}.e
#SBATCH --partition=cpu
#SBATCH --cpus-per-task=2
#SBATCH --mem=12GB

#n_TEMPDIR="/home/isilon/patho_anemone-meso/tmp/\${filename%.*}_${SLURM_JOB_ID}"
#mkdir -p "\${n_TEMPDIR}"

# Step 2: Set trap to delete it automatically on job exit
#trap 'rm -rf "\${n_TEMPDIR}"' EXIT

gatk BaseRecalibrator --java-options "-Xmx12G  -Dsamjdk.threads=2" -R $ref -I $bam_file --known-sites $dbsnp --known-sites $indel -O ${filename1}_recal1.table

gatk ApplyBQSR --java-options "-Xmx12G  -Dsamjdk.threads=2" -R $ref -I $bam_file --bqsr-recal-file ${filename1}_recal1.table -O ${filename1}_BQSRecalibrated.bam

gatk BaseRecalibrator --java-options "-Xmx12G  -Dsamjdk.threads=2" -R $ref -I ${filename1}_BQSRecalibrated.bam  --known-sites $dbsnp --known-sites $indel -O ${filename1}_recal2.table

gatk AnalyzeCovariates --java-options "-Xmx12G -Dsamjdk.threads=2" -before ${filename1}_recal1.table  -after ${filename1}_recal2.table -plots ${filename1}_BQSRecalibrated_recalibration_plots.pdf 

EOF
done

