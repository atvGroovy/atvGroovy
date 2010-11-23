//
//  PlayerMenuController.m
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


#import "PlayerMenuController.h"

#define PLAYER_SEARCH @"Search"


@implementation PlayerMenuController
#pragma mark -

@synthesize user;
@synthesize isConnected;
@synthesize account;

#pragma mark -
#pragma mark init/dealloc
- (id)init {
	if((self = [super init]) != nil) {

		[self setListTitle:@"Groovy Player"];
	
		BRImage *sp = [BRImage imageWithPath:[[NSBundle bundleForClass:[PlayerMenuController class]] pathForResource:@"groovy" ofType:@"png"]];
		
		[self setListIcon:sp horizontalOffset:0.0 kerningFactor:0.15];
		
		
		
		_names = [[NSMutableArray alloc] init];
		self.isConnected = NO;

		[_names addObject:PLAYER_SEARCH];
		
		if(self.user == nil) {
			[_names addObject:@"Login"];
		} else {
			[_names addObject:self.user.username];
		}

	
		NSString *path = [[NSBundle bundleForClass:[PlayerMenuController class]] pathForResource:@"Account" ofType:@"plist"];
		
		self.account = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
		
		
		[[self list] setDatasource:self];
		
		return ( self );
		
	}
	
	return ( self );
}
- (void)reload {
	[_names removeAllObjects];
	[_names addObject:PLAYER_SEARCH];
	
	if(self.user == nil) {
		[_names addObject:@"Login"];
	} else {
		[_names addObject:@"Playlists"];
		//[_names addObject:@"My Music"];
		//[_names addObject:@"Favorites"];
		[_names addObject:self.user.username];
	}
}
- (void)dealloc {
	[_names release];
	[self.user dealloc];
	[self.account dealloc];
	[super dealloc];
}
- (void)wasPushed {
	
	if(self.isConnected == NO) {
		BRTextWithSpinnerController *spinner = [[BRTextWithSpinnerController alloc] 
												initWithTitle:@"Connecting" 
												text:@"Connecting to Grooveshark"];
		[[self stack] pushController:spinner];
		[spinner release];
		Groovy *groovy = [Groovy sharedGroovy];
		[groovy initiateSession:^(void) {
			self.isConnected = YES;
	
			[self login];
		}];
	}
	
}
- (void)login {
	
	if([[self.account objectForKey:groovyUsernameKey] isEqualToString:@""]) {
		[[self stack] popController];
		return;
	}
	
	BRTextWithSpinnerController *spinner = [[BRTextWithSpinnerController alloc] 
											initWithTitle:@"Authen" 
											text:@"Authenticate.."];
	[[self stack] swapController:spinner];
	[spinner release];
	
	Groovy *groovy = [Groovy sharedGroovy];
	
	[groovy authenticate:[self.account objectForKey:groovyUsernameKey] with:[self.account objectForKey:groovyPasswordKey] callback:^(User *user) {
		if(user == nil) {
			BRAlertController *alert = [[BRAlertController alloc] initWithType:0 titled:@"" primaryText:@"Login failed" secondaryText:@"Username or Password are incorrect"];
		
			[[self stack] popController];
			[[self stack] swapController:alert];
			[alert release];
			
		} else {
			[[self stack] popController];
			NSURL *url = [NSURL fileURLWithPath:[[NSBundle bundleForClass:[PlayerMenuController class]] pathForResource:@"Account" ofType:@"plist"]];
			[self.account writeToURL:url atomically:YES];
			self.user = user;
			[self reload];
			[[self list] reload];
		}
	}];
	
}

