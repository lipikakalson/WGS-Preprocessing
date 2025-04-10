#!/bin/sh
#SBATCH --job-name='qualimap'
#SBATCH --mem=30GB
#SBATCH --mail-user=lipika.lipika@medunigraz.at
#SBATCH --partition=cpu
#SBATCH --output=quali-output/quali-output.o
#SBATCH --error=quali-output/quali-error.e
squeue -u 'o_lipika'

ulimit -c unlimited
unset DISPLAY

#ref="/home/isilon/users/o_lipika/FFPE-WGS-samples/refernces/ref/GRCh38_full_analysis_set_plus_decoy_hla.fa"
#dbsnp="/home/isilon/users/o_lipika/FFPE-WGS-samples/refernces/ref/gatk/dbsnp_146.hg38.vcf.gz"
#indel="/home/isilon/users/o_lipika/FFPE-WGS-samples/refernces/ref/gatk/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz"

INPUT_DIR="/home/isilon/patho_anemone-meso/fastq/dedup/samtools/"
ouput="/home/isilon/patho_anemone-meso/fastq/qc-files/qualimap"
ouput_dir1="/home/isilon/patho_anemone-meso/fastq/qc-files/flagstat_results"


for bam_file in "$INPUT_DIR"/*BQSRecalibrated.bam; do
  echo "bam file: $bam_file"
  # Extract filename without path and directory part
  filename=$(basename "$bam_file")
  filename1="${bam_file%.bam}"

 
 sbatch <<EOF
#!/bin/bash
#SBATCH --job-name=quali_${filename%.*}
#SBATCH --output=quali-output/quali_${filename%.*}.out
#SBATCH --error=quali-output/quali_${filename%.*}.err
#SBATCH --partition=cpu
#SBATCH --cpus-per-task=4
#SBATCH --mem=50G

#echo "quali submit"
qualimap bamqc -nt 4 --skip-duplicated -bam $bam_file -outdir $ouput/$filename -outformat html -c --java-mem-size=40G 
#echo "qualimap done and sambamba submit "
sambamba flagstat -t 4 $bam_file  > ${ouput_dir1}/${filename}.stats.txt 

echo "sambamba done"

EOF

done
