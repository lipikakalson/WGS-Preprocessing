#!/bin/bash
#SBATCH --job-name='add-rg'
#SBATCH --mail-user=lipika.lipika@medunigraz.at
#SBATCH --partition=cpu
#SBATCH --error=error-rg.e
#SBATCH --output=output-rg.o

squeue -u 'o_lipika'


# D6035-3__D6035-3
# @A01664:153:HHVFHDMXY:1:1103:24361:12712 1:N:0:AATACGCG+CAGACCTG 

srun samtools addreplacerg -@24 -r ID:HHVFHDMXY.1 -r SM:D6035-3 -r PL:ILLUMINA -o /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6035-3__D6035-3_S2_230628_A01664_0153_AHHVFHDMXY_out_sorted_RG.bam /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6035-3__D6035-3_S2_230628_A01664_0153_AHHVFHDMXY_out_sorted.bam &


# D6036-3__D6036-3
# @A01664:153:HHVFHDMXY:2:1106:24713:32737 1:N:0:GCACACAT+CGCGTATT

srun samtools addreplacerg -@24 -r ID:HHVFHDMXY.2 -r SM:D6036-3 -r PL:ILLUMINA -o /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6036-3__D6036-3_S3_230628_A01664_0153_AHHVFHDMXY_out_sorted_RG.bam /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6036-3__D6036-3_S3_230628_A01664_0153_AHHVFHDMXY_out_sorted.bam &

# D6037-3__D6037-3
# @A01664:153:HHVFHDMXY:1:1103:22598:1579 1:N:0:CTTGCATA+ATGTGTGC

srun samtools addreplacerg -@24 -r ID:HHVFHDMXY.1 -r SM:D6037-3 -r PL:ILLUMINA -o /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6037-3__D6037-3_S4_230628_A01664_0153_AHHVFHDMXY_out_sorted_RG.bam /home/isilon/patho_anemone-meso/updated-data-bam/fastq/test1/D6037-3__D6037-3_S4_230628_A01664_0153_AHHVFHDMXY_out_sorted.bam &

# D6039-8__D6039-8
# @A01664:191:HKW72DSX7:1:1101:1027:1016 1:N:0:TGCTGCTC+TTAGGTGC

srun samtools addreplacerg -@24 -r ID:HKW72DSX7.1 -r SM:D6039-8 -r PL:ILLUMINA -o /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6039-8__D6039-8_S2_230904_A01664_0191_BHKW72DSX7_outt_sorted_RG.bam /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6039-8__D6039-8_S2_230904_A01664_0191_BHKW72DSX7_out_sorted.bam &

# D6039-9__D6039-9
# @A01664:191:HKW72DSX7:1:1101:1443:1016 1:N:0:TGGCACCA+GAGCAGCA

srun samtools addreplacerg -@24  -r ID:HKW72DSX7.1 -r SM:D6039-9 -r PL:ILLUMINA -o /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6039-9__D6039-9_S3_230904_A01664_0191_BHKW72DSX7_out_sorted_RG.bam /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6039-9__D6039-9_S3_230904_A01664_0191_BHKW72DSX7_out_sorted.bam &

# D6040-6__D6040-6
# @A01664:153:HHVFHDMXY:2:1102:28004:5368 1:N:0:ATCCTCTT+TATGCAAG

srun samtools addreplacerg -@24 -r ID:HHVFHDMXY.2 -r SM:D6040-6 -r PL:ILLUMINA -o /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6040-6__D6040-6_S5_230628_A01664_0153_AHHVFHDMXY_out_sorted_RG.bam /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6040-6__D6040-6_S5_230628_A01664_0153_AHHVFHDMXY_out_sorted.bam &

# D6040-8__D6040-8
# @A01664:159:HG257DRX3:2:1101:4734:19304 1:N:0:AGATGGAT+TGGTGCCA

srun samtools addreplacerg -@24 -r ID:HG257DRX3.2 -r SM:D6040-8 -r PL:ILLUMINA -o /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6040-8__D6040-8_S17_230707_A01664_0159_BHG257DRX3_out_sorted_RG.bam /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6040-8__D6040-8_S17_230707_A01664_0159_BHG257DRX3_out_sorted.bam &

