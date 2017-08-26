//
//  ShareTool.h
//  Phone
//
//  Created by 左键视觉 on 16/10/21.
//  Copyright © 2016年 uxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "ShareManager.h"

@interface ShareTool : NSObject

// 注册
+(void)registerApp;


-(void)shareWithShareType:(ShareType)shareType shareImageName:(NSString *)imageName shareImageUrl:(NSString *)shareImageUrl presentVC:(UIViewController <ShareManagerDelegate> *)presentVC shareText:(NSString *)shareText selectUrl:(NSString *)selectUrl shareTitle:(NSString *)shareTitle;

-(void)isShareSuccess:(BOOL)shareSuccess;
@end
