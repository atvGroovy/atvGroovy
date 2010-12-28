//
//  GroovyAppliance.mm
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

#import "BackRowExtras.h"
#import "PlayerMenuController.h"
#import "AboutController.h"




#define PLAYER_ID @"player"
#define PLAYER_CAT [BRApplianceCategory categoryWithName:BRLocalizedString(@"Player", @"Player") identifier:PLAYER_ID preferredOrder:0]

#define ABOUT_ID @"about"
#define ABOUT_CAT [BRApplianceCategory categoryWithName:BRLocalizedString(@"About", @"About") identifier:ABOUT_ID preferredOrder:0]

#define PLAY_ID @"playnow"
#define PLAY_CAT [BRApplianceCategory categoryWithName:BRLocalizedString(@"Playing now", @"Playing now") identifier:PLAY_ID preferredOrder:0]



@interface BRTopShelfView (specialAdditions)

- (BRImageControl *)productImage;

@end


@implementation BRTopShelfView (specialAdditions)

- (BRImageControl *)productImage
{
	return MSHookIvar<BRImageControl *>(self, "_productImage");
}

@end


@interface TopShelfController : NSObject {
}
- (void)selectCategoryWithIdentifier:(id)identifier;
- (id)topShelfView;
- (void)refresh;
@end

@implementation TopShelfController

- (void)refresh{}
- (void)selectCategoryWithIdentifier:(id)identifier {
	
}
- (BRTopShelfView *)topShelfView {
	
	BRTopShelfView *topShelf = [[BRTopShelfView alloc] init];
	BRImageControl *imageControl = [topShelf productImage];
	BRImage *theImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[PlayerMenuController class]] pathForResource:@"groovy" ofType:@"png"]];
	[imageControl setImage:theImage];
	
	return topShelf;
}

@end

@interface GroovyAppliance: BRBaseAppliance {
	TopShelfController *_topShelfController;
	NSMutableArray *_applianceCategories;
}
@property(nonatomic, readonly, retain) id topShelfController;

@end


@implementation GroovyAppliance
@synthesize topShelfController = _topShelfController;

+ (void)initialize {
	
}


- (id)init {
	if((self = [super init]) != nil) {
		_topShelfController = [[TopShelfController alloc] init];
		_applianceCategories = [[NSMutableArray alloc] initWithObjects:PLAYER_CAT, ABOUT_CAT, nil];
		
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
		[nc addObserver:self selector:@selector(didPlaySong:) name:groovyPlayNotification object:nil];
		
		
	} return self;
}
- (void)didPlaySong:(NSNotification *)notification {
	SongAsset *song = [notification userInfo];
	
	[_applianceCategories removeAllObjects];
	[_applianceCategories addObject:PLAY_CAT];
	[_applianceCategories addObject:PLAYER_CAT];
	[_applianceCategories addObject:ABOUT_CAT];
	[self reloadCategories];
}
- (id)applianceCategories {
	return _applianceCategories;
}

- (id)identifierForContentAlias:(id)contentAlias {
	return @"Groovy";
}

- (id)selectCategoryWithIdentifier:(id)ident {
	return nil;
}

- (BOOL)handleObjectSelection:(id)fp8 userInfo:(id)fp12 {
	NSLog(@"handleObjectSelection");
	return YES;
}

- (id)applianceSpecificControllerForIdentifier:(id)arg1 args:(id)arg2 {
	
	return nil;
}

- (id)controllerForIdentifier:(id)identifier args:(id)args {
	id menuController = nil;
	
	if ([identifier isEqualToString:PLAYER_ID]) {
		menuController = [[PlayerMenuController alloc] init];
	} else if ([identifier isEqualToString:PLAY_ID]) {
		BRMediaPlayer *player = [[BRMediaPlayerManager singleton] activePlayer];
		if(player) {
			[[BRMediaPlayerManager singleton] presentPlayer:player options:nil];	
		}
		
		
	} else if ([identifier isEqualToString:ABOUT_ID]) {
		
		NSString *fullPath = [[NSBundle bundleForClass:[PlayerMenuController class]] pathForResource:@"ABOUT" ofType:@"txt"];
		NSString *text = [NSString stringWithContentsOfFile:fullPath];
		BRScrollingTextControl *scrollControl = [BRScrollingTextControl controlWithTitle:@"About" text:text firstButton:nil secondButton:nil thirdButton:nil defaultFocus:0];
		
		menuController = [AboutController controllerWithContentControl:scrollControl];
	}
	
	return menuController;
	
}

- (id)localizedSearchTitle { return @"Groovy"; }
- (id)applianceName { return @"Groovy"; }
- (id)moduleName { return @"Groovy"; }
- (id)applianceKey { return @"Groovy"; }

@end
