#!/bin/bash
#SBATCH --job-name=mdup_batch
#SBATCH --mail-user=lipika.lipika@medunigraz.at
#SBATCH --partition=cpu
#SBATCH --output=mdup/output.o
#SBATCH --error=mdup/error.e

INPUT_DIR="/home/isilon/patho_anemone-meso/fastq/trimmed/"
OUTPUT_DIR="/home/isilon/patho_anemone-meso/fastq/dedup/samtools/"
LOG_DIR="mdup"

for bam in "$INPUT_DIR"*merged.bam; do
  filename=$(basename "$bam")
  sample=$(basename "$bam" .bam)
  outbam="${OUTPUT_DIR}${sample}_dedup.bam"

  sbatch <<EOF
#!/bin/bash
#SBATCH --job-name=mdup_$sample
#SBATCH --output=${LOG_DIR}/output-$sample.o
#SBATCH --error=${LOG_DIR}/error-$sample.e
#SBATCH --partition=cpu
#SBATCH --cpus-per-task=12
#SBATCH --mem=192G

set -euo pipefail

echo "🔁 Starting: $sample"

samtools sort -n -@12 "$bam" | samtools fixmate -m -@12 - - | samtools sort -@12 - | samtools markdup -@12 --barcode-tag RX --use-read-groups --duplicate-count - "$outbam"
samtools index "$outbam"

echo "✅ Finished: $outbam"
EOF

done
