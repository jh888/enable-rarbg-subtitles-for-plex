# enable-rarbg-subtitles-for-plex
Move/rename RARBG subtitles so Plex will use them

This script will look for english .srt files within rarbg movies' subdirectories/folders and copy the smallest one (if there are multiple, so that the hard-of-hearing versions are hopefully not used) to the movie directory with the proper name of the movie.

This script can be run on Linux or Windows.  If running on Windows, the Windows Subsystem for Linux (WSL) must be installed.  Ubuntu works well.  Then the shell script can be run manually or from scheduled tasks.

Be sure to update the configuration section with your library locations as seen from within the linux shell.

The script will also create a rollback script to undo any changes that it made - just in case things don't go as expected.

Example of operation:
/Movies/MovieName (2006)/Subs/2_English.srt

would be copied to the parent directory and match the movie file's filename with an 'en' tag for english.

/Movies/MovieName (2006)/MovieName.2006.1080p.WEBRip.x264-RARBG.en.srt