#pragma mark -
#pragma mark BRTextEntryControllerDelegates
- (void)textDidEndEditing:(id)sender {
	
	NSString *thestatus= (NSString *)(CFPreferencesCopyAppValue((CFStringRef)@"status", kCFPreferencesCurrentApplication));
	
	Groovy *groovy = [Groovy sharedGroovy];
	
	if([thestatus isEqualToString:@"search"]) {
		
		BRTextWithSpinnerController *spinner = [[BRTextWithSpinnerController alloc] 
												initWithTitle:@"Searching" 
												text:[NSString stringWithFormat:@"Searching for %@..", [sender stringValue]]];
		[[self stack] swapController:spinner];
		[spinner release];
		[groovy getSearchResults:[sender stringValue] callback:^(NSArray *songs) {
			SongListController *resultList = [[SongListController alloc] initWithSongs:songs title:@"Search result"];
			[[self stack] swapController:resultList];	
			[resultList release];
		}];
		
	} else if ([thestatus isEqualToString:@"login-username"]) {
		
		[self.account setObject:[sender stringValue] forKey:groovyUsernameKey];
		
		CFPreferencesSetAppValue(CFSTR("status"), (CFStringRef)[NSString stringWithString:@"login-password"],kCFPreferencesCurrentApplication);
		
		
		BRTextEntryController *entry = [BRTextEntryController alloc];
		[entry setShowUserEnteredText:NO];
		[entry initWithTextEntryStyle:1];
		[entry setTitle:@"Login"];
		
		[entry setTextEntryTextFieldLabel:@"Password"];
		
		[entry setTextFieldDelegate:self];
		[[self stack] swapController:entry];
		[entry release];
		
	} else if ([thestatus isEqualToString:@"login-password"]) {
		
		[self.account setObject:[sender stringValue] forKey:groovyPasswordKey];
		
		[self login];
		
	}

}
#pragma mark -
#pragma mark BRMediaMenuControllerDatasource
- (id)previewControlForItem:(long)item {
	NSString *currentObject = [_names objectAtIndex:item];
	
	if([currentObject isEqualToString:@"Login"]) {
		BRImage *theImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[PlayerMenuController class]] pathForResource:@"login" ofType:@"png"]];
		BRImageAndSyncingPreviewController *obj = [[BRImageAndSyncingPreviewController alloc] init];
		[obj setImage:theImage];
		return (obj);
	} else if([currentObject isEqualToString:@"Playlists"]) {
		BRImage *theImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[PlayerMenuController class]] pathForResource:@"music" ofType:@"png"]];
		BRImageAndSyncingPreviewController *obj = [[BRImageAndSyncingPreviewController alloc] init];
		[obj setImage:theImage];
		return (obj);
	} else if([currentObject isEqualToString:@"Search"]) {
		BRImage *theImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[PlayerMenuController class]] pathForResource:@"search" ofType:@"png"]];
		BRImageAndSyncingPreviewController *obj = [[BRImageAndSyncingPreviewController alloc] init];
		[obj setImage:theImage];
		return (obj);
	} else if([currentObject isEqualToString:@"My Music"]) {
		BRImage *theImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[PlayerMenuController class]] pathForResource:@"music" ofType:@"png"]];
		BRImageAndSyncingPreviewController *obj = [[BRImageAndSyncingPreviewController alloc] init];
		[obj setImage:theImage];
		return (obj);
	} else if([currentObject isEqualToString:@"Favorites"]) {
		BRImage *theImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[PlayerMenuController class]] pathForResource:@"favorite" ofType:@"png"]];
		BRImageAndSyncingPreviewController *obj = [[BRImageAndSyncingPreviewController alloc] init];
		[obj setImage:theImage];
		return (obj);
	} else {
		BRImage *theImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[PlayerMenuController class]] pathForResource:@"groovy" ofType:@"png"]];
		BRImageAndSyncingPreviewController *obj = [[BRImageAndSyncingPreviewController alloc] init];
		[obj setImage:theImage];
		return (obj);
	}
	
}

- (void)itemSelected:(long)selected {
	
	NSString *currentObject = [_names objectAtIndex:selected];
	
	if([currentObject isEqualToString:PLAYER_SEARCH]) {
		
		CFPreferencesSetAppValue(CFSTR("status"), (CFStringRef)[NSString stringWithString:@"search"],kCFPreferencesCurrentApplication);
		
		BRTextEntryController *entry = [BRTextEntryController alloc];
		[entry initWithTextEntryStyle:1];
		[entry setTitle:@"Search"];
		[entry setTextEntryTextFieldLabel:@"Search"];
		[entry setSecondaryInfoText:@"Search for a song, artist or album"];
		[entry setTextFieldDelegate:self];
		
		[[self stack] pushController:entry];
		[entry release];
		
	} else if ([currentObject isEqualToString:@"Login"]) {
		
		CFPreferencesSetAppValue(CFSTR("status"), (CFStringRef)[NSString stringWithString:@"login-username"],kCFPreferencesCurrentApplication);
		
		BRTextEntryController *entry = [BRTextEntryController alloc];
		[entry initWithTextEntryStyle:1];
		[entry setTitle:@"Login"];
		
		[entry setTextEntryTextFieldLabel:@"Username"];
		[entry setTextFieldDelegate:self];
		[[self stack] pushController:entry];
		[entry release];
	
	} else if ([currentObject isEqualToString:@"Playlists"]) {
		Groovy *groovy = [Groovy sharedGroovy];
		[groovy playlists:^(NSArray *playlists) {
			
			PlaylistController *playlistController = [[PlaylistController alloc] initWithLists:playlists];
			[[self stack] pushController:playlistController];	
			[playlistController release];
			
		}];
	} else if ([currentObject isEqualToString:self.user.username]) {
		AccountController *accountController = [[AccountController alloc] initWithUser:self.user];
		[[self stack] pushController:accountController];
		[accountController release];
	}
}
- (float)heightForRow:(long)row {
	return 0.0f;
}

- (long)itemCount {
	return [_names count];
}

- (id)itemForRow:(long)row {
	if(row > [_names count])
		return nil;
	
	BRMenuItem * result = [[BRMenuItem alloc] init];
	NSString *theTitle = [_names objectAtIndex:row];
	[result setText:theTitle withAttributes:[[BRThemeInfo sharedTheme] menuItemTextAttributes]];

	[result addAccessoryOfType:1];
	
	return result;
}

- (BOOL)rowSelectable:(long)selectable {
	return TRUE;
}
- (id)titleForRow:(long)row {
	return [_names objectAtIndex:row];
}

@end
