/*
 Copyright (c) 2026, Pavlos Vinieratos
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 - Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

// Helpers for media type checks and sandboxed file access

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
