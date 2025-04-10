#!/bin/sh
#SBATCH --job-name='merge2'
#SBATCH --mail-user=lipika.lipika@medunigraz.at
#SBATCH --partition=cpu
#SBATCH --output=merge/output-merge2.o
#SBATCH --error=merge/error-merge2.e

squeue -u 'o_lipika'

fastq_dir="/home/isilon/patho_anemone-meso/fastq/trimmed"

for file1 in $fastq_dir/*lane.txt; do

    # Extract first BAM file from list
    first_bam=$(head -n 1 "$file1")

    # Extract SM tag from @RG line in BAM header
    SM=$(samtools view -H "$first_bam" | grep "^@RG" | head -n 1 | sed -n 's/.*SM:\([^ \t]*\).*/\1/p')

    echo "Merging for sample: $SM"

    sbatch <<EOF
#!/bin/bash
#SBATCH --job-name=merge_${SM}
#SBATCH --output=merge/merge_${SM}.out
#SBATCH --error=merge/merge_${SM}.err
#SBATCH --partition=cpu
#SBATCH --cpus-per-task=12
#SBATCH --mem=96GB

samtools merge -@12 -r $fastq_dir/${SM}_merged.bam -b $file1
echo "Merged BAM created: ${SM}_merged.bam"
EOF

done
