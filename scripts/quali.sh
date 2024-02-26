#!/bin/sh
#SBATCH --job-name='qualimap'
#SBATCH --mem=256GB
#SBATCH --mail-user=lipika.lipika@medunigraz.at
#SBATCH --partition=cpu
#SBATCH --cpus-per-task=36
#SBATCH --output=quali-output.o
#SBATCH --error=quali-error.e
squeue -u 'o_lipika'

ulimit -c unlimited

#ref="/home/isilon/users/o_lipika/FFPE-WGS-samples/refernces/ref/GRCh38_full_analysis_set_plus_decoy_hla.fa"
#dbsnp="/home/isilon/users/o_lipika/FFPE-WGS-samples/refernces/ref/gatk/dbsnp_146.hg38.vcf.gz"
#indel="/home/isilon/users/o_lipika/FFPE-WGS-samples/refernces/ref/gatk/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz"

INPUT_DIR="/home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/batch2"
ouput="/home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/qualimap"
ouput_dir1="/home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/flagstat_results"


for bam_file in "$INPUT_DIR"/*dedup_output_file_BQSRecalibrated.bam; do
  echo "bam file: $bam_file"
  # Extract filename without path and directory part
  filename=$(basename "$bam_file")
  filename1="${bam_file%.bam}"

 
 sbatch <<EOF
#!/bin/bash
#SBATCH --job-name=quali_${filename%.*}
#SBATCH --output=quali_${filename%.*}.out
#SBATCH --error=quali_${filename%.*}.err
#SBATCH --partition=cpu
#SBATCH --cpus-per-task=36
#SBATCH --mem=256GB


echo "quali submit"
qualimap bamqc -nt 36 --skip-duplicated -bam $bam_file --java-mem-size=256G -outdir $ouput/$filename -outformat html
echo "qualimap done and sambamba submitted"
sambamba flagstat -t 36 $bam_file  > ${ouput_dir1}/${filename}.stats.txt
echo "sambamba done"

EOF

done
