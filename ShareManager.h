//
//  ShareManager.h
//  Phone
//
//  Created by 左键视觉 on 16/10/21.
//  Copyright © 2016年 uxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "WXApi.h"
#import "TencentOpenAPI/QQApiInterface.h"
#import "AppDelegate.h"




typedef NS_ENUM(NSUInteger, PlatformType) {
    PlatformType_Sina = 0,             //微博分享
    PlatformType_WechatFriend = 1,     //微信好友
    PlatformType_WechatCircle = 2,     //微信朋友圈
    PlatformType_QQ = 3,               //分享到QQ
    PlatformType_Qzone = 4             //分享到QQ空间
};
typedef NS_ENUM(NSUInteger, ShareType) {
    
    Share_LocalImage = 1,          //!带本地图片的分享
    Share_WebImage = 2,            //!带网络图片的分享
    
};
@class ShareManager;

@protocol ShareManagerDelegate<NSObject>

@optional
// 分享结果的代理
- (void)shareManager:(ShareManager*)manager shareResult:(BOOL)isSucceed;

@end

@interface ShareManager : NSObject

single_interface(ShareManager)


+(void)sharePlatformType:(PlatformType)platformType withShareType:(ShareType)shareType shareImageName:(NSString *)imageName shareImageUrl:(NSString *)shareImageUrl presentVC:(UIViewController <ShareManagerDelegate> *)presentVC shareText:(NSString *)shareText selectUrl:(NSString *)selectUrl shareTitle:(NSString *)shareTitle;


+(void)isShareSuccess:(BOOL)shareSuccess;

@end
