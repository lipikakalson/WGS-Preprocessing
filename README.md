# ANEMONE
This readme file is a summary of the things we did so far for the ANEMONE WGS.

We did following steps so far:
1. Selection of Patients <br>
2. Whole genome Sequencing <br>
3. Preprocessing
4. Analysis (to do)

# 1. Selection of patients
Done by Luka.

# 2. Whole Genome Analysis
We used 7µm FFPE sections for DNA extraction with the Promega Maxwell RSC FFPE Plus DNA kit . For the WGS Libraryprep we used the Agilent Surelect Kit (see attachement). Input material in the libraryprep was 200ng FFPE DNA. Shearing time was set to 15 minutes and the precapture PCR was done with 10 cycles in a Thermofisher Proflex PCR cycler.
After quantification on the Agilent TapeStation with the D1000 kit, the WGS sequencing was performed on the Illumina NovaSeq 6000 Sequencer on S4 Flow Cells (200 cyles)  with calculated 800 Mio Reads per sample.

# 3. Preprocessing
To make our data analysis ready, our first aim was to see the quality of our data. We have raw cram files for our analysis on which we performed following steps (We atleast desire 30x coverage):

### **Step 1: Conversion to fastq.** <br>
We did this as most of the common bioinformatics tool accept the .fastq extension files for analysis, so it is easy for further processing.

### **Step 2: Split lanewise each fastq file** <br>
In later steps like using BQSR, exact readname information is needed, and also to keep the analysis to up to the mark, we performed this step so our bams could have each unique RG headers. Also, so reads could be tagged during alignment.

### **Step 3: Adaptor Trimming.** <br>
We have dual indexed molecular barcoded fastq files, so for that we used Trimmer by [AGeNT](https://www.agilent.com/cs/library/software/Public/AGeNT%20ReadMe.pdf) (The Agilent Genomics Tooklkit). It removes adaptor sequences from Illumina Sequencing reads generated using Sureselect library preparation kits, it also processed the Molecular Barcodes(MBC) and adds the information to read name of output fastq files.

### **Step 4: Alignment** <br>
Alignment of the fastq files using the hs38DH.fa, also did the post processing using the bwa.kit for alt handling. Bams were merged for the same samples. Then sorting, and indexing. (Computationaly intensive).

### **Step 5: Duplicate removal** <br>
This was done by samtools v1.21 with BARCODE_TAG as RX, as we have molecular barcoded genome libraries.

### **Step 6: BQSR** 
Base Quality Score Recalibration ([BQSR](https://gatk.broadinstitute.org/hc/en-us/articles/360035890531-Base-Quality-Score-Recalibration-BQSR)):- A data pre-processing step that detects systematic errors made by the sequencing machine when it estimates the accuracy of each base call.

### **Step 7: Qualimap**
[Qualimap](http://qualimap.conesalab.org/doc_html/index.html) Examines sequencing alignment data in SAM/BAM format.

# Miscellaneous question
## 1. hs38DH.fa
hs38DH.fa consists of several components: chromosomal assembly, unlocalized contigs (chromosome known but location unknown), unplaced contigs (chromosome unknown), ALT contigs (long clustered variations), HLA sequnences, decoys. Using ALT contigs in read mapping is tricky.
GRCh38 ALT contigs are totaled 109Mb in length, spanning 60Mbp of the primary assembly. However, sequences that are highly diverged from the primary assembly only contribute a few million bp. Most subsequences of ALT contigs are nearly identical to the primary assembly. If we align sequence reads to GRCh38+ALT blindly, we will get many additional reads with zero mapping quality and miss variants on them.

For this, we used bwa - which is a alt-aware aligner. It does alignment in two steps: BWA-MEM mapping, post-processing (for alt handling). (More detail in regarding alt-aware mapping [bwa](https://github.com/lh3/bwa/blob/master/README-alt.md).

## 2. 
