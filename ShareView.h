//
//  ShareView.h
//  Sanqianwan
//
//  Created by 左键视觉 on 16/10/22.
//  Copyright © 2016年 com.sanqianwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface  ShareView : UIView

@property(nonatomic,copy)void(^weixinFriendBtnBlock)();

@property(nonatomic,copy)void(^weixinCircleBtnBlock)();

@property(nonatomic,copy)void(^qqFriendBlock)();

@property(nonatomic,copy)void(^weiboBtnBlock)();

@property(nonatomic,copy)void(^cancelBtnBlock)();

@end
