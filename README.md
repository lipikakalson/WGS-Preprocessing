# PhD-summary
This readme file is a summary of the things we did so far for the aim 1 of my PhD.

We did following steps so far:
1. Selection of Patients <br>
2. Whole genome Sequencing <br>
3. Analysis

# 1. Selection of patients
Done by Luka.

# 2. Whole Genome Analysis
We used 7µm FFPE sections for DNA extraction with the Promega Maxwell RSC FFPE Plus DNA kit . For the WGS Libraryprep we used the Agilent Surelect Kit (see attachement). Input material in the libraryprep was 200ng FFPE DNA. Shearing time was set to 15 minutes and the precapture PCR was done with 10 cycles in a Thermofisher Proflex PCR cycler.
After quantification on the Agilent TapeStation with the D1000 kit, the WGS sequencing was performed on the Illumina NovaSeq 6000 Sequencer on S4 Flow Cells (200 cyles)  with calculated 800 Mio Reads per sample.

# 3. Bioinformatics
Our first aim was to see the quality of our data. We have raw cram files for our analysis. We performed following steps:

**Step 1: Conversion to fastq.**
We did this as most of the common bioinformatics tool accept the .fastq extension files for analysis, so it is easy for further processing.

**Step 2 Adaptor Trimming.**
We have dual indexed molecular barcoded fastq files, so for that we used Trimmer by AGeNT (The Agilent Genomics Tooklkit). It removes adaptor sequences from Illumina Sequencing reads generated using Sureselect library preparation kits, it also processed the Molecular Barcodes(MBC) and adds teh information to read name of output fastq files.
Fastq files now somehat looks like this.
```
@A01664:161:HG7L2DRX3:2:1101:22688:19617	BC:Z:GAGCACTG+CACAATTC	ZA:Z:ATACT	ZB:Z:CAGT	RX:Z:ATA-CAG	QX:Z:FFF FFF
AAATCCAACCCTATGGAGCCACGGAGGATCTGCTAACAAGGTAGATGACTTAGTACCTATAACAGAAGCCATCAGCACAGGATTTAATTAACCATACACAAGAACCATCAG
+
FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF:FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
```


