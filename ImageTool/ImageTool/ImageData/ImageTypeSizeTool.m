//
//  ImageTypeSizeTool.m
//  ImageTool
//
//  Created by cguo on 2017/9/20.
//  Copyright © 2017年 zjq. All rights reserved.
//

#import "ImageTypeSizeTool.h"
// 缓存主目录



@implementation ImageTypeSizeTool


+ (CGSize)ImageSizeWithData:(NSData *)imageData withImageType:(ImageType)type
{
    CGSize finalSize = CGSizeZero;
    switch (type) {
        case ImageTypeJPG:
        {
            
            return  [self jpgImageSizeWithImageData:imageData];
        }
            break;
        case ImageTypePNG:
        {
            NSData *data = [self fileimageInLength:8 location:16 imageData:imageData];
            finalSize =  [self pngImageSizeWithHeaderData:data];
        }
            break;
        case ImageTypeBMP:
        {
            NSData *data = [self fileimageInLength:8 location:18 imageData:imageData];
            finalSize = [self bmpImageSizeWithHeaderData:data];
        }
            break;
        case ImageTypeGIF:
        {
            NSData *data = [self fileimageInLength:4 location:6 imageData:imageData];
            finalSize = [self gifImageSizeWithHeaderData:data];
        }
            break;
        case ImageTypeUnKnow:
        {
            UIImage *image = [UIImage imageWithData:imageData];
            if (image) {
                finalSize =  image.size;
            }
            else {
                finalSize = CGSizeZero;
            }
        }
            break;
        default:
            finalSize = CGSizeZero;
            break;
    }
    
    return finalSize;

    
}
//用于截取data某一段的数据  length--长度   seek---前文件的操作位置   filePath--文件路径
+ (NSData*)fileHeaderData:(NSInteger)length seek:(NSInteger)seek filePath:(NSString *)filePath {
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return nil;
    }
    NSDictionary *fileAttribute = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    NSUInteger fileSize = [fileAttribute fileSize];
    if (length + seek > fileSize) {
        return nil;
    }
    
    NSFileHandle *fileHandler = [NSFileHandle fileHandleForReadingAtPath:filePath];
    //    将当前文件的操作位置设定为seek
    [fileHandler seekToFileOffset:seek];
    NSData *data = [fileHandler readDataOfLength:length];
    [fileHandler closeFile];
    return data;
}


//用于截取data某一段的数据  length--长度   location---前文件的操作位置   imageData--图片数据
+ (NSData*)fileimageInLength:(NSInteger)length location:(NSInteger)location imageData:(NSData *)imageData {
 
    NSData *data = [imageData subdataWithRange:NSMakeRange(location, length)];
    return data;
}


+ (CGSize)gifImageSizeWithHeaderData:(NSData *)data
{
    if (data.length != 4) {
        return CGSizeZero;
    }
    unsigned char w1 = 0, w2 = 0;
    [data getBytes:&w1 range:NSMakeRange(0, 1)];
    [data getBytes:&w2 range:NSMakeRange(1, 1)];
    short w = w1 + (w2 << 8);
    unsigned char h1 = 0, h2 = 0;
    [data getBytes:&h1 range:NSMakeRange(2, 1)];
    [data getBytes:&h2 range:NSMakeRange(3, 1)];
    short h = h1 + (h2 << 8);
    return CGSizeMake(w, h);
}


