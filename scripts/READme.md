## Commands used

All the scripts for preprocessing and analysis.
In this script, we tried to do the preprocessing of the raw sequencing data to get analysis ready BAM files. (I tried to replicate the alignment-nf in this workflow). Batch script are in the folder, below are the commands used in the scripts. 

This might miss some necessary declaration of variable here like "filename", "input_dir", etc., but they are there in batch scripts.

**1. Cram to fastq**
```
samtools fastq -@24 -t --reference "$reference" -1 "$output_folder/${sample_name}.R1.fastq" -2 "$output_folder/${sample_name}.R2.fastq" "$cram_file"
```

**2. Split-lanewise**
```
zcat $file1 | /home/gpfs/o_lipika/PhD-analysis/fastq-split/fastqSplit -k 3 -p -prefix ${sample_name1}. &
zcat $r2_file | /home/gpfs/o_lipika/PhD-analysis/fastq-split/fastqSplit -k 3 -p -prefix ${sample_name2}. &
```
Using the [https://github.com/stevekm/fastq-split](https://github.com/stevekm/fastq-split)
Readname looks like this: **@A01664:191:HKW72DSX7:1:1101:1027:1016 1:N:0:TGCTGCTC+TTAGGTGC**, so splitting at lane number at 4th column(indexing starts from 0)



**3. Adaptor Trimming**
```
java -Djava.io.tmpdir="$TEMPDIR" -Dsamjdk.threads=24 -jar /home/gpfs/o_lipika/PhD-analysis/agent/lib/trimmer-3.0.5.jar \
    -fq1 $file1 \
    -fq2 $r2_file \
    -v2 \
    -out_loc $OUTPUT_DIR
``` 

**4. Alignment**
```
for file1 in "$fastq_dir"/*.R1.*.fastq.gz; do

    # Check if the corresponding R2 file exists
    file2=$(echo "$file1" | sed 's/R1/R2/g')
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

    # Align reads to the reference genome
    ./bwa-mem2 mem -C -t 36 -R "@RG\\tID:$ID\\tSM:$SM\\tPL:$PL\\tPU:$PU" $reference_genome $file1 $file2 | k8 bwa-postalt.js $alt_file | samtools view -@36 -b | samtools sort -@36 -o "${file1%.R1.*.fastq.gz}_sorted.$flowcell_lane.bam"
    samtools index -@36 "${file1%.R1.*.fastq.gz}_sorted.$flowcell_lane.bam"
done
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

done

##part2
for file1 in $fastq_dir/*lane.txt; do
    
    filename1="${file1##*/}"
    #echo "filename1" $filename1

    sample_name=$(echo "$filename1" | sed 's/_lane.txt//')
    #sample_name=$(echo "${filename1%_sorted*}" | sed 's/\.bam$//')
    echo "sample_name" $sample_name

    samtools merge -@12 -r $fastq_dir/${sample_name}_merged.bam -b $file1 
done
```

**6. Markduplicates**
```
java -Djava.io.tmpdir="$TEMPDIR" -Dsamjdk.threads=24 -jar "$PICARD_JAR" MarkDuplicates -I "${INPUT_DIR}/${filename}" -O "${filename1}_dedup.bam" -M "${filename1}_duplicate_metrics.txt" --BARCODE_TAG RX --TMP_DIR $TEMP
 
```

**7. BQSR**
```
ref="/home/isilon/users/o_lipika/FFPE-WGS-samples/refernces/ref/GRCh38_full_analysis_set_plus_decoy_hla.fa"
dbsnp="/home/isilon/users/o_lipika/FFPE-WGS-samples/refernces/ref/gatk/dbsnp_146.hg38.vcf.gz"
indel="/home/isilon/users/o_lipika/FFPE-WGS-samples/refernces/ref/gatk/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz"

gatk BaseRecalibrator --java-options "-Xmx144G -Djava.io.tmpdir=$TEMPDIR -Dsamjdk.threads=24" -R $ref -I $bam_file --known-sites $dbsnp --known-sites $indel -O ${filename1}_recal1.table
gatk ApplyBQSR --java-options "-Xmx144G -Djava.io.tmpdir=$TEMPDIR -Dsamjdk.threads=24" -R $ref -I $bam_file --bqsr-recal-file ${filename1}_recal1.table -O ${filename1}_BQSRecalibrated.bam
gatk BaseRecalibrator --java-options "-Xmx144G -Djava.io.tmpdir=$TEMPDIR -Dsamjdk.threads=24" -R $ref -I ${filename1}_BQSRecalibrated.bam  --known-sites $dbsnp --known-sites $indel -O ${filename1}_recal2.table
gatk AnalyzeCovariates --java-options "-Xmx144G -Djava.io.tmpdir=$TEMPDIR -Dsamjdk.threads=24" -before ${filename1}_recal1.table  -after ${filename1}_recal2.table -plots ${filename1}_BQSRecalibrated_recalibration_plots.pdf 
```

**8. Qualimap**
```
qualimap bamqc -nt 36 --skip-duplicated -bam $bam_file --java-mem-size=256G -outdir $ouput/$filename -outformat html
echo "qualimap done and sambamba submitted"
sambamba flagstat -t 36 $bam_file  > ${ouput_dir1}/${filename}.stats.txt
echo "sambamba done"
```

**9. MultiQC** <br>
qc-files folder has recal-tables from BQSR, flagstat results of *output_file_BQSRecalibrated.bam, and qualimap results.
```
multiqc /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/qc-files/ -n multiqc_qualimap_flagstat_BQSR_report.html --comment "WGS final QC report"
```











