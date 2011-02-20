Changelog
=========
0.5 - 2011-02-20
--------------
*   4.2 compatibility

0.4 - 2010-12-28
--------------
*   fixed Grooveshark API changes (htmlshark client)
	
0.3 - 2010-11-30
--------------
*   internals
    *   fixed memory leaks
    *   uuid is now random
*   now on the awkwardtv repository
	
0.2 - 2010-11-23
--------------
*   Login with your Grooveshark Username/Password. The informations are saved in the app. No need to re-enter it.
*   Logout and all informations will be deleted
*   Playlists
	*   Browse in your playlists and play your songs
	*   Add songs to your playlist (eg. search a song and then push ‚ÄúAdd to playlist‚Äù)
*   Shuffle songs in list (search list & playlist list)
*   Play all songs in list (search list & playlist list)
*   "Playing now" in the main menu. The currently played track.
*   Duration is now correct in the list view.
*   Cover is now showing in the player view

0.1 - 2010-11-13
--------------
*   Initial Release
*   Simple search and player functionality


Roadmap
=======

*   Better Search Result (Album / Interpret )
*   Favorites
*   My Music

Build
=====

    ./build.sh

Installation
=============

	echo "deb http://apt.weasel-project.com ./" > /etc/apt/sources.list.d/weasel.list
	apt-get update
	apt-get install com.atv.groovy

Known Bugs
==========
*    When you switch fast between shuffle mode and play all groovy lags or crash

Bug Tracker
===========
Issues at github
