
#import "SBSettings.h"

#ifndef __TEST_SCREENSAVER__
#import <ScreenSaver/ScreenSaver.h>
#endif

#import "NSColor+String.h"

NSString * const SBUserDefaultsAssetsRandomOrder=@"assets.randomOrder";
NSString * const SBUserDefaultsAssetsStartWhereLeftOff=@"assets.startWhereLeftOff";
NSString * const SBUserDefaultsAssetsLibrary=@"assets.library";

NSString * const SBUserDefaultsFrameScaling=@"frame.scaling";
NSString * const SBUserDefaultsFrameRandomPosition=@"frame.randomPosition";

NSString * const SBUserDefaultsFrameDrawBorder=@"frame.drawBorder";
NSString * const SBUserDefaultsFrameShowMetadata=@"frame.showMetadata";
NSString * const SBUserDefaultsFrameShowMetadataMode=@"frame.showMetadata.mode";
NSString * const SBUserDefaultsFrameShowMetadataPeriod=@"frame.showMetadata.period";


NSString * const SBUserDefaultsBackgroundColor=@"frame.background.color";

NSString * const SBUserDefaultsAudioMainDisplayOnly=@"movie.audio.mainDisplayOnly";

NSString * const SBUserDefaultsMovieVolumeMode=@"movie.volume.mode";

NSString * const SBUserDefaultsMovieVolumeCustomValue=@"movie.volume.value";

NSString * const SBUserDefaultsMainDisplayOnly=@"screen.mainDisplayOnly";

NSString * const SBSharedLockUserDefaultsRepresentationPath=@"/Library/Preferences/com.pvinis.SaveBollywood.locked.plist";

static BOOL sSettingsAreLocked=NO;

@implementation SBSettings

+ (SBSettings *)settings
{
	NSDictionary * tRepresentation=[NSDictionary dictionaryWithContentsOfFile:SBSharedLockUserDefaultsRepresentationPath];
	
	if (tRepresentation==nil)
	{
		sSettingsAreLocked=NO;
		
#ifdef __TEST_SCREENSAVER__
		NSUserDefaults *tDefaults = [NSUserDefaults standardUserDefaults];
#else
		NSString *tIdentifier = [[NSBundle bundleForClass:[self class]] bundleIdentifier];
		ScreenSaverDefaults *tDefaults = [ScreenSaverDefaults defaultsForModuleWithName:tIdentifier];
#endif
	
		tRepresentation=[tDefaults dictionaryRepresentation];
	}
	else
	{
		sSettingsAreLocked=YES;
	}
	
	return [[[SBSettings alloc] initWithDictionaryRepresentation:tRepresentation] autorelease];
}

+ (BOOL)isConfigurationLocked
{
	return [[NSFileManager defaultManager] fileExistsAtPath:SBSharedLockUserDefaultsRepresentationPath];
}

- (instancetype)initWithDictionaryRepresentation:(NSDictionary *)inDictionary
{
	self=[super init];
	
	if (self!=nil)
	{
		id tValue=inDictionary[SBUserDefaultsAssetsRandomOrder];
		
		if (tValue==nil)
		{
			[self resetSettings];
		}
		else
		{
			_randomOrder=[inDictionary[SBUserDefaultsAssetsRandomOrder] boolValue];
			_startWhereLeftOff=[inDictionary[SBUserDefaultsAssetsStartWhereLeftOff] boolValue];
			
			NSArray * tArray=inDictionary[SBUserDefaultsAssetsLibrary];
			
			if (tArray==nil)
				tArray=@[];
			
			_assets=[tArray mutableCopy];
			
			_scaling=[inDictionary[SBUserDefaultsFrameScaling] integerValue];
			_randomPosition=[inDictionary[SBUserDefaultsFrameRandomPosition] boolValue];
			
			_drawBorder=[inDictionary[SBUserDefaultsFrameDrawBorder] boolValue];
			_showMetadata=[inDictionary[SBUserDefaultsFrameShowMetadata] boolValue];
			_showMetadataMode=[inDictionary[SBUserDefaultsFrameShowMetadataMode] integerValue];
			_showMetadataPeriod=[inDictionary[SBUserDefaultsFrameShowMetadataPeriod] integerValue];
			
			NSString * tString=inDictionary[SBUserDefaultsBackgroundColor];;
			
			if (tString!=nil)
				_backgroundColor=[[NSColor colorFromString:tString] copy];
			
			if (_backgroundColor==nil)
				_backgroundColor=[NSColor blackColor];
			
			_audioMainScreenOnly=[inDictionary[SBUserDefaultsAudioMainDisplayOnly] boolValue];
			_audioMode=[inDictionary[SBUserDefaultsMovieVolumeMode] integerValue];
			_audioVolume=[inDictionary[SBUserDefaultsMovieVolumeCustomValue] integerValue];
			
			
			_mainDisplayOnly=[inDictionary[SBUserDefaultsMainDisplayOnly] boolValue];
		}
		
		return self;
	}
	
	return nil;
}

- (NSDictionary *)dictionaryRepresentation
{
	NSMutableDictionary * tMutableDictionary=[NSMutableDictionary dictionary];
	
	if (tMutableDictionary!=nil)
	{
		tMutableDictionary[SBUserDefaultsAssetsRandomOrder]=@(self.randomOrder);
		tMutableDictionary[SBUserDefaultsAssetsStartWhereLeftOff]=@(self.startWhereLeftOff);
		
		tMutableDictionary[SBUserDefaultsAssetsLibrary]=[[self.assets copy] autorelease];
		
		tMutableDictionary[SBUserDefaultsFrameScaling]=@(self.scaling);
		tMutableDictionary[SBUserDefaultsFrameRandomPosition]=@(self.randomPosition);
		
		tMutableDictionary[SBUserDefaultsFrameDrawBorder]=@(self.drawBorder);
		tMutableDictionary[SBUserDefaultsFrameShowMetadata]=@(self.showMetadata);
		tMutableDictionary[SBUserDefaultsFrameShowMetadataMode]=@(self.showMetadataMode);
		tMutableDictionary[SBUserDefaultsFrameShowMetadataPeriod]=@(self.showMetadataPeriod);
		
		tMutableDictionary[SBUserDefaultsBackgroundColor]=[self.backgroundColor stringValue];
		
		tMutableDictionary[SBUserDefaultsAudioMainDisplayOnly]=@(self.audioMainScreenOnly);
		tMutableDictionary[SBUserDefaultsMovieVolumeMode]=@(self.audioMode);
		tMutableDictionary[SBUserDefaultsMovieVolumeCustomValue]=@(self.audioVolume);
		
		tMutableDictionary[SBUserDefaultsMainDisplayOnly]=@(self.mainDisplayOnly);
	}
	
	return [tMutableDictionary copy];
}

- (void)resetSettings
{
	self.randomOrder=NO;
	self.startWhereLeftOff=NO;
	
	self.assets=[NSMutableArray array];
	
	self.scaling=SBMovieScaleProportionallyUpOrDown;
	self.randomPosition=NO;
	
	self.drawBorder=NO;
	self.showMetadata=NO;
	self.showMetadataMode=kMovieFrameShowMetadataAtStart;
	self.showMetadataPeriod=SBUserDefaultsFrameShowMetadataPeriodMinimumValue;
	
	self.backgroundColor=[NSColor blackColor];
	
	self.audioMainScreenOnly=NO;
	self.audioMode=SBMovieAudioVolumeNormal;
	self.audioVolume=1.0;
	
	self.mainDisplayOnly=NO;
}

@end
