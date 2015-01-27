#!/bin/sh
# pulldata.sh

# Download data
for i in $(seq 1990 2014)
	do wget http://www.energy.gov.on.ca/fuelupload/ONTREG$i.csv
done

# Retain the header
head -n 2 ONTREG1990.csv | sed 1d > ONTREG_merged.csv

# Loop over the files and use sed to extract the relevant lines
for i in $(seq 1990 2014)
	do
	tail -n 15 ONTREG$i.csv | sed 13,15d | sed 's/./-01-'$i',/4' >> ONTREG_merged.csv
	done
