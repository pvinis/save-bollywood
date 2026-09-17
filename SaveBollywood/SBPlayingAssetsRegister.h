#import <Foundation/Foundation.h>

@interface SBPlayingAssetsRegister : NSObject

+ (SBPlayingAssetsRegister *)sharedRegister;

    @property (readonly,nonatomic) NSArray * allPlayingAssets;

- (BOOL)isPlayingAsset:(id)inAsset;

- (void)addAsset:(id)inAsset;
- (void)removeAsset:(id)inAsset;

@end
