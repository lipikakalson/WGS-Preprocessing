## Commands used

All the scripts for preprocessing and analysis.
In this script, we tried to do the preprocessing of the raw sequencing data to get analysis ready BAM files. (I tried to replicate the alignment-nf in this workflow). Batch script are in the folder, below are the commands used in the scripts. 

This might miss some necessary declaration of variable here like "filename", "input_dir", etc., bu they are there in batch scripts.

**1. Adaptor Trimming**
```
java -jar /home/gpfs/o_lipika/PhD-analysis/agent/lib/trimmer-3.0.5.jar \
    -fq1 /home/isilon/patho_anemone-meso/updated-data-bam/fastq/D6039-8__D6039-8_S2_230904_A01664_0191_BHKW72DSX7_out.R1.fastq.gz \
    -fq2 /home/isilon/patho_anemone-meso/updated-data-bam/fastq/D6039-8__D6039-8_S2_230904_A01664_0191_BHKW72DSX7_out.R2.fastq.gz \
    -v2 \ ## for Sureselect XT HS2 (library we used)
    -out_loc /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed
``` 

**2. Alignment**
```
./bwa-mem2 mem -C -t 48 $reference_genome $fastq_dir/D6039-8__D6039-8_S2_230904_A01664_0191_BHKW72DSX7_out.R1.1708286122814_Cut_0.fastq.gz $fastq_dir/D6039-8__D6039-8_S2_230904_A01664_0191_BHKW72DSX7_out.R2.1708286122814_Cut_0.fastq.gz > $fastq_dir/D6039-8__D6039-8_S2_230904_A01664_0191_BHKW72DSX7_out.sam | k8 bwa-postalt.js $alt_file
echo "alignment done"
echo ""

# Convert SAM to BAM format
samtools view -@48 -b -o $fastq_dir/D6039-8__D6039-8_S2_230904_A01664_0191_BHKW72DSX7_out.bam $fastq_dir/D6039-8__D6039-8_S2_230904_A01664_0191_BHKW72DSX7_out.sam
echo "sam to bam done"
echo " "

# Sort the BAM file
samtools sort -@48 -o $fastq_dir/D6039-8__D6039-8_S2_230904_A01664_0191_BHKW72DSX7_out_sorted.bam $fastq_dir/D6039-8__D6039-8_S2_230904_A01664_0191_BHKW72DSX7_out.bam
echo "sort done"
echo " "

# Index the sorted BAM file
# samtools index -@48 "${file1%.R1.*.fastq.gz}_sorted.bam"
# echo "indexing done"

rm "$fastq_dir/D6039-8__D6039-8_S2_230904_A01664_0191_BHKW72DSX7_out.R1.sam" "$fastq_dir/D6039-8__D6039-8_S2_230904_A01664_0191_BHKW72DSX7_out.bam"
```

**3. Add RG information**
```
# D6039-8__D6039-8
# @A01664:191:HKW72DSX7:1:1101:1027:1016 1:N:0:TGCTGCTC+TTAGGTGC

srun samtools addreplacerg -@24 -r ID:HKW72DSX7.1 -r SM:D6039-8 -r PL:ILLUMINA -o /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6039-8__D6039-8_S2_230904_A01664_0191_BHKW72DSX7_outt_sorted_RG.bam /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6039-8__D6039-8_S2_230904_A01664_0191_BHKW72DSX7_out_sorted.bam
```

**4. Markduplicates**
```
java -jar "$PICARD_JAR" UmiAwareMarkDuplicatesWithMateCigar -I "${INPUT_DIR}/${filename}" -O "${filename1}_dedup.bam" -M "${filename1}_duplicate_metrics.txt" -UMI_METRICS "${filename1}_umi_metrics.txt" --BARCODE_TAG BC --TMP_DIR "$tmp" --REMOVE_DUPLICATES true

rm -r "$tmp"
```

**5. BQSR**
```
ref="/home/isilon/users/o_lipika/FFPE-WGS-samples/refernces/ref/GRCh38_full_analysis_set_plus_decoy_hla.fa"
dbsnp="/home/isilon/users/o_lipika/FFPE-WGS-samples/refernces/ref/gatk/dbsnp_146.hg38.vcf.gz"
indel="/home/isilon/users/o_lipika/FFPE-WGS-samples/refernces/ref/gatk/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz"

gatk BaseRecalibrator --java-options "-Xmx256G" -R $ref -I $bam_file --known-sites $dbsnp --known-sites $indel -O ${filename1}_output_file_recal1.table
gatk ApplyBQSR --java-options "-Xmx256G" -R $ref -I $bam_file --bqsr-recal-file ${filename1}_output_file_recal1.table -O ${filename1}_output_file_BQSRecalibrated.bam
gatk BaseRecalibrator --java-options "-Xmx256G" -R $ref -I ${filename1}_output_file_BQSRecalibrated.bam  --known-sites $dbsnp --known-sites $indel -O ${filename1}_output_file_recal2.table
gatk AnalyzeCovariates --java-options "-Xmx256G" -before ${filename1}_output_file_recal1.table  -after ${filename1}_output_file_recal2.table -plots ${filename1}_output_file_BQSRecalibrated_recalibration_plots.pdf
```

**6. Qualimap**
```
qualimap bamqc -nt 36 --skip-duplicated -bam $bam_file --java-mem-size=256G -outdir $ouput/$filename -outformat html
echo "qualimap done and sambamba submitted"
sambamba flagstat -t 36 $bam_file  > ${ouput_dir1}/${filename}.stats.txt
echo "sambamba done"
```

**7. MultiQC**











