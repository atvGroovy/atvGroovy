//
//  SongListController.m
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


#import "SongListController.h"
#import "SongAsset.h"

@implementation SongListController

@synthesize songs;

#pragma mark -
#pragma mark init/dealoc
- (id)init {
	if((self = [super init]) != nil) {
		[self setListTitle:@"Search Result"];
		[[self list] setDatasource:self];
		[[self list] addDividerAtIndex:2 withLabel:@"Songlist"];
		return self;
	}
	
	return self;
}
- (id)initWithSongs:(NSArray *)songs title:(NSString *)title {
	self = [self init];
	[self setListTitle:title];
	self.songs = songs;
	return self;
}
- (void)dealloc {
	[self.songs dealloc];
	
	[super dealloc];
}

#pragma mark BRMediaMenuControllerDatasource
- (float)heightForRow:(long)row{
	return 0.0f;
}
- (long)itemCount {
	return [songs count] + 2;
}

- (id)itemForRow:(long)row {
	if(row == 0) {
		BRMenuItem * result = [[BRMenuItem alloc] init];
		[result setText:@"Play all" withAttributes:[[BRThemeInfo sharedTheme] menuItemTextAttributes]];
		[result addAccessoryOfType:0];
		return result;
	} else if (row == 1) {
		BRMenuItem * result = [[BRMenuItem alloc] init];
		[result setText:@"Shuffle" withAttributes:[[BRThemeInfo sharedTheme] menuItemTextAttributes]];
		[result addAccessoryOfType:0];
		return result;
	} else {
		SongAsset *song = [songs objectAtIndex:row-2];
		BRMenuItem * result = [[BRMenuItem alloc] init];
		[result setText:[song title] withAttributes:[[BRThemeInfo sharedTheme] menuItemTextAttributes]];
		[result addAccessoryOfType:0];
		return result;
	}
	
	
}
- (void)itemSelected:(long)selected; { 
	
	if(selected == 0) {
		// Play All
		[self playAtIndex:0 withArray:self.songs];
	} else if (selected == 1) {
		// Shuffle
		[self playAtIndex:0 withArray:[self.songs shuffledArray]];
	} else {
		// Selected Song
		BROptionDialog *option = [[BROptionDialog alloc] init];
		SongAsset *song = [self.songs objectAtIndex:(selected-2)];
		
		[option setUserInfo:[[NSDictionary alloc] initWithObjectsAndKeys:
																	[NSIndexPath indexPathWithIndex:(selected-2)], @"selected", 
																	song, @"song",
																	nil]];
		[option setPrimaryInfoText:@"Choose option"];
		[option setSecondaryInfoText:[NSString stringWithFormat:@"%@ - %@", [song title], [song artist]]];
		[option addOptionText:@"Play now"];
		[option addOptionText:@"Add to playlist"];
		[option addOptionText:@"Cancel"];
		[option setActionSelector:@selector(optionSelected:) target:self];
		[[self stack] pushController:option];
		[option release];
	}
	
}
- (void)optionSelected:(id)sender {
	BROptionDialog *option = sender;
	NSIndexPath *indexpath = [option.userInfo objectForKey:@"selected"];
	NSInteger selected = [indexpath indexAtPosition:0];
	SongAsset *song = [option.userInfo objectForKey:@"song"];
	
	if([[sender selectedText] isEqualToString:@"Play now"]) {
		[self playAtIndex:selected withArray:self.songs];
	} else if ([[sender selectedText] isEqualToString:@"Cancel"]) {
		[[self stack] popController];
	} else if ([[sender selectedText] isEqualToString:@"Add to playlist"]) {
		
		Groovy *groovy = [Groovy sharedGroovy];
		[groovy playlists:^(NSArray *playlists) {
			PlaylistController *playlistController = [[PlaylistController alloc] initWithLists:playlists song:song];
			[[self stack] swapController:playlistController];	
			[playlistController release];
		}];
		
	}
}
- (void)playAtIndex:(NSInteger)index withArray:(NSArray *)songs {
	BRTextWithSpinnerController *spinnerController = [[BRTextWithSpinnerController alloc] initWithTitle:@"Buffer" text:@"Getting Stream.."];
	[[self stack] pushController:spinnerController];
	[spinnerController release];
	
	SongAsset *song = [songs objectAtIndex:index];
	
	Groovy *groovy = [Groovy sharedGroovy];
	
	[groovy getStreamUrlBySong:song callback:^(NSString *streamUrl) {
		
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
		[nc postNotificationName:groovyPlayNotification object:song];
		
		song.songURL = streamUrl;
		
		[[self stack] popController];
		NSError *error;
		
		BRMediaPlayer *player = [[BRMediaPlayerManager singleton] playerForMediaAssetAtIndex:index inTrackList:songs error:&error];
		
		[[BRMediaPlayerManager singleton] presentPlayer:player options:nil];	
	}];	
} 
- (id)previewControlForItem:(long)item {	
	if(item == 0) {
		return nil;
	} else if (item == 1) {
		return nil;
	} else {
		SongAsset *song = [self.songs objectAtIndex:item - 2];
		
		BRMetadataPreviewControl *preview =[[BRMetadataPreviewControl alloc] init];
		[preview setShowsMetadataImmediately:YES];
		[preview setAsset:song];	
		
		return [preview autorelease];
	}
		
}
- (BOOL)rowSelectable:(long)selectable {
	return YES;
}
- (id)titleForRow:(long)row {
	return nil;
}



@end