# D6042-3__D6042-3
# @A01664:191:HKW72DSX7:1:1101:4535:1016 1:N:0:GTCCTATA+GTTCTCAT

srun samtools addreplacerg -@24 -r ID:HKW72DSX7.1 -r SM:D6042-3 -r PL:ILLUMINA -o /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6042-3__D6042-3_S10_230904_A01664_0191_BHKW72DSX7_out_sorted_RG.bam /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6042-3__D6042-3_S10_230904_A01664_0191_BHKW72DSX7_out_sorted.bam &

# D6043-5__D6043-5
# @A01664:209:HLHNCDSX7:1:1118:9715:4319 1:N:0:AATGACCA+TATAGGAC

srun samtools addreplacerg -@24 -r ID:HLHNCDSX7.1 -r SM:D6043-5 -r PL:ILLUMINA -o /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6043-5__D6043-5_S13_231023_A01664_0209_AHLHNCDSX7_out_sorted_RG.bam /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6043-5__D6043-5_S13_231023_A01664_0209_AHLHNCDSX7_out_sorted.bam &

# D6045-2__D6045-2
# @A01664:161:HG7L2DRX3:2:1101:22688:19617 1:N:0:GAGCACTG+CACAATTC

srun samtools addreplacerg -@24 -r ID:HG7L2DRX3.2 -r SM:D6045-2 -r PL:ILLUMINA -o /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6045-2__D6045-2_S17_230713_A01664_0161_BHG7L2DRX3_out_sorted_RG.bam /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6045-2__D6045-2_S17_230713_A01664_0161_BHG7L2DRX3_out_sorted.bam &

# D6049-4__D6049-4
# @A01664:191:HKW72DSX7:1:1110:9362:10097 1:N:0:CAGACGCT+TGGTCATT

srun samtools addreplacerg -@24 -r ID:HKW72DSX7.1 -r SM:D6049-4 -r PL:ILLUMINA -o /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6049-4__D6049-4_S11_230904_A01664_0191_BHKW72DSX7_out_sorted_RG.bam /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6049-4__D6049-4_S11_230904_A01664_0191_BHKW72DSX7_out_sorted.bam &

# D6051-2__D6051-2
# @A01664:191:HKW72DSX7:1:1101:1750:1016 1:N:0:GTTGCGGA+CAGTGCTC

srun samtools addreplacerg -@24 -r ID:HKW72DSX7.1 -r SM:D6051-2 -r PL:ILLUMINA -o /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6051-2__D6051-2_S4_230904_A01664_0191_BHKW72DSX7_out_sorted_RG.bam /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6051-2__D6051-2_S4_230904_A01664_0191_BHKW72DSX7_out_sorted.bam &
 
# D6052-2__D6052-2
# @A01664:191:HKW72DSX7:1:1101:1262:1016 2:N:0:AATGGAAC+TCCGCAAC

srun samtools addreplacerg -@24 -r ID:HKW72DSX7.1 -r SM:D6052-2 -r PL:ILLUMINA -o /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6052-2__D6052-2_S5_230904_A01664_0191_BHKW72DSX7_out_sorted_RG.bam /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6052-2__D6052-2_S5_230904_A01664_0191_BHKW72DSX7_out_sorted.bam &

# D6053-2__D6053-2
# @A01664:191:HKW72DSX7:1:1110:12843:12555 1:N:0:TCAGAGGT+GTTCCATT

srun samtools addreplacerg -@24 -r ID:HKW72DSX7.1 -r SM:D6053-2 -r PL:ILLUMINA -o /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6053-2__D6053-2_S6_230904_A01664_0191_BHKW72DSX7_out_sorted_RG.bam /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6053-2__D6053-2_S6_230904_A01664_0191_BHKW72DSX7_out_sorted.bam &

# D6054-3__D6054-3
# @A01664:191:HKW72DSX7:1:1101:1009:1016 1:N:0:TCGAACTG+AGCGTCTG

