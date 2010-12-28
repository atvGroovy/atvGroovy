//
//  Groovy.h
//  Groovy
//
//  Copyright (c) 2010, hackfrag <hackfrag@gmail.com , headcrap <headcrap19388@googlemail.com>
//  http://groovy.weasel-project.com
//  
//  All rights reserved.
//  
//  
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction except as noted below, including without limitation 
//  the rights to use,copy, modify, merge, publish, distribute, 
//  and/or sublicense, and to permit persons to whom the Software is 
//  furnished to do so, subject to the following conditions:
//  
//  The Software and/or source code cannot be copied in whole and 
//  sold without meaningful modification for a profit. 
//  
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//  
//  Redistributions of source code must retain the above copyright 
//  notice, this list of conditions and the following disclaimer.
//  
//  Redistributions in binary form must reproduce the above copyright 
//  notice, this list of conditions and the following disclaimer in 
//  the documentation and/or other materials provided with 
//  the distribution.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.


#import <CommonCrypto/CommonDigest.h>
#import "JSON.h"
#import "SongAsset.h"
#import "User.h"
#import "Playlist.h"
#import <dispatch/dispatch.h>

#define GROOVY_JSPLAYER 0
#define GROOVY_GSLITE 1
#define GROOVY_JSQUEUE 2

#define GROOVY_PLAYLIST_ADDSONG 0
#define GROOVY_PLAYLIST_PLAYSONG 1


@class SongAsset;
@class User;

/**
 * Grooveshark Webservice URL
 */
extern const NSString *groovyURLmore;
/**
 * Grooveshark Stream Service URL
 */
extern const NSString *groovyURLstream;
/**
 * NSDictonary Key for Username
 */
extern const NSString *groovyUsernameKey;
/**
 * NSDictonary Key for Password
 */
extern const NSString *groovyPasswordKey;
/**
 * Notification name when player starts playing
 */
extern const NSString *groovyPlayNotification;

@interface Groovy : NSObject {
	/**
	 * Grooveshark session id. Random md5 hash 
	 */
	NSString *session;
	
	/**
	 * Grooveshark api communicationToken
	 */
	NSString *communicationToken;
	
	/**
	 * uniq uuid for the communication with grooveshark
	 */
	NSString *uuid;
	
	/**
	 * Current logged user
	 */
	User *user;
}

@property (nonatomic, retain) NSString *session;
@property (nonatomic, retain) NSString *communicationToken;
@property (nonatomic, retain) User *user;

+ (Groovy *)sharedGroovy;

- (void)initiateSession:(void (^)(void))callback;
- (void)getCommunicationToken:(void (^)(void))callback;

- (void)favoritesSongs;
- (void)favoritesPlaylists;
- (void)favoritesUser;
- (void)playlists:(void(^)(NSArray *playlists))callback;
- (void)popularSongsToday;
- (void)popularSongsMonth;
- (void)songsInLibrary;
- (void)songsInPlayList:(NSInteger)playlistID callback:(void(^)(NSArray *songs))callback;


- (void)createPlaylistWith:(NSString *)name description:(NSString *)description callback:(void (^)(NSInteger playlistID))callback;
- (void)addSongToLibrary:(NSInteger)songID;
- (void)addSong:(SongAsset *)song toPlaylist:(Playlist *)playlist callback:(void (^)(BOOL status))callback;
- (void)addSongToFavorites:(NSInteger)songID;


- (void)logoutUser;
- (void)authenticate:(NSString *)username with:(NSString *)password callback:(void (^)(User *user))callback;

- (void)getSearchResults:(NSString *)searchString callback:(void (^)(NSArray *songs))callback;
- (void)getStreamUrlBySong:(SongAsset *)song callback:(void (^)(NSString *streamUrl))callback;
- (NSString *)getSynchronStreamUrlBySong:(SongAsset *)song;

@end
