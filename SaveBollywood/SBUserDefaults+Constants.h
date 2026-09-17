/*
 Copyright (c) 2012-2024, Stephane Sudre
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 - Neither the name of the WhiteBox nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <Foundation/Foundation.h>

extern NSString * const SBUserDefaultsAssetsRandomOrder;
extern NSString * const SBUserDefaultsAssetsStartWhereLeftOff;
extern NSString * const SBUserDefaultsAssetsLibrary;


enum {
    kMovieFrameSizeToFit=0,
    kMovieFrameSizeToFill,
    kMovieFrameActualSize
};

extern NSString * const SBUserDefaultsFrameScaling;
extern NSString * const SBUserDefaultsFrameRandomPosition;

extern NSString * const SBUserDefaultsFrameDrawBorder;
extern NSString * const SBUserDefaultsFrameShowMetadata;

enum {
    kMovieFrameShowMetadataAtStart=0,
    kMovieFrameShowMetadataPeriodically
};

extern NSString * const SBUserDefaultsFrameShowMetadataMode;

#define SBUserDefaultsFrameShowMetadataPeriodMinimumValue   15
#define SBUserDefaultsFrameShowMetadataPeriodMaximumValue   60

extern NSString * const SBUserDefaultsFrameShowMetadataPeriod;

extern NSString * const SBUserDefaultsBackgroundColor;

extern NSString * const SBUserDefaultsAudioMainDisplayOnly;

enum {
    kMovieVolumeNormal=0,
    kMovieVolumeMute,
    kMovieVolumeCustom
};

extern NSString * const SBUserDefaultsMovieVolumeMode;
extern NSString * const SBUserDefaultsMovieVolumeCustomValue; 

extern NSString * const SBUserDefaultsMainDisplayOnly;
