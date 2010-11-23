//
//  Groovy.m
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
//  and/or sublicense, and to permit pexrsons to whom the Software is 
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

#import "Groovy.h"

const NSString *groovyURLmore = @"https://cowbell.grooveshark.com/more.php";
const NSString *groovyURLstream = @"http://%@/stream.php?streamKey=%@";
const NSString *groovyPlayNotification = @"groovyPlayNotification";
const NSString *groovyUsernameKey = @"GroovesharkUsername";
const NSString *groovyPasswordKey = @"GroovesharkPassword";

#pragma -
// Private Methods
@interface Groovy()

- (NSDictionary *)call:(NSString *)method withParams:(NSDictionary *)params withClient:(int)client;
- (NSString *)generateTokenFor:(NSString *)method;
- (NSString *)md5:(NSString *)input;
- (NSString *)sha1:(NSString *)input;
- (NSString *)uuid;
- (NSDictionary *)country;
@end

@implementation Groovy

#pragma mark -
#pragma mark Singleton

static Groovy *sharedGroovy = nil;

+ (Groovy *)sharedGroovy {
	@synchronized(self) {
		if (sharedGroovy == nil)
		{
			sharedGroovy = [[self alloc] init];
		}
	}
	
	return sharedGroovy;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (sharedGroovy == nil) {
			sharedGroovy = [super allocWithZone:zone];
			return sharedGroovy;
		}
	}
	return nil;
}
- (id)copyWithZone:(NSZone *)zone {
	return self;
}
- (id)retain {
	return self;
}
- (NSUInteger)retainCount
{
	return NSUIntegerMax; 
}
- (void)release {
}

- (id)autorelease { 
	return self; 
}

#pragma mark -
#pragma mark Properties
@synthesize session;
@synthesize communicationToken;
@synthesize user;

#pragma mark -
#pragma mark init/dealloc
- (id)init {
	
	self = [super init];

	
	return self;	
}
- (void)dealloc {
	
	[super dealloc];
	[self.session release];
	[self.communicationToken release];
	[self.user release];
	
}
#pragma mark -
#pragma mark md5/sha1

- (NSString *)sha1:(NSString *)input {
	const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
	NSData *data = [NSData dataWithBytes:cstr length:input.length];
	
	uint8_t sha1[CC_SHA1_DIGEST_LENGTH];
	
	CC_SHA1(data.bytes, data.length, sha1);
	
	NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
	
	int i;
	for(i=0; i < CC_SHA1_DIGEST_LENGTH; i++)
		[output appendFormat:@"%02x", sha1[i]];
	
	return output;
	
}

- (NSString *)md5:(NSString *)input {
    const char *concat_str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(concat_str, strlen(concat_str), result);
    NSMutableString *hash = [NSMutableString string];
	int i;
    for (i=0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
	
}
#pragma mark -
#pragma mark Grooveshark API Functions


- (void)songsInLibrary {
	/*
	NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:@"",@"userID", @"0", @"page", nil];
	NSDictionary *response = [self call:@"userGetSongsInLibrary" withParams:params withClient:GROOVY_GSLITE];
	 */	
}
- (void)songsInPlayList:(NSInteger)playlistID callback:(void(^)(NSArray *songs))callback {
	
	NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d", playlistID] ,@"playlistID", nil];
	
	
	dispatch_async(dispatch_get_global_queue(0, 0), ^ {
		NSDictionary *response = [self call:@"playlistGetSongs" withParams:params withClient:GROOVY_GSLITE];
		[params release];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			NSArray *results = [[NSArray alloc] initWithArray:[[response objectForKey:@"result"] objectForKey:@"Songs"]];
			NSMutableArray *songs = [[NSMutableArray alloc] init];
			[songs removeAllObjects];
			
			for (NSDictionary *song in results) {
				SongAsset *songAsset = [[SongAsset alloc] initWithDictionary:song];
				[songs addObject:songAsset];
				[songAsset release];
				
				
			}
			[results release];
			
			callback(songs);
		});
	});

}

