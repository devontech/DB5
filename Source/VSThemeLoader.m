//
//  VSThemeLoader.m
//  Q Branch LLC
//
//  Created by Brent Simmons on 6/26/13.
//  Copyright (c) 2012 Q Branch LLC. All rights reserved.
//

#import "VSThemeLoader.h"
#import "VSTheme.h"


@interface VSThemeLoader ()

@property (nonatomic, strong, readwrite) VSTheme *defaultTheme;
@property (nonatomic, strong, readwrite) NSArray *themes;
@end


@implementation VSThemeLoader


- (id)init
{
	self = [super init];
	if (self == nil)
		return nil;
	
	NSString *themesFilePath = [self defaultThemePath];
	NSDictionary *themesDictionary = [NSDictionary dictionaryWithContentsOfFile:themesFilePath];
	[self loadThemesFromDictionary:themesDictionary];
	
	return self;
}

- (NSString *)defaultThemePath
{
	return [[NSBundle mainBundle] pathForResource:@"DB5" ofType:@"plist"];
}

- (void)copyDefaultThemeToURL:(NSURL *)url
{
	if (url.isFileURL)
	{
		NSString *themesFilePath = [self defaultThemePath];
		if (![[NSFileManager defaultManager] fileExistsAtPath:url.path isDirectory:NULL])
			[[NSFileManager defaultManager] copyItemAtPath:themesFilePath toPath:url.path error:nil];
	}
}

- (void)loadThemeWithURL:(NSURL *)url
{
	// Find out if default DB5.plist or the one pointed to by the URL is newer
	NSFileManager *defaultFileManager = [NSFileManager defaultManager];
	NSDictionary *attributesDefault = [defaultFileManager attributesOfItemAtPath:[self defaultThemePath] error:nil];
	NSDictionary *attributesToLoad = [defaultFileManager attributesOfItemAtPath:url.path error:nil];
	NSDate *modificationDateDefault = [attributesDefault objectForKey:NSFileModificationDate];
	NSDate *modificationDateToLoad = [attributesToLoad objectForKey:NSFileModificationDate];
	
	if ([modificationDateDefault timeIntervalSinceDate:modificationDateToLoad] < 0)
	{
		NSDictionary *themesDictionary = [NSDictionary dictionaryWithContentsOfURL:url];
		if (themesDictionary)
			[self loadThemesFromDictionary:themesDictionary];
	}
}

- (void)loadThemesFromDictionary:(NSDictionary *)themesDictionary
{
	NSMutableArray *themes = [NSMutableArray array];
	for (NSString *oneKey in themesDictionary)
	{
		VSTheme *theme = [[VSTheme alloc] initWithDictionary:themesDictionary[oneKey]];
		if ([[oneKey lowercaseString] isEqualToString:@"default"])
			_defaultTheme = theme;
		theme.name = oneKey;
		[themes addObject:theme];
	}
	
    for (VSTheme *oneTheme in themes) { /*All themes inherit from the default theme.*/
		if (oneTheme != _defaultTheme)
			oneTheme.parentTheme = _defaultTheme;
    }
    
	_themes = themes;
}

#pragma mark - Properties

- (VSTheme *)themeNamed:(NSString *)themeName
{
	for (VSTheme *oneTheme in self.themes)
	{
		if ([themeName isEqualToString:oneTheme.name])
			return oneTheme;
	}

	return nil;
}

@end

