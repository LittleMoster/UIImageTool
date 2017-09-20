//
//  ImageTypeSizeUtill.h
//  Pods
//
//  Created by wangdan on 16/9/1.
//
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


@interface ImageTypeSizeUtil : NSObject

+ (ImageType)imageTypeOfFilePath:(NSString*)filePath;

+ (CGSize)imagSizeOfFilePath:(NSString*)filePath;

@end
