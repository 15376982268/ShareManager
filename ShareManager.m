//
//  ShareManager.m
//  Phone
//
//  Created by 左键视觉 on 16/10/21.
//  Copyright © 2016年 uxin. All rights reserved.
//

#import "ShareManager.h"

@interface ShareManager()

@property (nonatomic, weak) id <ShareManagerDelegate> delegate;

@end

@implementation ShareManager

single_implementation(ShareManager)

+(void)sharePlatformType:(PlatformType)platformType withShareType:(ShareType)shareType shareImageName:(NSString *)imageName shareImageUrl:(NSString *)shareImageUrl presentVC:(UIViewController <ShareManagerDelegate> *)presentVC shareText:(NSString *)shareText selectUrl:(NSString *)selectUrl shareTitle:(NSString *)shareTitle{

    [ShareManager sharedShareManager].delegate = presentVC;
    
    //朋友圈、好友
    if (platformType == PlatformType_WechatFriend || platformType == PlatformType_WechatCircle) {
        
        WXMediaMessage * message = [WXMediaMessage message];
        message.title = shareTitle;
        message.description = shareText;
        
        if (shareType == Share_LocalImage) {//分享本地图片
            
            [message setThumbImage:[UIImage imageNamed:imageName]];

        }else if (shareType ==  Share_WebImage){//分享网络图片
        
            NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:shareImageUrl]];
            [message setThumbImage:[UIImage imageWithData:imageData]];
        
        }

        
        WXWebpageObject * webpageObject = [WXWebpageObject object];
        webpageObject.webpageUrl = selectUrl;
        message.mediaObject = webpageObject;
        
        SendMessageToWXReq * req = [[SendMessageToWXReq alloc]init];
        req.bText = NO;
        req.message = message;
        
        if (platformType == PlatformType_WechatFriend) {
            
            req.scene = WXSceneSession;

        }else{
            
            req.scene = WXSceneTimeline;

        }
        
        [WXApi sendReq:req];
    
        return;
    }
    
    // qq好友、qq空间
    if (platformType == PlatformType_QQ || platformType == PlatformType_Qzone) {
        
        QQApiNewsObject* imgObj;
        if (shareType == Share_LocalImage) {
            
            imgObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:selectUrl] title:shareTitle description:shareText previewImageData:UIImagePNGRepresentation([UIImage imageNamed:imageName])];
            
        }else if (shareType == Share_WebImage){
            
            imgObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:selectUrl] title:shareTitle description:shareText previewImageURL:[NSURL URLWithString:shareImageUrl]];
            
        }
        
        if (platformType == PlatformType_QQ) {
            
            SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:imgObj];
            
            QQApiSendResultCode sent = [QQApiInterface sendReq:req];

        }else{
            
            [imgObj setCflag:kQQAPICtrlFlagQZoneShareOnStart];
            
            SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:imgObj];
            
            QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];

        
        }
        
        return;

    }
    
    if (platformType == PlatformType_Sina) {//新浪微博
        
        WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
        authRequest.redirectURI = kRedirectURI;
        authRequest.scope = @"all";
        
        
        WBSendMessageToWeiboRequest * request = [WBSendMessageToWeiboRequest requestWithMessage:[self weiboMessageWithShareType:shareType shareImageName:imageName shareImageUrl:shareImageUrl shareText:shareText selectUrl:selectUrl shareTitle:shareTitle] authInfo:authRequest access_token:nil];
        
        [WeiboSDK sendRequest:request];
        
    }
   

}
+(WBMessageObject *)weiboMessageWithShareType:(ShareType)shareType shareImageName:(NSString *)imageName shareImageUrl:(NSString *)shareImageUrl shareText:(NSString *)shareText selectUrl:(NSString *)selectUrl shareTitle:(NSString *)shareTitle{

    WBMessageObject *message = [WBMessageObject message];
    message.text = [NSString stringWithFormat:@"%@:%@%@",shareTitle,shareText,selectUrl];
    
    WBImageObject *image = [WBImageObject object];

    if (shareType == Share_LocalImage) {//分享本地图片
        
        image.imageData = UIImagePNGRepresentation([UIImage imageNamed:imageName]);

    }else if (shareType ==  Share_WebImage){//分享网络图片
        
        image.imageData =  [NSData dataWithContentsOfURL:[NSURL URLWithString:shareImageUrl]];
    }
    
    message.imageObject = image;

    return message;
    
}

+(void)isShareSuccess:(BOOL)shareSuccess{

    
    if ([[ShareManager sharedShareManager].delegate respondsToSelector:@selector(shareManager:shareResult:)] ) {
        
        [[ShareManager sharedShareManager].delegate shareManager:[ShareManager sharedShareManager] shareResult:shareSuccess];
        
    }
    
    
}



@end
