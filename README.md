# PhD-summary
This readme file is a summary of the things we did so far for the aim 1 of my PhD.

We did following steps so far:
1. Selection of Patients <br>
2. Whole genome Sequencing <br>
3. Preprocessing
4. Analysis

# 1. Selection of patients
Done by Luka.

# 2. Whole Genome Analysis
We used 7µm FFPE sections for DNA extraction with the Promega Maxwell RSC FFPE Plus DNA kit . For the WGS Libraryprep we used the Agilent Surelect Kit (see attachement). Input material in the libraryprep was 200ng FFPE DNA. Shearing time was set to 15 minutes and the precapture PCR was done with 10 cycles in a Thermofisher Proflex PCR cycler.
After quantification on the Agilent TapeStation with the D1000 kit, the WGS sequencing was performed on the Illumina NovaSeq 6000 Sequencer on S4 Flow Cells (200 cyles)  with calculated 800 Mio Reads per sample.

# 3. Preprocessing
To make our data analysis ready, our first aim was to see the quality of our data. We have raw cram files for our analysis on which we performed following steps:

### **Step 1: Conversion to fastq.** <br>
We did this as most of the common bioinformatics tool accept the .fastq extension files for analysis, so it is easy for further processing.

### **Step 2: Adaptor Trimming.** <br>
We have dual indexed molecular barcoded fastq files, so for that we used Trimmer by AGeNT (The Agilent Genomics Tooklkit). It removes adaptor sequences from Illumina Sequencing reads generated using Sureselect library preparation kits, it also processed the Molecular Barcodes(MBC) and adds the information to read name of output fastq files.
Fastq files now somehat looks like this.

### **Step 3: Alignment** <br>
Alignment of the fastq files using the hs38DH.fa, also did the post processing using the bwa.kit for alt handling. Then sorting, and indexing. (Computationaly intensive).

### **Step 4: RG information** <br>
Our aligned bam files did not have read group (@RG) information required to remove duplicates. We added this using samtools "addreplacerg" command.

(Step 3 and 4 can be merged for later)

### **Step 4: Duplicate removal** <br>
This was done by GATK [UmiAwareMarkDuplicatesWithMateCigar](https://gatk.broadinstitute.org/hc/en-us/articles/360037593651-UmiAwareMarkDuplicatesWithMateCigar-Picard-EXPERIMENTAL) as we have molecular barcoded genome libraries.

### **Step 5: BQSR** 
Base Quality Score Recalibration ([BQSR](https://gatk.broadinstitute.org/hc/en-us/articles/360035890531-Base-Quality-Score-Recalibration-BQSR)):- A data pre-processing step that detects systematic errors made by the sequencing machine when it estimates the accuracy of each base call.

### **Step 6: Qualimap**
[Qualimap](http://qualimap.conesalab.org/doc_html/index.html) Examines sequencing alignment data in SAM/BAM format.

# Miscellaneous question
## 1. hs38DH.fa
hs38DH.fa consists of several components: chromosomal assembly, unlocalized contigs (chromosome known but location unknown), unplaced contigs (chromosome unknown), ALT contigs (long clustered variations), HLA sequnences, decoys. Using ALT contigs in read mapping is tricky.
GRCh38 ALT contigs are totaled 109Mb in length, spanning 60Mbp of the primary assembly. However, sequences that are highly diverged from the primary assembly only contribute a few million bp. Most subsequences of ALT contigs are nearly identical to the primary assembly. If we align sequence reads to GRCh38+ALT blindly, we will get many additional reads with zero mapping quality and miss variants on them.

For this, we used bwa - which is a alt-aware aligner. It does alignment in two steps: BWA-MEM mapping, post-processing (for alt handling). (More detail in regarding alt-aware mapping [bwa](https://github.com/lh3/bwa/blob/master/README-alt.md).

## 2. 