- (void)popularSongsToday {
	/*
	NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys: nil];
	NSDictionary *response = [self call:@"popularGetSongs" withParams:params withClient:GROOVY_GSLITE];
	*/
	
}
- (void)popularSongsMonth {
	
	/*
	NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:@"monthly",@"type", nil];
	NSDictionary *response = [self call:@"popularGetSongs" withParams:params withClient:GROOVY_GSLITE];
	*/
}

- (void)favoritesSongs {
	/*
	NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:@"",@"userID",@"Songs",@"ofWhat", nil];
	NSDictionary *response = [self call:@"getFavorites" withParams:params withClient:GROOVY_GSLITE];
	*/
}
- (void)favoritesPlaylists {
	/*
	NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:@"",@"userID",@"Playlists",@"ofWhat", nil];
	NSDictionary *response = [self call:@"getFavorites" withParams:params withClient:GROOVY_GSLITE];
	*/
}
- (void)favoritesUser {
	/*
	NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:@"",@"userID",@"Users",@"ofWhat", nil];
	NSDictionary *response = [self call:@"getFavorites" withParams:params withClient:GROOVY_GSLITE];
	*/
	
}
- (void)playlists:(void(^)(NSArray *playlists))callback {
	NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d", self.user.userID] ,@"userID",nil];
	dispatch_async(dispatch_get_global_queue(0, 0), ^ {
		NSDictionary *response = [self call:@"userGetPlaylists" withParams:params withClient:GROOVY_GSLITE];
		[params release];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			
			NSArray *results = [[NSArray alloc] initWithArray:[[response objectForKey:@"result"] objectForKey:@"Playlists"]];
			NSMutableArray *lists = [[NSMutableArray alloc] init];
			[lists removeAllObjects];
			
			for (NSDictionary *list in results) {
				Playlist *playlist = [[Playlist alloc] initWithJSONDict:list];
				[lists addObject:playlist];
				[playlist release];
				
				
			}
			[results release];
			callback(lists);
		});
	});
	
	return nil;
}
- (void)createPlaylistWith:(NSString *)name description:(NSString *)description callback:(void (^)(NSInteger playlistID))callback  {

	NSArray *songs = [[NSArray alloc] init];
	
	NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:description,@"playlistAbout",
																			      name, @"playlistName",
																				   songs, @"songIDs",
																				   nil];
	[songs release];
	
	dispatch_async(dispatch_get_global_queue(0, 0), ^ {
		NSDictionary *response = [self call:@"createPlaylist" withParams:params withClient:GROOVY_GSLITE];
		[params release];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			
			NSInteger playlistID = [[response objectForKey:@"result"] intValue];
			callback(playlistID);
		});
	});

}

- (void)addSongToLibrary:(NSInteger)songID {
	
}
- (void)addSongToFavorites:(NSInteger)songID {
	//"parameters":{"ID":23206850,"what":"Song","
	// details":{"artistID":836,"albumName":"Paranoid","artistName":"Black Sabbath","songID":23206850,
	// "artFilename":"3096e8847d41b273ef77dd194d5eb6da.png","albumID":125519,"songName":"Paranoid"}},"method":"favorite"}
	
}
- (void)addSong:(SongAsset *)song toPlaylist:(Playlist *)playlist callback:(void (^)(BOOL status))callback {
	
	[self songsInPlayList:playlist.playlistID callback:^(NSArray *songs) {
		NSMutableArray *songArray = [[NSMutableArray alloc] init];
		for (SongAsset *theSong in songs) {
			[songArray addObject:(int)[theSong assetID]];
		}		
		[songArray addObject:(int)[song assetID]];
		
		NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d", playlist.playlistID], @"playlistID", songArray, @"songIDs",nil];
		[songArray release];
	
		
		dispatch_async(dispatch_get_global_queue(0, 0), ^ {
			NSDictionary *response = [self call:@"overwritePlaylist" withParams:params withClient:GROOVY_GSLITE];
			[params release];
			
			dispatch_async(dispatch_get_main_queue(), ^{
				BOOL result = [[response objectForKey:@"result"] boolValue];
				callback(result);
			});
		});
	}];
	
}

