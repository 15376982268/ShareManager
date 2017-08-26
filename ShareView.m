//
//  ShareView.m
//  Sanqianwan
//
//  Created by 左键视觉 on 16/10/22.
//  Copyright © 2016年 com.sanqianwan. All rights reserved.
//

#import "ShareView.h"

@implementation ShareView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    
}

- (IBAction)weixinFriendBtnClick:(id)sender {
    
    if (self.weixinFriendBtnBlock) {
        
        self.weixinFriendBtnBlock();
    }
    
}


- (IBAction)weixinCircleBtnClick:(id)sender {
    
    if (self.weixinCircleBtnBlock) {
        
        self.weixinCircleBtnBlock();
    }
    
}

- (IBAction)qqFriendClick:(id)sender {

    if (self.qqFriendBlock) {
        
        self.qqFriendBlock();
    }
    
}

- (IBAction)weiboBtnClick:(id)sender {
    
    if (self.weiboBtnBlock) {
        
        self.weiboBtnBlock();
    }
    
    
}
- (IBAction)cancelBtnClick:(id)sender {
    
    if (self.cancelBtnBlock) {
        
        self.cancelBtnBlock();
    }
}

@end
