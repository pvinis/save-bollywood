/*
 SaveBollywood: helpers for media type checks and sandboxed file access.
 */

#import <Foundation/Foundation.h>

extern NSString * const SBUserDefaultsAssetsBookmarks;

@interface SBAssetAccess : NSObject

// YES if the file at the URL is of a type AVFoundation can play

+ (BOOL)isAudiovisualFileAtURL:(NSURL *)inURL;

+ (BOOL)isAudiovisualFileAtPath:(NSString *)inPath;

// Security-scoped bookmarks
//
// The legacyScreenSaver host is sandboxed and can not show privacy prompts. A security-scoped bookmark created
// when the user picks or drops an asset in the configuration sheet lets the saver read it again later.

// Returns a dictionary (path -> bookmark data) for the paths. Bookmarks from inPreviousBookmarks are kept when a new one can not be created.

+ (NSDictionary *)bookmarksForPaths:(NSArray *)inPaths previousBookmarks:(NSDictionary *)inPreviousBookmarks;

// Resolves the bookmarks and starts accessing them. Returns the URLs to hand to -stopAccessingURLs: when done.

+ (NSArray *)startAccessingBookmarks:(NSDictionary *)inBookmarks;

+ (void)stopAccessingURLs:(NSArray *)inURLs;

@end
