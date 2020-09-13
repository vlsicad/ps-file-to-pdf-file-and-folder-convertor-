#!/bin/bash
###############################################################
# Purpose: Provide GUI for converting postscript (*.ps) files
# to Adobe PDF using the Zenity framework
###############################################################

###############################################################
# Change to the directory where we want our script to start
# looking for video files.
# Set the path to mencoder and check for it. If not found,
# give error and bail out. If found, proceed...
###############################################################

# The function that fires off the file selection dialog.
# Clicking OK jumps to the fileName function. Clicking Cancel
# exits the script.
###############################################################



cd ~
CLOC=`zenity --file-selection --title "PS2PDF GUI" --directory`
if [ "$?" == "0" ]
then
cd $CLOC
for x in *.ps; do echo $x;ps2pdf $x ${x/%ps/pdf}; done 
zenity --info --title="Conversion Complete" --text="The file completed conversion."
else
exit
fi

