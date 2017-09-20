//
//  UIImage+Extrnsion.h
//  UICategory
//
//  Created by cguo on 2017/5/6.
//  Copyright © 2017年 zjq. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage (Extrnsion)

/**
 *  设置水印文字
 */
- (UIImage *)addWatemarkTextInLogoImage:(NSString *)watemarkText
                              whitLabelFrame:(CGRect)frame
                              withAlpha:(CGFloat)alpha
                          withTextColor:(UIColor*)color;
/**
 *  设置水印图片
 */
-(UIImage*)addWatemarkImageWithtranslucentWatemarkImage:(UIImage*)waterImage withwaterImageFrame:(CGRect)frame withAlpha:(CGFloat)Alpha;
/**
 *  设置图片透明度
 */
-(UIImage *)imageByApplyingAlpha:(CGFloat )alpha;
/**
 *  对图片进行压缩，传入指定的大小，这个压缩的方法有可能会导致图片不清晰
 */
+ (UIImage *)compressImage:(UIImage *)image toByte:(float)maxLength ;

-(UIImage *)compressImageToByte:(float)maxlength;
/**
 *  不保持图片纵横比缩放
 */
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
/**
 *  保持图片纵横比缩放，最短边必须匹配targetSize的大小
 */
// 保持图片纵横比缩放，最短边必须匹配targetSize的大小
// 可能有一条边的长度会超过targetSize指定的大小
- (UIImage *)imageByScalingAspectToMinSize:(CGSize)targetSize;
/**
 *   保持图片纵横比缩放，最长边匹配targetSize的大小即可，可能有一条边的长度会小于targetSize指定的大小
 */
- (UIImage *)imageByScalingAspectToMaxSize:(CGSize)targetSize;

/**
 * 对图片按弧度执行旋转
 */
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;

/**
 *  对图片按角度执行旋转
 */
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

/**
 *  把图片剪切成圆形
 */
- (UIImage *)circleImage;

/**
 *  把图片压缩成指定尺寸,也是通过压尺寸来压缩大小
 */
- (UIImage*)scaledToSize:(CGSize)newSize;

/**
 *截取指定位置的图片
 */
-(UIImage*)GetImageWithRect:(CGRect)rect;

/*
 *根据颜色和尺寸生成image
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/*
 *用于修正图片方向
 */
+ (UIImage *)fixOrientation:(UIImage *)srcImg;







@end
