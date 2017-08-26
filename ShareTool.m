//
//  ShareTool.m
//  Phone
//
//  Created by 左键视觉 on 16/10/21.
//  Copyright © 2016年 uxin. All rights reserved.
//

#import "ShareTool.h"
#import "AppDelegate.h"
#import "ShareView.h"
// 微信appid
NSString * const kWXappKey = @"wx9fa8b546b917ed1f";
NSString * const kWeiBoappKey = @"325287325";


static const float  ShareViewHight = 150;

//!分享view 和灰色背景的tag
static const NSInteger ShareViewTag = 100000001;
static const NSInteger ShareBlackViewTag = 100000002;

@interface ShareTool()

//!分享的界面
@property(nonatomic,strong)ShareView * shareView;

//!其他部分的透明灰色view
@property(nonatomic,strong)UIView * shareBlackView;

@end

@implementation ShareTool

+(void)registerApp{
    
    //向微信注册
    [WXApi registerApp:kWXappKey withDescription:@"demo 2.0"];
    
    // 微博注册
    [WeiboSDK enableDebugMode:YES];
    
    [WeiboSDK registerApp:kWeiBoappKey];
    
    
}

-(instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        //!创建界面
        [self createShareView];
        
    }
    
    return self;
    
}
//!创建分享的界面
-(void)createShareView{
    
    AppDelegate * del = [UIApplication sharedApplication].delegate;
    
    UIView * oldShareView = [del.window viewWithTag:ShareViewTag];
    UIView * oldShareBlackView = [del.window viewWithTag:ShareBlackViewTag];
    
    if (oldShareView) {
        
        [oldShareView removeFromSuperview];
        oldShareView = nil;
        
    }
    if (oldShareBlackView) {
        
        [oldShareBlackView removeFromSuperview];
        oldShareBlackView = nil;
        
    }
    
    
    //!分享的view
    self.shareView = [[[NSBundle mainBundle]loadNibNamed:@"ShareView" owner:nil options:nil]lastObject];
    
    self.shareView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height , SCREEN_WIDTH, ShareViewHight);
    
    //!黑色的透明view
    self.shareBlackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [UIScreen mainScreen].bounds.size.height )];
    [self.shareBlackView setBackgroundColor:[UIColor blackColor]];
    self.shareBlackView.alpha = 0;
    
    UITapGestureRecognizer * blackTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidesShareView)];//!黑色透明view添加手势
    [self.shareBlackView addGestureRecognizer:blackTap];
    
    //!添加tag
    self.shareView.tag = ShareViewTag;
    self.shareBlackView.tag = ShareBlackViewTag;
    
    //!添加到window上面
    [del.window addSubview:self.shareBlackView];
    
    [del.window addSubview:self.shareView];
    
    
    //!改变位置（用于隐藏）
    [self hideFrame];
    
    
}
//!改变位置（用于显示）
-(void)showFrame{
    
    [UIView animateWithDuration:0.4 // 动画时长
                          delay:0 // 动画延迟
         usingSpringWithDamping:0.8 // 类似弹簧振动效果 0~1
          initialSpringVelocity:0.5 // 初始速度
                        options:UIViewAnimationOptionCurveEaseInOut // 动画过渡效果
                     animations:^{
                         
                         
                         
                         self.shareView.center = CGPointMake(self.shareView.center.x,[UIScreen mainScreen].bounds.size.height - ShareViewHight/2.0);
                         
                         self.shareBlackView.alpha = 0.5;
                         
                     } completion:^(BOOL finished) {
                         
                         
                     }];
    
}
//!收起分享界面
-(void)hidesShareView{
    
    
    [self hideFrame];
    
    //!移除
    if (self.shareView) {
        
        [self.shareView removeFromSuperview];
        self.shareView = nil;
        
    }
    
    if (self.shareBlackView) {
        
        [self.shareBlackView removeFromSuperview];
        self.shareBlackView = nil;
        
    }
    
    
}


//!改变位置（用于隐藏）
-(void)hideFrame{
    
    //!隐藏的动画
    [UIView animateWithDuration:0.5 animations:^{
        
        self.shareView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height , SCREEN_WIDTH, self.shareView.frame.size.height);
        
        self.shareBlackView.alpha = 0;
        
    }];
    
}

