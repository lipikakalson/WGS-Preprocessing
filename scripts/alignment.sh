#!/bin/sh
#SBATCH --job-name='alignment'
#SBATCH --mem=256GB
#SBATCH --mail-user=lipika.lipika@medunigraz.at
#SBATCH --partition=cpu
#SBATCH --output=alignment/output-alignment.o
#SBATCH --error=alignment/error-alignment.e

squeue -u 'o_lipika'

fastq_dir="/home/isilon/patho_anemone-meso/fastq/trimmed"

# Set the reference genome file
reference_genome="/home/isilon/users/o_lipika/FFPE-WGS-samples/refernces/ref/GRCh38_full_analysis_set_plus_decoy_hla.fa"
alt_file="/home/isilon/users/o_lipika/FFPE-WGS-samples/refernces/ref/GRCh38_full_analysis_set_plus_decoy_hla.fa.alt"

# Loop through all files in the directory
for file1 in "$fastq_dir"/*.R1.*.fastq.gz; do

    # Check if the corresponding R2 file exists
    file2=$(echo "$file1" | sed 's/R1/R2/g')
    echo "$file1"
    echo "$file2"

    header=$(zcat $file1 | head -n 1)
    #echo $header

    filename=$(basename $file1)
    SM=$(echo "$filename" | cut -d '_' -f 1)

    # Extract ID
    ID=$(echo "$header" | cut -d ':' -f 1 | cut -d '@' -f 2)
    #echo $ID

    # Extract Flowcell lane from the header
    flowcell_lane=$(echo "$header" | cut -d ':' -f 4 | cut -d ' ' -f 1)
    #echo $flowcell_lane

    # Combine ID and Flowcell lane
    ID="${ID}".${flowcell_lane}
    # Extract PL
    PL="ILLUMINA"

    # Extract PU
    PU=$(echo "$header" | cut -d ':' -f 3-4 | tr ':' '.')
    #echo "@RG\\tID:$ID\\tSM:$SM\\tPL:ILLUMINA\\tPU:$PU"
    #break

    if [ -f "$file2" ]; then
        # Submit alignment job for each pair of FASTQ files
        sbatch <<EOF
#!/bin/bash
#SBATCH --job-name=alignment_${file1##*/}
#SBATCH --output=alignment/alignment_${file1##*/}.out
#SBATCH --error=alignment/alignment_${file1##*/}.err
#SBATCH --partition=cpu
#SBATCH --cpus-per-task=36

# Align reads to the new reference genome

./bwa-mem2 mem -C -t 36 -R "@RG\\tID:$ID\\tSM:$SM\\tPL:$PL\\tPU:$PU" $reference_genome $file1 $file2 | k8 bwa-postalt.js $alt_file | samtools view -@36 -b | samtools sort -@36 -o "${file1%.R1.*.fastq.gz}_sorted.$flowcell_lane.bam"

samtools index -@36 "${file1%.R1.*.fastq.gz}_sorted.$flowcell_lane.bam"
echo "indexing done"

#rm "${file1%.R1.*.fastq.gz}.sam" "${file1%.R1.*.fastq.gz}.bam"
EOF
    fi
done