srun samtools addreplacerg -@24 -r ID:HKW72DSX7.1 -r SM:D6054-3 -r PL:ILLUMINA -o /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6054-3__D6054-3_S12_230904_A01664_0191_BHKW72DSX7_out_sorted_RG.bam /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6054-3__D6054-3_S12_230904_A01664_0191_BHKW72DSX7_out_sorted.bam &

# D6055-3__D6055-3
# @A01664:209:HLHNCDSX7:1:1127:2302:26804 1:N:0:CGCTTCCA+CAGTTCGA

srun samtools addreplacerg -@24 -r ID:HLHNCDSX7.1 -r SM:D6055-3 -r PL:ILLUMINA -o /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6055-3__D6055-3_S14_231023_A01664_0209_AHLHNCDSX7_out_sorted_RG.bam /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6055-3__D6055-3_S14_231023_A01664_0209_AHLHNCDSX7_out_sorted.bam &

# D6587-15__D6587-1
# @A01664:191:HKW72DSX7:1:1128:7455:30686 1:N:0:ATGAGAAC+CACGACGA

srun samtools addreplacerg -@24 -r ID:HKW72DSX7.1 -r SM:D6587-15 -r PL:ILLUMINA -o /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6587-15__D6587-15_S1_230904_A01664_0191_BHKW72DSX7_out_sorted_RG.bam /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6587-15__D6587-15_S1_230904_A01664_0191_BHKW72DSX7_out_sorted.bam &

# D6606-2__D6606-2
# @A01664:191:HKW72DSX7:1:1119:12509:16329 1:N:0:GCAACAAT+ACCTCTGA

srun samtools addreplacerg -@24 -r ID:HKW72DSX7.1 -r SM:D6606-2 -r PL:ILLUMINA -o /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/ D6606-2__D6606-2_S8_230904_A01664_0191_BHKW72DSX7_out_sorted_RG.bam /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/ D6606-2__D6606-2_S8_230904_A01664_0191_BHKW72DSX7_out_sorted.bam &

# D6607-2__D6607-2
# @A01664:191:HKW72DSX7:1:1110:28574:12054 1:N:0:GTCGATCG+ATTGTTGC

srun samtools addreplacerg -@24  -r ID:HKW72DSX7.1 -r SM:D6607-2 -r PL:ILLUMINA -o /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6607-2__D6607-2_S9_230904_A01664_0191_BHKW72DSX7_out_sorted_RG.bam /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6607-2__D6607-2_S9_230904_A01664_0191_BHKW72DSX7_out_sorted.bam &

# D6608-2__D6608-2
# @A01664:193:HG25CDRX3:2:1101:31720:15060 1:N:0:ATGGTAGC+CGATCGAC

srun samtools addreplacerg -@24 -r ID:HG25CDRX3.2 -r SM:D6608-2 -r PL:ILLUMINA -o /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6608-2__D6608-2_S26_230907_A01664_0193_BHG25CDRX3_out_sorted_RG.bam /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6608-2__D6608-2_S26_230907_A01664_0193_BHG25CDRX3_out_sorted.bam &

# D6609-2__D6609-2
# @A01664:209:HLHNCDSX7:1:1101:1434:1000 1:N:0:NGCCAATT+GCTACCAT

srun samtools addreplacerg-@24 -r ID:HLHNCDSX7.1 -r SM:D6609-2 -r PL:ILLUMINA -o /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6609-2__D6609-2_S4_231023_A01664_0209_AHLHNCDSX7_out_sorted_RG.bam /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6609-2__D6609-2_S4_231023_A01664_0209_AHLHNCDSX7_out_sorted.bam &

# D6610-2__D6610-2
# @A01664:209:HLHNCDSX7:1:1118:31494:18677 1:N:0:GACAATTG+AATTGGCG

srun samtools addreplacerg -@24 -r ID:HLHNCDSX7.1 -r SM:D6610-2 -r PL:ILLUMINA -o /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6610-2__D6610-2_S5_231023_A01664_0209_AHLHNCDSX7_out_sorted_RG.bam /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6610-2__D6610-2_S5_231023_A01664_0209_AHLHNCDSX7_out_sorted.bam &