- (void)logoutUser {
	/*
	NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:nil];
	[self call:@"logoutUser" withParams:params withClient:GROOVY_GSLITE];
	*/
}


- (void)authenticate:(NSString *)username with:(NSString *)password callback:(void (^)(User *user))callback {
	NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:username,@"username",password, @"password",nil];
	dispatch_async(dispatch_get_global_queue(0, 0), ^ {
		NSDictionary *response = [self call:@"authenticateUser" withParams:params withClient:GROOVY_GSLITE];
		[params release];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			NSDictionary *result = [response objectForKey:@"result"];
			if([[result objectForKey:@"userID"] intValue] == 0){
				callback(nil);
			} else {
				User *user = [[User alloc] initWithJSONDict:result];
				self.user = user;
				callback(user);
			}

		});
	});
	
    
}
- (void)initiateSession:(void (^)(void))callback {
	
	NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:nil];
	
	dispatch_async(dispatch_get_global_queue(0, 0), ^ {
		NSDictionary *response = [self call:@"initiateSession" withParams:params withClient:GROOVY_JSPLAYER ];
		[params release];
		dispatch_async(dispatch_get_main_queue(), ^{
			self.session = [response objectForKey:@"result"];
			[self getCommunicationToken:callback];
		});
	});
	
  	
}
- (void)getCommunicationToken:(void (^)(void))callback {
    
	NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[self md5:self.session], @"secretKey", nil];
	dispatch_async(dispatch_get_global_queue(0, 0), ^ {
		NSDictionary *response = [self call:@"getCommunicationToken" withParams:params withClient:GROOVY_JSPLAYER];
		[params release];
		dispatch_async(dispatch_get_main_queue(), ^{
			self.communicationToken = [response objectForKey:@"result"];
			callback();
			
		});
	});
	
	[params release];
}
- (void)getSearchResults:(NSString *)searchString callback:(void (^)(NSArray *songs))callback {
	
	NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:searchString, @"query",  @"Songs", @"type", nil];
	
	dispatch_async(dispatch_get_global_queue(0, 0), ^ {
		NSDictionary *response = [self call:@"getSearchResultsEx" withParams:params withClient:GROOVY_GSLITE];
		[params release];
		dispatch_async(dispatch_get_main_queue(), ^{
			
			NSArray *results = [[NSArray alloc] initWithArray:[[response objectForKey:@"result"] objectForKey:@"result"]];
			NSMutableArray *songs = [[NSMutableArray alloc] init];
			[songs removeAllObjects];
			
			for (NSDictionary *song in results) {
				SongAsset *songAsset = [[SongAsset alloc] initWithDictionary:song];
				[songs addObject:songAsset];
				[songAsset release];
				
				
			}
			[results release];
			
			callback(songs);
			
		});
	});
	[params release];
	
}
- (void)getStreamUrlBySong:(SongAsset *)song callback:(void (^)(NSString *streamUrl))callback {
	
	NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:@"false", @"mobile",  
							[self country], @"country", 
							[song assetID], @"songID",
							@"false", @"prefetch", 
							nil];
	dispatch_async(dispatch_get_global_queue(0, 0), ^ {
		NSDictionary *response = [self call:@"getStreamKeyFromSongIDEx" withParams:params withClient:GROOVY_JSPLAYER];
		[params release];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			
			NSDictionary *dict = [response objectForKey:@"result"];
			
			NSString *streamURL = [NSString stringWithFormat:(NSString *)groovyURLstream,[dict objectForKey:@"ip"], [dict objectForKey:@"streamKey"]];
			callback(streamURL);
			
		});
	});
	
	[params release];
	
}
- (NSString *)getSynchronStreamUrlBySong:(SongAsset *)song {
	NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:@"false", @"mobile",  
							[self country], @"country", 
							[song assetID], @"songID",
							@"false", @"prefetch", 
							nil];
	NSDictionary *response = [self call:@"getStreamKeyFromSongIDEx" withParams:params withClient:GROOVY_JSPLAYER];
	[params release];
	NSDictionary *dict = [response objectForKey:@"result"];
	NSString *streamURL = [NSString stringWithFormat:(NSString *)groovyURLstream,[dict objectForKey:@"ip"], [dict objectForKey:@"streamKey"]];
	return streamURL;
}


