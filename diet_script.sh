#!/bin/bash


####################################################################################################################################################################################

###Start of commands###

####################################################################################################################################################################################

##Unzip fastq.gz files##
$gunzip *.gz

##Check reads info##
$usearch -fastx_info RM-amplicons050819_S1_L001_R1_001.fastq
$usearch -fastx_info RM-amplicons050819_S1_L001_R2_001.fastq

##Merge pairs##
$usearch -fastq_mergepairs RM-amplicons050819_S1_L001_R1_001.fastq -fasqout ../out/pairs.fq


##Demultiplex by Forward##

$~/.local/bin/cutadapt -g file:Forward_Tags.fas  -o ../out/Azores{name}.fasta pairs.fastq -e 0.1 --length-tag "length="


###Demultiplex by Reverse###

$~/.local/bin/cutadapt -a file:../fq/Reverse_Tags.fas -o AzoresF1{name}.fasta AzoresF1.fasta -e 0.1 -x F1{name}. --minimum-length 260 --maximum-length 280
$~/.local/bin/cutadapt -a file:../fq/Reverse_Tags.fas -o AzoresF2{name}.fasta AzoresF2.fasta -e 0.1 -x F2{name}. --minimum-length 260 --maximum-length 280
$~/.local/bin/cutadapt -a file:../fq/Reverse_Tags.fas -o AzoresF3{name}.fasta AzoresF3.fasta -e 0.1 -x F3{name}. --minimum-length 260 --maximum-length 280
$~/.local/bin/cutadapt -a file:../fq/Reverse_Tags.fas -o AzoresF4{name}.fasta AzoresF4.fasta -e 0.1 -x F4{name}. --minimum-length 260 --maximum-length 280
$~/.local/bin/cutadapt -a file:../fq/Reverse_Tags.fas -o AzoresF5{name}.fasta AzoresF5.fasta -e 0.1 -x F5{name}. --minimum-length 260 --maximum-length 280

#Here we merge all files into one called merged.fasta#

cat AzoresF1R*.fasta > mergedF1.fasta
cat AzoresF2R*.fasta > mergedF2.fasta
cat AzoresF3R*.fasta > mergedF3.fasta
cat AzoresF4R*.fasta > mergedF4.fasta
cat AzoresF5R*.fasta > mergedF5.fasta

cat mergedF*.fasta > merged.fasta


###
Uniques###
$usearch -fastx_uniques ../merged.fasta -fastaout uniques.fasta -relabel Uniq -sizeout

##OTU's##
$usearch -cluster_otus uniques.fasta -minsize 2 -otus otus.fasta -relabel Otu
$usearch -usearch_global ../merged.fasta -db otus.fasta -strand plus -id 0.97 -otutabout otutable.txt





