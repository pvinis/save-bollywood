
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SBMovieScaling)
{
	SBMovieScaleProportionallyUpOrDown=0,		// Scale movie to maximum possible dimensions while (1) staying within destination area (2) preserving aspect ratio
	SBMovieScaleAxesIndependently,				// Scale each dimension to exactly fit destination. Do not preserve aspect ratio.
	SBMovieScaleNone,							// Do not scale.
};

enum {
	kMovieFrameShowMetadataAtStart=0,
	kMovieFrameShowMetadataPeriodically
};

typedef NS_ENUM(NSUInteger, SBMovieAudioVolumeMode)
{
	SBMovieAudioVolumeNormal=0,
	SBMovieAudioVolumeMute,
	SBMovieAudioVolumeCustom
};

#define SBUserDefaultsFrameShowMetadataPeriodMinimumValue   15
#define SBUserDefaultsFrameShowMetadataPeriodMaximumValue   60

@interface SBSettings : NSObject

@property BOOL randomOrder;
@property BOOL startWhereLeftOff;

@property (retain) NSMutableArray * assets;

@property SBMovieScaling scaling;
@property BOOL randomPosition;

@property BOOL drawBorder;
@property BOOL showMetadata;
@property NSInteger showMetadataMode;
@property NSInteger showMetadataPeriod;

@property (copy) NSColor * backgroundColor;

@property BOOL audioMainScreenOnly;
@property SBMovieAudioVolumeMode audioMode;
@property CGFloat audioVolume;

@property BOOL mainDisplayOnly;

+ (SBSettings *)settings;

+ (BOOL)isConfigurationLocked;

- (instancetype)initWithDictionaryRepresentation:(NSDictionary *)inDictionary;

- (NSDictionary *)dictionaryRepresentation;

- (void)resetSettings;



@end
