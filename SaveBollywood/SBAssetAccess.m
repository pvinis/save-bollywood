/*
 SaveBollywood: helpers for media type checks and sandboxed file access.
 */

#import "SBAssetAccess.h"

#import <AVFoundation/AVFoundation.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

NSString * const SBUserDefaultsAssetsBookmarks=@"assets.bookmarks";

@implementation SBAssetAccess

+ (NSArray *)audiovisualContentTypes
{
	static NSArray * sContentTypes=nil;
	static dispatch_once_t sOnceToken;
	
	dispatch_once(&sOnceToken, ^{
		
		NSMutableArray * tMutableArray=[NSMutableArray array];
		
		for(NSString * tIdentifier in [AVURLAsset audiovisualTypes])
		{
			UTType * tType=[UTType typeWithIdentifier:tIdentifier];
			
			if (tType!=nil)
				[tMutableArray addObject:tType];
		}
		
		sContentTypes=[tMutableArray copy];
	});
	
	return sContentTypes;
}

+ (BOOL)isAudiovisualFileAtURL:(NSURL *)inURL
{
	if (inURL==nil)
		return NO;
	
	UTType * tContentType=nil;
	
	if ([inURL getResourceValue:&tContentType forKey:NSURLContentTypeKey error:NULL]==NO || tContentType==nil)
		return NO;
	
	for(UTType * tType in [SBAssetAccess audiovisualContentTypes])
	{
		if ([tContentType conformsToType:tType]==YES)
			return YES;
	}
	
	return NO;
}

+ (BOOL)isAudiovisualFileAtPath:(NSString *)inPath
{
	if (inPath==nil)
		return NO;
	
	return [SBAssetAccess isAudiovisualFileAtURL:[NSURL fileURLWithPath:inPath]];
}

#pragma mark -

+ (NSDictionary *)bookmarksForPaths:(NSArray *)inPaths previousBookmarks:(NSDictionary *)inPreviousBookmarks
{
	NSMutableDictionary * tMutableDictionary=[NSMutableDictionary dictionary];
	
	for(NSString * tPath in inPaths)
	{
		NSError * tError=nil;
		NSURL * tURL=[NSURL fileURLWithPath:tPath];
		
		NSData * tData=[tURL bookmarkDataWithOptions:NSURLBookmarkCreationWithSecurityScope|NSURLBookmarkCreationSecurityScopeAllowOnlyReadAccess
					  includingResourceValuesForKeys:nil
									   relativeToURL:nil
											   error:&tError];
		
		if (tData==nil)
		{
			NSLog(@"SaveBollywood: no security-scoped bookmark for \"%@\": %@",tPath,tError);
			
			tData=inPreviousBookmarks[tPath];
		}
		
		if ([tData isKindOfClass:[NSData class]]==YES)
			tMutableDictionary[tPath]=tData;
	}
	
	return [[tMutableDictionary copy] autorelease];
}

+ (NSArray *)startAccessingBookmarks:(NSDictionary *)inBookmarks
{
	NSMutableArray * tMutableArray=[NSMutableArray array];
	
	if ([inBookmarks isKindOfClass:[NSDictionary class]]==NO)
		return tMutableArray;
	
	for(NSString * tPath in inBookmarks)
	{
		NSData * tData=inBookmarks[tPath];
		
		if ([tData isKindOfClass:[NSData class]]==NO)
			continue;
		
		NSError * tError=nil;
		BOOL tIsStale=NO;
		
		NSURL * tURL=[NSURL URLByResolvingBookmarkData:tData
											   options:NSURLBookmarkResolutionWithSecurityScope|NSURLBookmarkResolutionWithoutUI|NSURLBookmarkResolutionWithoutMounting
										 relativeToURL:nil
								   bookmarkDataIsStale:&tIsStale
												 error:&tError];
		
		if (tURL==nil)
		{
			NSLog(@"SaveBollywood: unable to resolve bookmark for \"%@\": %@",tPath,tError);
			continue;
		}
		
		if ([tURL startAccessingSecurityScopedResource]==YES)
			[tMutableArray addObject:tURL];
	}
	
	return tMutableArray;
}

+ (void)stopAccessingURLs:(NSArray *)inURLs
{
	for(NSURL * tURL in inURLs)
		[tURL stopAccessingSecurityScopedResource];
}

@end
