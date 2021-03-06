//
//  VSThemeLoader.m
//  Q Branch LLC
//
//  Created by Brent Simmons on 6/26/13.
//  Copyright (c) 2012 Q Branch LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@class VSTheme;

@interface VSThemeLoader : NSObject

@property (nonatomic, strong, readonly) VSTheme *defaultTheme;
@property (nonatomic, strong, readonly) NSArray *themes;

- (VSTheme *)themeNamed:(NSString *)themeName;

- (void)loadThemesFromDictionary:(NSDictionary *)themesDictionary;		// Loads all themes new from given dictionary
- (void)loadThemeWithURL:(NSURL *)url;									// Loads all themes new from file URL (e.g. from a plist in /Documents)
- (void)copyDefaultThemeToURL:(NSURL *)url;								// Copies the default DB5.plist to a new location

@end
