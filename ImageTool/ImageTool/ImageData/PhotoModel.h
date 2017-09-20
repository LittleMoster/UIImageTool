//
//  PhotoModel.h
//  BusinessiOS
//
//  Created by cguo on 2017/8/11.
//  Copyright © 2017年 zjq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/*
 上传图片的模型类
 */
@interface PhotoModel : NSObject


@property (nonatomic, strong) UIImage *image;
//对应网站上[upload.php中]处理文件的[字段"file"]
@property (nonatomic, strong) NSString *imageName;
//要保存在服务器上的[文件名]
@property (nonatomic, strong) NSString  *fileName;
//上传文件的[mimeType]（图片的类型）
@property (nonatomic, strong) NSString *mimeType;
//图片的data数据
@property (nonatomic, strong) NSData* imageData;
//图片的尺寸
@property(nonatomic,assign)CGSize imageSize;




//+(NSMutableArray*)GetPhotoModelArrByPHAssetArr:(NSArray*)PHAssets;

//获取图片，以及压缩图片，设置图片的尺寸
+(NSMutableArray*)GetPhotoModelArrByPHAssetArr:(NSArray*)PHAssets imageSize:(CGSize)imagesize;

@end
