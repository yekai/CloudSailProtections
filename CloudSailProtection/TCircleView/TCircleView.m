//
//  CircleView.m
//  2015-06-29-圆形渐变进度条
//
//  Created by TangJR on 6/29/15.
//  Copyright (c) 2015 tangjr. All rights reserved.
//

#import "TCircleView.h"
#import "TKit.h"
#import <POP.h>
#import "TCircleView+BaseConfiguration.h"
#import "UICountingLabel.h"
@interface TCircleView ()

@property (strong, nonatomic) CAShapeLayer *colorMaskLayer; // 渐变色遮罩
@property (strong, nonatomic) CAShapeLayer *colorLayer; // 渐变色
@property (strong, nonatomic) CAShapeLayer *blueMaskLayer; // 蓝色背景遮罩
@property (strong, nonatomic) UICountingLabel *countingLabel;
@end

@implementation TCircleView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
   
//    [self setupBlueMaskLayer];
}

- (void)setupCircleView
{
    self.backgroundColor = [TCircleView backgroundColor];
    
    [self setupColorLayer];
    [self setupColorMaskLayer];
}

/**
 *  设置整个蓝色view的遮罩
 */
- (void)setupBlueMaskLayer {
    
    CAShapeLayer *layer = [self generateMaskLayer];
    self.layer.mask = layer;
    self.blueMaskLayer = layer;
}


/**
 *  设置渐变色，渐变色由左右两个部分组成，左边部分由黄到绿，右边部分由黄到红
 */
- (void)setupColorLayer {
    
    self.colorLayer = [CAShapeLayer layer];
    self.colorLayer.frame = self.bounds;
    [self.layer addSublayer:self.colorLayer];

    CAGradientLayer *leftLayer = [CAGradientLayer layer];
    leftLayer.frame = CGRectMake(0, 0, self.width / 2, self.height);
    // 分段设置渐变色
    leftLayer.locations = @[@0.3, @0.6, @1];
    leftLayer.colors = @[(id)[TCircleView centerColor].CGColor, (id)[TCircleView startColor].CGColor];
    [self.colorLayer addSublayer:leftLayer];
    
    CAGradientLayer *rightLayer = [CAGradientLayer layer];
    rightLayer.frame = CGRectMake(self.width / 2, 0, self.width / 2, self.height);
    rightLayer.locations = @[@0.3, @0.6, @1];
    rightLayer.colors = @[(id)[TCircleView centerColor].CGColor, (id)[TCircleView endColor].CGColor];
    [self.colorLayer addSublayer:rightLayer];
}

/**
 *  设置渐变色的遮罩
 */
- (void)setupColorMaskLayer {
    
    CAShapeLayer *layer = [self generateMaskLayer];
    layer.lineWidth =[TCircleView lineWidth] + 0.5; // 渐变遮罩线宽较大，防止蓝色遮罩有边露出来
    self.colorLayer.mask = layer;
    self.colorMaskLayer = layer;
}

/**
 *  生成一个圆环形的遮罩层
 *  因为蓝色遮罩与渐变遮罩的配置都相同，所以封装出来
 *
 *  @return 环形遮罩
 */
- (CAShapeLayer *)generateMaskLayer {
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = self.bounds;
    
    // 创建一个圆心为父视图中点的圆，半径为父视图宽的2/5，起始角度是从-240°到60°
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width / 2, self.height / 2) radius:self.width / 2.5 startAngle:[TCircleView startAngle] endAngle:[TCircleView endAngle] clockwise:YES];
    layer.lineWidth = [TCircleView lineWidth];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor; // 填充色为透明（不设置为黑色）
    layer.strokeColor = [UIColor blackColor].CGColor; // 随便设置一个边框颜色
    layer.lineCap = kCALineCapRound; // 设置线为圆角
    return layer;
}

/**
 *  在修改百分比的时候，修改彩色遮罩的大小
 *
 *  @param persentage 百分比
 */
- (void)setPersentage:(CGFloat)persentage {
    
    _persentage = persentage;
    //    self.colorMaskLayer.strokeEnd = persentage; // 没有回弹动画
    [self animationWithStrokeEnd:persentage]; // 有回弹动画
}

/**
 *  进度条弹性动画
 *
 *  @param strokeEnd 进度条结束的位置（当前百分比）
 */
- (void)animationWithStrokeEnd:(CGFloat)strokeEnd {
    
    POPSpringAnimation *strokeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
    strokeAnimation.springSpeed = 2;
    strokeAnimation.toValue = @(strokeEnd);
    strokeAnimation.springBounciness = 12.f;
    strokeAnimation.removedOnCompletion = NO;
    [self.colorMaskLayer pop_addAnimation:strokeAnimation forKey:@"layerStrokeAnimation"];
}

@end