# D6611-2__D6611-2
# @A01664:209:HLHNCDSX7:1:1127:22046:35289 1:N:0:ATATTCCG+CAATTGTC

srun samtools addreplacerg -@24 -r ID:HLHNCDSX7.1 -r SM:D6611-2 -r PL:ILLUMINA -o /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6611-2__D6611-2_S6_231023_A01664_0209_AHLHNCDSX7_out_sorted_RG.bam /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6611-2__D6611-2_S6_231023_A01664_0209_AHLHNCDSX7_out_sorted.bam &

# D6612-2__D6612-2
# @A01664:209:HLHNCDSX7:1:1119:16658:12085 1:N:0:TCTACCTC+CGGAATAT

srun samtools addreplacerg -@24 -r ID:HLHNCDSX7.1 -r SM:D6612-2 -r PL:ILLUMINA -o /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6612-2__D6612-2_S7_231023_A01664_0209_AHLHNCDSX7_out_sorted_RG.bam /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6612-2__D6612-2_S7_231023_A01664_0209_AHLHNCDSX7_out_sorted.bam &

# D6613-2__D6613-2
# @A01664:209:HLHNCDSX7:1:1127:23963:31187 1:N:0:TCGTCGTG+GAGGTAGA

srun samtools addreplacerg -@24 -r ID:HLHNCDSX7.1 -r SM:D6613-2 -r PL:ILLUMINA -o /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6613-2__D6613-2_S8_231023_A01664_0209_AHLHNCDSX7_out_sorted_RG.bam /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6613-2__D6613-2_S8_231023_A01664_0209_AHLHNCDSX7_out_sorted.bam &

# D6614-3__D6614-3
# @A01664:209:HLHNCDSX7:1:1119:4689:26209 1:N:0:TATTCCTG+TGGAAGCG

srun samtools addreplacerg -@24 -r ID:HLHNCDSX7.1 -r SM:D6614-3 -r PL:ILLUMINA -o /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6614-3__D6614-3_S15_231023_A01664_0209_AHLHNCDSX7_out_sorted_RG.bam /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6614-3__D6614-3_S15_231023_A01664_0209_AHLHNCDSX7_out_sorted.bam &

# D6661-2__D6661-2
# @A01664:209:HLHNCDSX7:1:1129:5746:13041 1:N:0:CAAGTTAC+CAGGAATA

srun samtools addreplacerg -@24 -r ID:HLHNCDSX7.1 -r SM:D6661-2 -r PL:ILLUMINA -o /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6661-2__D6661-2_S16_231023_A01664_0209_AHLHNCDSX7_out_sorted_RG.bam /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6661-2__D6661-2_S16_231023_A01664_0209_AHLHNCDSX7_out_sorted.bam &

# D6662-3__D6662-3
# @A01664:209:HLHNCDSX7:1:1118:7717:25535 1:N:0:CAGAGCAG+GTAACTTG

srun samtools addreplacerg -@24 -r ID:HLHNCDSX7.1 -r SM:D6662-3 -r PL:ILLUMINA -o /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6662-3__D6662-3_S17_231023_A01664_0209_AHLHNCDSX7_out_sorted_RG.bam /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D6662-3__D6662-3_S17_231023_A01664_0209_AHLHNCDSX7_out_sorted.bam &

# D7196-10__D7196-10
# @A01664:191:HKW72DSX7:1:1110:4752:14137 1:N:0:CGCGCAAT+CTGCTCTG

srun samtools addreplacerg -@24 -r ID:HKW72DSX7.1 -r SM:D7196-10 -r PL:ILLUMINA -o /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D7196-10__D7196-10_S7_230904_A01664_0191_BHKW72DSX7_out_sorted_RG.bam /home/isilon/patho_anemone-meso/updated-data-bam/fastq/trimmed/D7196-10__D7196-10_S7_230904_A01664_0191_BHKW72DSX7_out_sorted.bam &


wait
