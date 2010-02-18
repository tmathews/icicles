//
//  SaveFileBase.m
//  Icicles
//
//  Created by Thomas Mathews on 11-01-12.
//  Copyright 2011 Interactive TM. All rights reserved.
//

#import "SaveFileBase.h"


@implementation SaveFileBase

@synthesize contents;

- (id)init {
	if ( (self = [super init]) ) {
		BOOL success;
		NSError *error;
		
		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"Settings.plist"];
		
		success = [fileManager fileExistsAtPath:filePath];
		if (!success) {		
			NSString *path = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
			success = [fileManager copyItemAtPath:path toPath:filePath error:&error];
		}
		
		contents = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
	}
	return self;
}

- (void)dealloc {
	[contents release];
	[super dealloc];
}

- (void)saveSettings {
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"Settings.plist"];
	
	if ( [fileManager fileExistsAtPath:filePath] ) [contents writeToFile:filePath atomically:YES];
}

@end
