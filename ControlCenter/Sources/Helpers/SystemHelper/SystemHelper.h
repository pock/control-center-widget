//
//  SystemHelper.h
//  Pock
//
//  Created by Pierluigi Galdi on 06/07/2019.
//  Copyright © 2019 Pierluigi Galdi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

extern void SACLockScreenImmediate(void);

@interface SystemHelper : NSObject
+ (void)lock;
+ (void)sleep;
@end


/// Thanks to: https://github.com/Astrr/Pock/commit/64f8b55a7ac67c58eb3d24a65a3c70ecde311da7
NS_ASSUME_NONNULL_BEGIN
CF_EXPORT void CoreDisplay_Display_SetUserBrightness(int CGDirectDisplayID, double level);
CF_EXPORT double CoreDisplay_Display_GetUserBrightness(int CGDirectDisplayID);
NS_ASSUME_NONNULL_END
