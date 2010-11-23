//
//  PlaylistController.m
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


#import "PlaylistController.h"
#import "SongAsset.h"

@implementation PlaylistController

@synthesize lists;
@synthesize type;
@synthesize song;

#pragma mark -
#pragma mark init/dealoc
- (id)init {
	if((self = [super init]) != nil) {
		[self setListTitle:@"Playlists"];
		[[self list] setDatasource:self];
		[[self list] addDividerAtIndex:1 withLabel:@"Your playlists"];
		return self;
	}
	
	return self;
}
- (id)initWithLists:(NSArray *)lists {
	self = [self init];
	self.lists = lists;
	self.type = GROOVY_PLAYLIST_PLAYSONG;
	return self;
}
- (id)initWithLists:(NSArray *)lists song:(SongAsset *)song {
	self = [self init];
	self.lists = lists;
	self.song = song;
	self.type = GROOVY_PLAYLIST_ADDSONG;
	return self;
}
- (void)dealloc {
	[self.lists dealloc];
	[super dealloc];
}
- (void)refresh {
	Groovy *groovy = [Groovy sharedGroovy];
	[groovy playlists:^(NSArray *playlists) {
		self.lists = playlists;
		[[self list] reload];
	}];
}

#pragma mark BRMediaMenuControllerDatasource
- (float)heightForRow:(long)row{
	return 0.0f;
}
- (long)itemCount {
	return [lists count] + 1;
}

- (id)itemForRow:(long)row {
	BRMenuItem * result;
	
	if(row == 0) {
		result = [[BRMenuItem alloc] init];
		[result setText:@"Create a playlist" withAttributes:[[BRThemeInfo sharedTheme] menuItemTextAttributes]];
		[result addAccessoryOfType:0];
	} else {
		Playlist *playlist = [self.lists objectAtIndex:row-1];
		
		result = [[BRMenuItem alloc] init];
		[result setText:playlist.name withAttributes:[[BRThemeInfo sharedTheme] menuItemTextAttributes]];
		[result addAccessoryOfType:0];
	}

	
	return result;
}
- (void)itemSelected:(long)selected; { 
	if(selected == 0) {
		CFPreferencesSetAppValue(CFSTR("status"), (CFStringRef)[NSString stringWithString:@"create"],kCFPreferencesCurrentApplication);
		
		BRTextEntryController *entry = [BRTextEntryController alloc];
		[entry initWithTextEntryStyle:1];
		[entry setTitle:@"Create a playlist"];
		[entry setTextEntryTextFieldLabel:@"Name"];
		[entry setSecondaryInfoText:@""];
		[entry setTextFieldDelegate:self];
		
		[[self stack] pushController:entry];
		[entry release];
		
		return;
	}
	
	selected-=1;
	if(self.type == GROOVY_PLAYLIST_PLAYSONG) {
		
		Playlist *playlist = [self.lists objectAtIndex:selected];
		Groovy *groovy = [Groovy sharedGroovy];
		
		BRTextWithSpinnerController *spinner = [[BRTextWithSpinnerController alloc] 
												initWithTitle:@"Searching" 
												text:@"Fetching songs..."];
		[[self stack] pushController:spinner];
		[spinner release];
		
		[groovy songsInPlayList:playlist.playlistID callback:^(NSArray *songs) {
			
			if([songs count] == 0) {
				BRAlertController *alert = [[BRAlertController alloc] initWithType:1 titled:@"" primaryText:@"No songs in playlist" secondaryText:@""];
				[[self stack] swapController:alert];
				[alert release];
				
			} else {
				SongListController *songlist = [[SongListController alloc] initWithSongs:songs title:[playlist name]];
				[[self stack] swapController:songlist];
				[songlist release];
			}
			
		}];	
	} else {
		Playlist *playlist = [self.lists objectAtIndex:selected];
		Groovy *groovy = [Groovy sharedGroovy];
		
		BRTextWithSpinnerController *spinner = [[BRTextWithSpinnerController alloc] 
												initWithTitle:@"Searching" 
												text:@"Add song to playlist.."];
		[[self stack] pushController:spinner];
		[spinner release];
		
		[groovy addSong:self.song toPlaylist:playlist callback:^(BOOL status) {
			if (status) {
				[[self stack] popController];
				[[self stack] popController];
			}
		}];
	}

}
- (id)previewControlForItem:(long)item {	
	
	BRMetadataPreviewControl *previewControl;
	if(item == 0) {
	
	} else {
		Playlist *playlist = [self.lists objectAtIndex:item-1];
		
		previewControl = [[BRMetadataPreviewControl alloc] init];
		BRMetadataControl *metadata = [previewControl metadataControl];
		previewControl.showsMetadataImmediately = YES;
		
		[metadata setAlignment:0];
		[metadata setTitle:playlist.name];
		[metadata setSummary:playlist.about];
		
	}
	
	return previewControl;
	
}
- (BOOL)rowSelectable:(long)selectable {
	return YES;
}
- (id)titleForRow:(long)row {
	return nil;
}


#pragma mark -
#pragma mark BRTextEntryControllerDelegates
- (void)textDidEndEditing:(id)sender {
	
	NSString *thestatus= (NSString *)(CFPreferencesCopyAppValue((CFStringRef)@"status", kCFPreferencesCurrentApplication));
	
	Groovy *groovy = [Groovy sharedGroovy];
	
	if([thestatus isEqualToString:@"create"]) {
		[groovy createPlaylistWith:[sender stringValue] description:@"" callback:^(NSInteger playlistID) {
			[self refresh];
			[[self stack] popController];
		}];
	}
	
}

@end