//JPG文件数据，分很多很多的数据段， 并且每个数据段都会以 0xFF开头
//找到一个数据断后，如果数据段的开头是0xffc0，那么该数据段将会存储 图片的尺寸信息
//否则0xffc0 后面紧跟的两个字段，存储的是当前这个数据段的长度，可跳过当前的数据段
//然后寻找下一个数据段，然后查看是否有图片尺寸信息
+ (CGSize)jpgImageSizeWithImageData:(NSData *)ImageData
{
    NSArray*paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

    NSString *filePath=[NSString stringWithFormat:@"%@%@",paths[0],@"image.jpg"];
    
    BOOL result =  [[NSFileManager defaultManager] createFileAtPath:filePath contents:ImageData attributes:nil];
    if (!result) {
        return CGSizeZero;
    }
    
    
    if (!filePath.length) {
        return CGSizeZero;
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return  CGSizeZero;
    }
    
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    NSUInteger offset = 2;
    NSUInteger length = 0;
    while (1) {
        [fileHandle seekToFileOffset:offset];
        length = 4;
        NSData *data = [fileHandle readDataOfLength:length];
        if (data.length != length) {
            break;
        }
        offset += length;
        int marker,code;
        NSUInteger newLength;
        unsigned char value1,value2,value3,value4;
        [data getBytes:&value1 range:NSMakeRange(0, 1)];
        [data getBytes:&value2 range:NSMakeRange(1, 1)];
        [data getBytes:&value3 range:NSMakeRange(2, 1)];
        [data getBytes:&value4 range:NSMakeRange(3, 1)];
        marker = value1;
        code = value2;
        newLength = (value3 << 8) + value4;
        if (marker != 0xff) {
            [fileHandle closeFile];
            return CGSizeZero;
        }
        
        if (code >= 0xc0 && code <= 0xc3) {
            length = 5;
            [fileHandle seekToFileOffset:offset];
            NSData *data =[fileHandle readDataOfLength:length];
            if (data.length != length) {
                break;
            }
            Byte *bytesArray = (Byte*)[data bytes];
            NSUInteger height = ((unsigned char)bytesArray[1] << 8) + (unsigned char)bytesArray[2];
            NSUInteger width =  ((unsigned char)bytesArray[3] << 8) + (unsigned char)bytesArray[4];
            [fileHandle closeFile];
            return CGSizeMake(width, height);
        }
        else {
            offset += newLength;
            offset -=2;
        }
    }
    [fileHandle closeFile];
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    if (image) {
        CGSizeMake((NSInteger)image.size.width, (NSInteger)image.size.height);
    }
    return CGSizeZero;
    
}


+ (CGSize)pngImageSizeWithHeaderData:(NSData *)data
{
    if (data.length != 8) {
        return CGSizeZero;
    }
    unsigned char w1 = 0, w2 = 0, w3 = 0, w4 = 0;
    [data getBytes:&w1 range:NSMakeRange(0, 1)];
    [data getBytes:&w2 range:NSMakeRange(1, 1)];
    [data getBytes:&w3 range:NSMakeRange(2, 1)];
    [data getBytes:&w4 range:NSMakeRange(3, 1)];
    int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
    
    unsigned char h1 = 0, h2 = 0, h3 = 0, h4 = 0;
    [data getBytes:&h1 range:NSMakeRange(4, 1)];
    [data getBytes:&h2 range:NSMakeRange(5, 1)];
    [data getBytes:&h3 range:NSMakeRange(6, 1)];
    [data getBytes:&h4 range:NSMakeRange(7, 1)];
    int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
    return CGSizeMake(w, h);
}


+ (CGSize)bmpImageSizeWithHeaderData:(NSData *)data {
    if (data.length != 8) {
        return CGSizeZero;
    }
    unsigned char w1 = 0, w2 = 0, w3 = 0, w4 = 0;
    [data getBytes:&w1 range:NSMakeRange(0, 1)];
    [data getBytes:&w2 range:NSMakeRange(1, 1)];
    [data getBytes:&w3 range:NSMakeRange(2, 1)];
    [data getBytes:&w4 range:NSMakeRange(3, 1)];
    int w = w1 + (w2 << 8) + (w3 << 16) + (w4 << 24);
    unsigned char h1 = 0, h2 = 0, h3 = 0, h4 = 0;
    [data getBytes:&h1 range:NSMakeRange(4, 1)];
    [data getBytes:&h2 range:NSMakeRange(5, 1)];
    [data getBytes:&h3 range:NSMakeRange(6, 1)];
    [data getBytes:&h4 range:NSMakeRange(7, 1)];
    int h = h1 + (h2 << 8) + (h3 << 16) + (h4 << 24);
    return CGSizeMake(w, h);
}
@end