-(void)shareWithShareType:(ShareType)shareType shareImageName:(NSString *)imageName shareImageUrl:(NSString *)shareImageUrl presentVC:(UIViewController <ShareManagerDelegate> *)presentVC shareText:(NSString *)shareText selectUrl:(NSString *)selectUrl shareTitle:(NSString *)shareTitle{

    //!显示动画
    [self showFrame];
    
    //!实现分享按钮的block
    
    //!取消分享
    self.shareView.cancelBtnBlock = ^(){
    
        [self hidesShareView];
        
    };
    
    self.shareView.weixinFriendBtnBlock = ^(){
    
        [ShareManager sharePlatformType:PlatformType_WechatFriend withShareType:shareType shareImageName:imageName shareImageUrl:shareImageUrl presentVC:presentVC shareText:shareText selectUrl:selectUrl shareTitle:shareTitle];

    };
    
    self.shareView.weixinCircleBtnBlock = ^(){
        
        [ShareManager sharePlatformType:PlatformType_WechatCircle withShareType:shareType shareImageName:imageName shareImageUrl:shareImageUrl presentVC:presentVC shareText:shareText selectUrl:selectUrl shareTitle:shareTitle];
        

    };
    self.shareView.qqFriendBlock = ^(){
        
         [ShareManager sharePlatformType:PlatformType_QQ withShareType:shareType shareImageName:imageName shareImageUrl:shareImageUrl presentVC:presentVC shareText:shareText selectUrl:selectUrl shareTitle:shareTitle];
    };
    self.shareView.weiboBtnBlock = ^(){
        
           [ShareManager sharePlatformType:PlatformType_Sina withShareType:shareType shareImageName:imageName shareImageUrl:shareImageUrl presentVC:presentVC shareText:shareText selectUrl:selectUrl shareTitle:shareTitle];
        
    };
    /*
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"分享到" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction * weiFriendAction = [UIAlertAction actionWithTitle:@"微信好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [ShareManager sharePlatformType:PlatformType_WechatFriend withShareType:shareType shareImageName:imageName shareImageUrl:shareImageUrl presentVC:presentVC shareText:shareText selectUrl:selectUrl shareTitle:shareTitle];
        
    }];
    
    
    UIAlertAction * weiCircleAction = [UIAlertAction actionWithTitle:@"朋友圈" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [ShareManager sharePlatformType:PlatformType_WechatCircle withShareType:shareType shareImageName:imageName shareImageUrl:shareImageUrl presentVC:presentVC shareText:shareText selectUrl:selectUrl shareTitle:shareTitle];

    }];
    
    UIAlertAction * QQFriendAction = [UIAlertAction actionWithTitle:@"QQ好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
    
        [ShareManager sharePlatformType:PlatformType_QQ withShareType:shareType shareImageName:imageName shareImageUrl:shareImageUrl presentVC:presentVC shareText:shareText selectUrl:selectUrl shareTitle:shareTitle];

    
    }];
    
    UIAlertAction * QQZoneAction = [UIAlertAction actionWithTitle:@"QQ空间" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        
        [ShareManager sharePlatformType:PlatformType_Qzone withShareType:shareType shareImageName:imageName shareImageUrl:shareImageUrl presentVC:presentVC shareText:shareText selectUrl:selectUrl shareTitle:shareTitle];
        
        
    }];
    
    
    UIAlertAction * weiboAction = [UIAlertAction actionWithTitle:@"微博" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        
        [ShareManager sharePlatformType:PlatformType_Sina withShareType:shareType shareImageName:imageName shareImageUrl:shareImageUrl presentVC:presentVC shareText:shareText selectUrl:selectUrl shareTitle:shareTitle];
        
        
    }];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];


    
    [alertController addAction:weiFriendAction];
    [alertController addAction:weiCircleAction];
    [alertController addAction:QQFriendAction];
    [alertController addAction:QQZoneAction];
    [alertController addAction:weiboAction];
    [alertController addAction:cancelAction];
    
    [presentVC presentViewController:alertController animated:YES completion:nil];
    
    */


}

-(void)isShareSuccess:(BOOL)shareSuccess{

    [ShareManager isShareSuccess:shareSuccess];
    

}
@end
