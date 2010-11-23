//
//  SongAsset.m
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

#import "SongAsset.h"
#import "BackRow/BRBaseMediaAsset.h"
#import <BackRow/BRImageManager.h>
#import "BackRow/BRMediaAsset.h"


@implementation SongAsset

@synthesize json, songURL;

- (id)initWithDictionary:(NSDictionary *)jsonDict{
	self = [super init];
	self.json = jsonDict;
	return self;
}
- (void)dealloc {
	[self.json release];
	[self.songURL release];
}

#pragma mark BRMediaPreviewFactoryDelegate

- (BOOL)mediaPreviewShouldShowMetadata{ 
	return YES;
}
- (BOOL)mediaPreviewShouldShowMetadataImmediately{ 
	return YES;
}


#pragma mark BRMediaAsset
- (id)provider {
	return nil;
}


- (id)assetID {
	return [json objectForKey:@"SongID"];
};
- (id)titleForSorting {
	
	if(![json objectForKey:@"SongName"]) {
		return [json objectForKey:@"Name"];
	}
	
	return [json objectForKey:@"SongName"];
};

-(id)title {

	if(![json objectForKey:@"SongName"]) {
		return [json objectForKey:@"Name"];
	}
	return [json objectForKey:@"SongName"];
}

- (id)artist {
	return [json objectForKey:@"ArtistName"];
};
- (id)artistForSorting {
	return [json objectForKey:@"ArtistName"];
};

- (id)AlbumName {
	return [json objectForKey:@"AlbumName"];
};

- (id)AlbumID {
	return [json objectForKey:@"AlbumID"];
}

- (id)TrackNum {
	return [json objectForKey:@"TrackNum"];
};
- (id)composer {
	return nil;
};
- (id)composerForSorting {
	return nil;
};
- (id)copyright {
	return nil;
};
- (void)setUserStarRating:(float)fp8 {
	
};
- (float)starRating {
	return 4;
};
- (BOOL)isHD {
	return NO;
};
- (long)duration; {
	
	return (long)[[json objectForKey:@"EstimateDuration"] intValue];
}
- (BOOL)isWidescreen {
	return NO;
};
- (BOOL)closedCaptioned {
	return NO;
};
- (BOOL)dolbyDigital {
	return NO;
};
- (long)performanceCount {
	return 1;
};
- (void)incrementPerformanceCount {
	
};
- (void)incrementPerformanceOrSkipCount:(unsigned int)fp8 {
	
};
- (BOOL)hasBeenPlayed {
	return YES;
};
- (void)setHasBeenPlayed:(BOOL)fp8 {
	
};

- (id)previewURL {
	[super previewURL];
	NSString *coverURL = [NSString stringWithFormat:@"http://beta.grooveshark.com/static/amazonart/m%@", [json objectForKey:@"CoverArtFilename"]];
	return [[NSURL fileURLWithPath:coverURL] absoluteString];
};
- (id)trickPlayURL {
	return nil;
};
- (id)imageProxy {
	NSString *coverURL = [NSString stringWithFormat:@"http://beta.grooveshark.com/static/amazonart/m%@", [json objectForKey:@"CoverArtFilename"]];
	return [BRURLImageProxy proxyWithURL:[NSURL URLWithString:coverURL]];
};
- (id)imageProxyWithBookMarkTimeInMS:(unsigned int)fp8 {

	NSString *coverURL = [NSString stringWithFormat:@"http://beta.grooveshark.com/static/amazonart/m%@", [json objectForKey:@"CoverArtFilename"]];
	return [BRURLImageProxy proxyWithURL:[NSURL URLWithString:coverURL]];
};
- (BOOL)hasCoverArt {
	return YES;
};
- (BOOL)isProtectedContent {
	return NO;
};
- (id)playbackRightsOwner {
	return nil;
};
- (BOOL)isDisabled {
	return NO;
};
- (id)collections {
	return nil;
};
- (id)primaryCollection {
	return nil;
};
- (id)artistCollection {
	return nil;
};
- (id)primaryCollectionTitle {
	return [json objectForKey:@"AlbumName"];
};
- (id)primaryCollectionTitleForSorting {
	return nil;
};
- (int)primaryCollectionOrder {
	return 0;
};
- (int)physicalMediaID {
	return 0;
};
- (id)seriesName {
	return @"seriesName";
};
- (id)seriesNameForSorting {
	return nil;
};
- (id)broadcaster {
	return nil;
};

