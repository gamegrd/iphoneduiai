//
//  ShadowUpView.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-9.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "ShadowUpView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ShadowUpView

- (void)makeShadowForView
{
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOffset = CGSizeMake(0, -3);
    self.layer.shadowOpacity = 0.25;
    self.layer.masksToBounds = NO;
    self.layer.shouldRasterize = YES;
}

- (void)awakeFromNib
{
    [self makeShadowForView];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self makeShadowForView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
