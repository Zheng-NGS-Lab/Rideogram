# Rideogram - An R script for making ideogram, with marks on defined chromosome locations.

### (By: zhengzongli@gmail.com, 2014-12-01)

## 1. Clone:

	git clone https://github.com/Zheng-NGS-Lab/Rideogram.git

## 2. Prepare an input file that contains a list of targets. This file must include five fields.
 E.g.: GUIDE-Seq_target.list.txt

	#Chromosome     Start   End     Targetsite      Mismatches
	chr2    73160981        73161004        EMX1    0
	chr5    45359060        45359083        EMX1    2
	chr2    219845055       219845078       EMX1    3
	chr15   65637530        65637553        VEGFA_site1     2
	chr6    43737290        43737313        VEGFA_site1     0
	chr1    99347644        99347667        VEGFA_site1     3

 The field Targetsite is the sgRNA name.

 The field Mismatches being '0' means on-target, and >= 1 means off-target.

## 3. Run the following command

	Rscript  rideo.R  /your/full/path/to/git/rideo  GUIDE-Seq_target.list.txt

	# In the 'output' folder, you will get a pdf file for each of the Targetsite, such as:
	#	output/GUIDE-Seq_target.list.EMX1.pdf 
	#	output/GUIDE-Seq_target.list.VEGFA_site1.pdf 

## 4. Make your own target list file (contains the 5 fields), and run:

	Rscript  rideo.R  /your/full/path/to/git/rideo  MyTargetList.txt

