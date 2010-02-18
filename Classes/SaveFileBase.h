//
//  SaveFileBase.h
//  Icicles
//
//  Created by Thomas Mathews on 11-01-12.
//  Copyright 2011 Interactive TM. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SaveFileBase : NSObject {
	NSMutableDictionary	*contents;
}

@property (nonatomic, retain) NSMutableDictionary *contents;

- (void)saveSettings;

@end