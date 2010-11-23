//
//  AccountController.m
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


#import "AccountController.h"

@class User;

@implementation AccountController

@synthesize user;
@synthesize items;

#pragma mark -
#pragma mark init/dealoc


- (id)initWithUser:(User *)user {
	if((self = [super init]) != nil) {
		[self setListTitle:@"Account"];		
		self.user = user;
		[[self list] setDatasource:self];
		
		return self;
	}
	
	return self;
	
	
}
- (void)dealloc {
	[self.user dealloc];
	[self.items dealloc];
	[super dealloc];	
}

#pragma mark BRMediaMenuControllerDatasource
- (float)heightForRow:(long)row{
	return 0.0f;
}
- (long)itemCount {
	return 1;
}

- (id)itemForRow:(long)row {
	BRMenuItem * result;
	
	if(row == 0) {
		result = [[BRMenuItem alloc] init];
		[result setText:@"Logout" withAttributes:[[BRThemeInfo sharedTheme] menuItemTextAttributes]];
		[result addAccessoryOfType:0];
	}
	

	return result;
}
- (void)itemSelected:(long)selected; { 
	if (selected == 0) {
		NSString *path = [NSString stringWithString:[[NSBundle bundleForClass:[AccountController class]] pathForResource:@"Account" ofType:@"plist"]];
		NSMutableDictionary *account = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
		
		[account setObject:@"" forKey:groovyUsernameKey];
		[account setObject:@"" forKey:groovyPasswordKey];
		
		NSURL *url = [NSURL fileURLWithPath:path];
		[account writeToURL:url atomically:YES];
		[account release];
		
		[[self stack] swapController:[[self stack] rootController]];
	}

}
- (id)previewControlForItem:(long)item {	
	return nil;
}
- (BOOL)rowSelectable:(long)selectable {
	return YES;
}
- (id)titleForRow:(long)row {
	return nil;
}



@end
