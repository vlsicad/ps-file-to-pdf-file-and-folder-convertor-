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
WHOAMI=`whoami`
STARTIN=/home/$WHOAMI/Desktop
PS2PDF=`which ps2pdf`

###############################################################
# Check to see if ps2pdf can be found. If not, exit with
# warning. If so, proceed.
###############################################################
if [ -e $PS2PDF ]
then
echo "Nothing to do"
# This is a cludge because 1) bash has no unless statement like Perl
# and 2) bash doesn't read the whole file before execution so it doesn't know about the
# fileSel function below yet.
else
zenity --error --text="Could not find ps2pdf in your path. If it is installed, add the executable to your path. If it is not installed, install it."
exit
fi

###############################################################
# The function that fires off the file selection dialog.
# Clicking OK jumps to the fileName function. Clicking Cancel
# exits the script.
###############################################################
fileSel(){
cd $STARTIN
FILE=`zenity --file-selection --title "PS2PDF GUI"`
if [ "$?" == "0" ]
then
fileName
else
exit
fi
}

###############################################################
# The function that asks what you want to name the file.
# Clicking OK jumps to the fileConv function. Clicking Cancel
# returns back to the fileSel function.
###############################################################
fileName() {
# Split the file in two at the . Assume there is only one .
# in the file name. PATHFILE is the path an file name; EXT
# is the extension (ps)
PATHFILE=`echo $FILE | awk -F. '{print $1}'`
EXT=`echo $FILE | awk -F. '{print $2}'`

if [ $EXT = "ps" ]
then
FILENAME=`zenity --entry --title="Name File" --text="Name of output file" --entry-text="$PATHFILE.pdf"`
if [ "$?" == "0" ]
then
echo "File to convert is $PATHFILE"
fileConv
else
fileSel
fi
else
zenity --warning --title="Possible Format Error" --text="That file does not have a .ps extension. Are you sure it is in Postscript format?"
if [ "$?" == "0" ]
then
FILENAME=`zenity --entry --title="Name File" --text="Name of output file" --entry-text="$PATHFILE.pdf"`
echo "File to convert is $PATHFILE"
echo "File destination is $FILENAME"
fileConv
else
fileSel
fi
fi
}

###############################################################
# The function that does the conversion
###############################################################
fileConv(){
if [ -e $FILENAME ]
then
OVWR=`zenity --warning --title="Overwrite file?" --text="A file by that name already exists! Overwrite it?"`
if [ "$?" == "0" ]
then
echo "Nothing to do";
# Cludge again.
else
fileName
fi
else
echo "Nothing to do";
# Cludge again.
fi

# If the user selected OK, do the conversion and pipe it to
# Zenity's progress indicator. When the conversion is done,
# pop-up a dialog to let the user know. Clicking on OK there
# returns them to the file selection dialog.
$PS2PDF $FILE $FILENAME|zenity --progress --text="Processing..." --pulsate --auto-close --width=100 --title="Progress" 2>/dev/null
zenity --info --title="Conversion Complete" --text="The file completed conversion."
fileSel
}

fileSel 