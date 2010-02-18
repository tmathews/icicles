//
//  GameOverBanner.m
//  Icicles
//
//  Created by Thomas Mathews on 10-12-11.
//  Copyright 2010 Interactive TM. All rights reserved.
//

#import "GameOverBanner.h"


@implementation GameOverBanner

- (id)initBannerWithText:(NSString *)string {
	if ( (self = [super init]) ) {
		banner = [[CCSprite alloc] initWithFile:@"game-over-banner.png"];
		[banner.texture setAliasTexParameters];
		
		text = [CCLabelTTF labelWithString:string fontName:@"04B_25.ttf" fontSize:24];
		[text.texture setAliasTexParameters];
		[text setColor:ccc3(161, 68, 21)];
		[text setPosition:CGPointMake(0, -10)];
		
		[self addChild:banner];
		[self addChild:text];
	}
	return self;
}

- (void)setBannerText:(NSString *)string {
	NSString *upperCaseString = [string uppercaseString];
	[text setString:upperCaseString];
}

+ (NSString *)getBannerTextForScore:(int)score {
	NSString *string;
	
	if ( score == 0 ) {
		string = @"PAATHETIC! Mah Gran'Papy can last longer!";
	} else if ( score > 1000 ) {
		string = [NSString stringWithFormat:@"%i! You almost made it out!", score];
	} else if ( score > 800 ) {
		string = [NSString stringWithFormat:@"%i - You'll be a master soon enough.", score];
	} else if ( score > 600 ) {
		string = [NSString stringWithFormat:@"%im under ice!", score];
	} else if ( score > 400 ) {
		string = [NSString stringWithFormat:@"Must construct more than %i Icicles", score];
	} else if ( score > 300 ) {
		string = [NSString stringWithFormat:@"%i Icicles. Better I suppose.", score];
	} else if ( score > 200 ) {
		string = [NSString stringWithFormat:@"%i... Thats your score?", score];
	} else if ( score > 100 ) {
		string = [NSString stringWithFormat:@"Penguins dodge more than %i Icicles.", score];
	} else if ( score > 50 ) {
		string = [NSString stringWithFormat:@"Must dodge moar than %i Icicles.", score];
	} else if ( score > 0 ) {
		string = [NSString stringWithFormat:@"%i Icicles? Weak Sauce.", score];
	}
	
	return string;
}

@end