- (id)genres {
	return nil;
};
- (id)dateAcquired {
	return nil;
};
- (id)dateAcquiredString {
	return nil;
};
- (id)dateCreated {
	return nil;
};
- (id)dateCreatedString {
	return nil;
};
- (id)datePublishedString {
	return nil;
};
- (void)setBookmarkTimeInMS:(unsigned int)fp8 {
	
};
- (void)setBookmarkTimeInSeconds:(unsigned int)fp8 {
	
};
- (unsigned int)bookmarkTimeInMS {
	return 1;
};
- (unsigned int)bookmarkTimeInSeconds {
	return 1;
};
- (unsigned int)startTimeInMS {
	return 1;
};
- (unsigned int)startTimeInSeconds {
	return 1;
};
- (unsigned int)stopTimeInMS {
	return 1;
};
- (unsigned int)stopTimeInSeconds {
	return 1;
};
- (id)lastPlayed {
	return nil;
};
- (void)setLastPlayed:(id)fp8 {

};
- (id)resolution {
	return nil;
};
- (BOOL)canBePlayedInShuffle {
	return YES;
};
- (BOOL)isLocal {
	return NO;
};
- (BOOL)isAvailable {
	return YES;
};
- (void)skip {
	
};
- (id)authorName {
	return nil;
};
- (id)keywords {
	return nil;
};
- (id)viewCount {
	return nil;
};
- (id)category {
	return nil;
};
- (BOOL)isInappropriate; {
	return NO;
}
- (int)grFormat {
	return 1;
};
- (void)willBeDeleted {
	NSLog(@"willBeDeleted");
};
- (void)preparePlaybackContext
{
	NSLog(@"preparePlaybackContext");
};
- (void)cleanUpPlaybackContext {
	NSLog(@"cleanUpPlaybackContext");
};
- (long)parentalControlRatingSystemID {
	return 1;
};
- (long)parentalControlRatingRank {
	return 1;
};
- (BOOL)isExplicit {
	return NO;
};
- (BOOL)playable {
	return YES;
};
- (id)playbackMetadata {
	return nil;
};
/*
- (void *)createMovieWithProperties:(void *)fp8 count:(long)fp12 {
	NSLog(@"createMovieWithProperties");
};
 */
- (BOOL)isCheckedOut {
	return YES;
};
- (id)sourceID {
	return nil;
};
- (BOOL)isPlaying {
	return NO;
};
- (BOOL)isPlayingOrPaused {
	return NO;
};
- (id)publisher {
	return nil;
};
- (id)rating {
	return nil;
};
- (id)mediaDescription {
	return nil;
};
- (id)mediaSummary {
	return nil;
};
- (id)primaryGenre {
	return nil;
};
- (id)datePublished {
	return nil;
};
- (float)userStarRating {
	return 2;
};
- (id)cast {
	return nil;
};
- (id)directors {
	return nil;
};
- (id)producers {
	return nil;
};
- (BOOL)hasVideoContent {
	return NO;
};
- (id)mediaType {
	return [BRMediaType song];
};

- (id)mediaURL {
	// Need to fetch streamURL synchron
	// ui lags a bit but it works so far
	Groovy *groovy = [Groovy sharedGroovy];
	if ([self.songURL length] == 0) {
		self.songURL = [groovy getSynchronStreamUrlBySong:self];
	} 
	NSLog(@"media URL %@", self.songURL);
	return self.songURL;
	
}

#pragma mark BRImageProvider
- (NSString*)imageID{return nil;}
- (void)registerAsPendingImageProvider:(BRImageLoader*)loader {
	NSLog(@"registerAsPendingImageProvider");
}
- (void)loadImage:(BRImageLoader*)loader{ 
	NSLog(@"load Image");
}

@end