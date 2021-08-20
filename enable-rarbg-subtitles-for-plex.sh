#!/bin/bash
#
# enable-rarbg-subtitles-for-plex.sh
# jh888
# 
# This script will look for english .srt files within a directory and copy the smallest one (if there are multiple,
# so that the hard-of-hearing versions are hopefully not used) to the movie directory with the proper name of the movie.
#

runtime=`date +%Y%m%d%H%M%S`

#################################################################################################################################################
# Configuration Section

# Add Plex library paths here
LIBRARYPATHS=("/h/Video/Christmas Movies" "/h/Video/Kids Movies" "/h/Video/Movies" "/g/Video/Movies")

# Set logging to true to enable normal logging to a file
logging=true
loggingfilename=enable-rarbg-subtitles-for-plex-$runtime.log

# Set this to true if you want a rollback script created.
rollbackscript=true
rollbackscriptfilename=enable-rarbg-subtitles-for-plex-$runtime-rollback.sh

# Set debug to true to enable debug logging
debug=false

#################################################################################################################################################

PrevMovieName=""
PrevFileSize=0
CopyFile=0

# Loop through each library path
for LIBRARYPATHITEM in "${LIBRARYPATHS[@]}";
do
	echo "******** Start of $LIBRARYPATHITEM Library ********"
	echo "******** Start of $LIBRARYPATHITEM Library ********" >> $loggingfilename

	# Loop through all of the RARBG directories and look for files with "eng" and ".srt" in them at least one subdirectory down
	find "$LIBRARYPATHITEM" -mindepth 3 -type f -regex '.*RARBG.*[Ee][Nn][Gg].*\.srt' -print0 | while read -d $'\0' srtline
  	do
	  if [ "$debug" = true ]; then echo "srtline = $srtline"; fi
	  CurMovieName=`echo "$srtline" | cut -d/ -f5`
	  CurMoviePath=`echo "$srtline" | cut -d/ -f1,2,3,4,5`
	  CurSrtFilenameFull=$srtline
	  CurFileSize=`stat -c%s "$srtline"`

	  # If this is an additional srt file for this movie, determine which one is smaller and keep/copy the smaller one
	  if [[ "$CurMovieName" == "$PrevMovieName" ]]; then
		  if [ "$debug" == true ]; then echo "$CurMovieName equals $PrevMovieName"; fi
		  if [[ ! "$CurFileSize" -lt "$PrevFileSize" ]]; then
			  echo "$CurFileSize is greater than or equal to $PrevFileSize.  We won't copy $CurSrtFilenameFull."
			  if [ "$logging" == true ]; then echo "$CurFileSize is greater than or equal to $PrevFileSize.  We won't copy $CurSrtFilenameFull." >> $loggingfilename; fi
			  CopyFile=0;
		  else
			  echo "$CurFileSize is less than $PrevFileSize.  We WILL copy $CurSrtFilenameFull."
			  if [ "$logging" == true ]; then echo "$CurFileSize is less than $PrevFileSize.  We WILL copy $CurSrtFilenameFull." >> $loggingfilename; fi
			  CopyFile=1;
		  fi
	  else
		  if [ "$debug" == true ]; then echo "New Movie.  We'll copy this file: $CurSrtFilenameFull"; fi
		  CopyFile=1;
	  fi

	  if [ "$debug" == true ]; then echo "CurMoviePath=$CurMoviePath"; fi
	  
	  # Determine the future .srt filename to use
	  find "$CurMoviePath" -type f -regex '.*RARBG.*\.mp4' -print0 | while read -d $'\0' mp4line
  	    do
		    CurMovieFilenameBase=`echo "$mp4line" | cut -d/ -f6 | sed 's/\.mp4//'`
		    NewSrtFilename="$CurMovieFilenameBase.en.srt"
		    NewSrtFilenameFull="$CurMoviePath/$NewSrtFilename"
		    if [ "$debug" == true ]; then
			    echo "mp4line = $mp4line"
		            echo "CurMovieFilenameBase=$CurMovieFilenameBase"
		            echo "NewSrtFilename=$NewSrtFilename"
			    echo "NewSrtFilenameFull=$NewSrtFilenameFull"
		    fi

		    # Copy the file if marked
	            if [[ $CopyFile == 1 ]]; then
		            echo "Copying $CurSrtFilenameFull to $NewSrtFilenameFull."
		            if [ "$logging" == true ]; then echo "Copying $CurSrtFilenameFull to $NewSrtFilenameFull." >> $loggingfilename; fi

			    # Create a rollback script
			    if [ "$rollbackscript" == true ]; then echo "rm \"$NewSrtFilenameFull\"" >> $rollbackscriptfilename; fi

			    # Perform the copy
			    cp "$CurSrtFilenameFull" "$NewSrtFilenameFull"
	            fi
            done

	  PrevMovieName=$CurMovieName
	  PrevFileSize=$CurFileSize
	  CopyFile=0
	done
	

	echo "******** End of $LIBRARYPATHITEM Library ********"
	echo "******** End of $LIBRARYPATHITEM Library ********" >> $loggingfilename

done
