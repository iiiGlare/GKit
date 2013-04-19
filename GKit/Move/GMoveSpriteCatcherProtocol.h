//
//  GMoveSpriteCatcherProtocol.h
//  FreeMove
//
//  Created by Glare on 13-4-12.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

@class GMoveSnapshot;

#define GMoveSpriteCatcherProtocol() NSProtocolFromString(@"GMoveSpriteCatcherProtocol")

@protocol GMoveSpriteCatcherProtocol <NSObject>

@optional
//prepare
- (GMoveSnapshot *)prepareSnapshotForSprite:(UIView *)sprite;
- (void)didPrepareSnapshot:(GMoveSnapshot *)snapshot;
//moving snapshot
- (void)isCatchingSnapshot:(GMoveSnapshot *)snapshot;
//did finish
- (void)didCatchSnapshot:(GMoveSnapshot *)snapshot;

@end