#pragma mark -
#pragma mark (private) API Calls internals
- (NSDictionary *)country {
	NSDictionary *country = [[NSDictionary alloc] initWithObjectsAndKeys:@"55", @"ID",
							 @"0", @"CC4",
							 @"0", @"CC3",
							 @"0", @"CC2",
							 @"10215", @"IPR",
							 @"18014398509481984", @"CC1", nil];
	return [country autorelease];
}

- (NSDictionary *)call:(NSString *)method withParams:(NSDictionary *)params withClient:(int)clientIdentifer {

	NSString *client;
	NSString *clientRevision;
	NSDictionary *header;
	
	
	switch (clientIdentifer) {
		case GROOVY_JSPLAYER:
			client = @"jsplayer";
			clientRevision = @"20100831.12";
			break;
		case GROOVY_GSLITE:
			client = @"gslite";
			clientRevision = @"20101012.14";
			break;
		default:
			client = @"";
			clientRevision = @"";
			break;
			
	}
	
	if([self.session length] == 0 || [self.communicationToken length] == 0) {
		
		header = [[NSDictionary alloc] initWithObjectsAndKeys:[self uuid], @"uuid",
				  @"0", @"privacy",
				  [self country], @"country",
				  clientRevision, @"clientRevision",
				  client, @"client", nil];	
	} else {
		header = [[NSDictionary alloc] initWithObjectsAndKeys:[self uuid], @"uuid",
				  @"0", @"privacy",
				  [self country], @"country",
				  clientRevision, @"clientRevision",
				  client, @"client",
				  self.session, @"session",
				  [self generateTokenFor:method], @"token", nil];
	}
	

	NSDictionary *request = [[NSMutableDictionary alloc] initWithObjectsAndKeys: header, @"header",
							 params, @"parameters",
							 method, @"method",nil];
	[header release];
	
	
	NSString *json = [request JSONRepresentation];

	
	NSURL *url = [NSURL URLWithString:(NSString *)groovyURLmore];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	
	NSString *msgLength = [NSString stringWithFormat:@"%d", [json length]];
	[theRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setHTTPBody:[json dataUsingEncoding:NSUTF8StringEncoding]];
	[theRequest setValue:msgLength forHTTPHeaderField:@"Content-Length"];
	[theRequest setTimeoutInterval:30.0];
	
	NSURLResponse *response;
	NSError *error;
	
	NSData *data = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
	NSString *returnString = [NSString stringWithCString:[data bytes] length:[data length]];

	return [returnString JSONValue];
	
}
- (NSString *)generateTokenFor:(NSString *)method {
	
	NSString *rand = [NSString stringWithFormat:@"%06X", (arc4random() % 16777216)];
	NSString *sha1Token = [self sha1:[NSString stringWithFormat:@"%@:%@:quitStealinMahShit:%@", method, self.communicationToken,rand]];
	NSString *sha1TokenComplete = [NSString stringWithFormat:@"%@%@", rand, sha1Token];
	return sha1TokenComplete;
}
- (NSString *)uuid {
	if(!uuid) {
		uuid = [[[NSProcessInfo processInfo] globallyUniqueString] substringToIndex:36];
	}
	return uuid;
	
}


@end
