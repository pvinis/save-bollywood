#import "SBPlayingAssetsRegister.h"

@interface SBPlayingAssetsRegister ()
{
    NSMutableSet * _playingAssetsSet;
    
    NSLock * _lock;
}

@end

@implementation SBPlayingAssetsRegister

+ (SBPlayingAssetsRegister *)sharedRegister
{
    static SBPlayingAssetsRegister * sPlayingAssetsRegister=nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sPlayingAssetsRegister=[SBPlayingAssetsRegister new];
    });
    
    return sPlayingAssetsRegister;
}

- (instancetype)init
{
    self=[super init];
    
    if (self!=nil)
    {
        _playingAssetsSet=[[NSMutableSet alloc] init];
        
        _lock=[NSLock new];
    }
    
    return self;
}

#pragma mark -

- (NSArray *)allPlayingAssets
{
    NSArray * tAllPlayingAssets=[NSArray array];
    
    [_lock lock];
    
    tAllPlayingAssets=[_playingAssetsSet allObjects];
    
    [_lock unlock];
    
    return tAllPlayingAssets;
}

#pragma mark -

- (BOOL)isPlayingAsset:(id)inAsset
{
    if (inAsset==nil)
        return NO;
    
    BOOL tIsPlaying=NO;
    
    [_lock lock];
    
    tIsPlaying=[_playingAssetsSet containsObject:inAsset];
    
    [_lock unlock];
    
    return tIsPlaying;
}

- (void)addAsset:(id)inAsset
{
    if (inAsset==nil)
        return;
    
    [_lock lock];
    
    [_playingAssetsSet addObject:inAsset];
    
    [_lock unlock];
}

- (void)removeAsset:(id)inAsset
{
    if (inAsset==nil)
        return;
    
    [_lock lock];
    
    [_playingAssetsSet removeObject:inAsset];
    
    [_lock unlock];
}

@end
