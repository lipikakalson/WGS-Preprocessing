## Commands used

All the scripts for preprocessing and analysis.
In this script, we tried to do the preprocessing of the raw sequencing data to get analysis ready BAM files. (I tried to replicate the alignment-nf used at IARC in this workflow). Batch script are in the folder, below are the commands used in the scripts. 

This might miss some necessary declaration of variable here like "filename", "input_dir", etc., but they are there in batch scripts.

**1. Cram to fastq**
```
samtools fastq -@8 -t --reference "$reference" -1 "$output_folder/${sample_name}.R1.fastq" -2 "$output_folder/${sample_name}.R2.fastq" "$cram_file"
```

**2. Split-lanewise**
```
gunzip -c $file1 | /home/gpfs/o_lipika/PhD-analysis/fastq-split/fastqSplit -k 2,3 -p -prefix ${sample_name1}. &
```
Using the [fastq-split](https://github.com/stevekm/fastq-split). <br>
Readname looks like this: **@A01664:191:HKW72DSX7:1:1101:1027:1016 1:N:0:TGCTGCTC+TTAGGTGC**, so splitting at 3rd, 4th columns(indexing starts from 0)


**3. Adaptor Trimming**
```
java -Djava.io.tmpdir="$TEMPDIR" -Dsamjdk.threads=12 -jar /home/gpfs/o_lipika/PhD-analysis/agent/lib/trimmer-3.0.5.jar \
    -fq1 $file1 \
    -fq2 $r2_file \
    -v2 \
    -out_loc $OUTPUT_DIR
```
Using the tool developed by Agilent itself - because it removes the adaptor as well as move the UMIs into a tag, which could be used later for marking duplicates. 

**4. Alignment**
```
./bwa-mem2 mem -C -Y -t 12 -R '@RG\tID:$ID\tPL:ILLUMINA\tPU:$PU\tSM:$SM'  $reference_genome $file1 $file2 | k8 bwa-postalt.js $alt_file | samtools view -@12 -b | samtools sort -@12 -o "${file1%.R1.*.fastq.gz}_sorted.$flowcell_lane.bam"
```

**5. Merge BAMs** <br>
For all the files in directory, not single sample. <br>
Part1 - wrote the number of splitted files there are for one sample in *lane.txt file. Also, grepped @RG for the all the splitted bams in *RG.txt, just to cross check. <brr>
Part2 - used the *lane.txt file, to merge the bam and -r is used to tag the reads with @RG
```
##part1
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


##part2

samtools merge -@12 -r $fastq_dir/${SM}_merged.bam -b $file1
```

**6. Markduplicates**
```
samtools sort -n -@12 "$bam" | samtools fixmate -m -@12 - - | samtools sort -@12 - | samtools markdup -@12 --barcode-tag RX --use-read-groups --duplicate-count - "$outbam"
samtools index "$outbam" 
```
samtools version1.21 - helps in marking duplicates using barcode tag (UMIs).

**7. BQSR**
```
ref="/home/isilon/users/o_lipika/FFPE-WGS-samples/refernces/ref/GRCh38_full_analysis_set_plus_decoy_hla.fa"
dbsnp="/home/isilon/users/o_lipika/FFPE-WGS-samples/refernces/ref/gatk/dbsnp_146.hg38.vcf.gz"
indel="/home/isilon/users/o_lipika/FFPE-WGS-samples/refernces/ref/gatk/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz"

gatk BaseRecalibrator --java-options "-Xmx12G  -Dsamjdk.threads=2" -R $ref -I $bam_file --known-sites $dbsnp --known-sites $indel -O ${filename1}_recal1.table

gatk ApplyBQSR --java-options "-Xmx12G  -Dsamjdk.threads=2" -R $ref -I $bam_file --bqsr-recal-file ${filename1}_recal1.table -O ${filename1}_BQSRecalibrated.bam

gatk BaseRecalibrator --java-options "-Xmx12G  -Dsamjdk.threads=2" -R $ref -I ${filename1}_BQSRecalibrated.bam  --known-sites $dbsnp --known-sites $indel -O ${filename1}_recal2.table

gatk AnalyzeCovariates --java-options "-Xmx12G -Dsamjdk.threads=2" -before ${filename1}_recal1.table  -after ${filename1}_recal2.table -plots ${filename1}_BQSRecalibrated_recalibration_plots.pdf 
```
This is done to improve base quality accuracy and remove systematic errors (gatk - best practices). Improves variant calling.

**8. Qualimap**
```
qualimap bamqc -nt 4 --skip-duplicated -bam $bam_file -outdir $ouput/$filename -outformat html -c --java-mem-size=40G 
#echo "qualimap done and sambamba submit "
sambamba flagstat -t 4 $bam_file  > ${ouput_dir1}/${filename}.stats.txt 
echo "sambamba done"
```
Quality control (QC) of aligned BAM files.

**9. MultiQC** <br>
```
multiqc /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/qc-files/ -n multiqc_qualimap_flagstat_BQSR_report.html --comment "WGS final QC report"
```
qc-files folder has recal-tables from BQSR, flagstat results of *output_file_BQSRecalibrated.bam, and qualimap results.












