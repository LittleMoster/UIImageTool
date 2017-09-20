//
//  ImageTypeSizeTool.h
//  ImageTool
//
//  Created by cguo on 2017/9/20.
//  Copyright © 2017年 zjq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,ImageType)
{
    ImageTypeUnKnow = -1,
    ImageTypeJPG,
    ImageTypePNG,
    ImageTypeBMP,
    ImageTypeGIF,
};
@interface ImageTypeSizeTool : NSObject



+ (CGSize)ImageSizeWithData:(NSData *)data withImageType:(ImageType)type;
@end
