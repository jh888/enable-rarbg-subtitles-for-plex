# enable-rarbg-subtitles-for-plex
Move/rename RARBG subtitles so Plex will use them

This script will look for english .srt files within rarbg movies' subdirectories and copy the smallest one (if there are multiple, so that the hard-of-hearing versions are hopefully not used) to the movie directory with the proper name of the movie.

This script can be run on Linux or Windows.  If running on Windows, the Windows Subsystem for Linux (WSL) must be installed.  Then the shell script can be run from scheduled tasks.
