//
//  ZLLAFNPackUtils.h
//  AFNPack
//
//  Created by autonavi on 17/6/14.
//  Copyright © 2017年 autonavi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZLLSingle.h"
@class AFNetworking;

@interface ZLLAFNPackUtils : NSObject

SingleH(Utils);

//成功回调block
typedef void (^successBlock)(id obj);

//失败回调block
typedef void (^failureBlock)(NSError*error);

//进度block
typedef void (^progressBlock)(NSProgress *progress);

/**
 * GET请求
 */
- (void)Get:(NSString *)urlpath parameters:(NSDictionary *)parameters progerss:(progressBlock)progress success:(successBlock)successBlock failur:(failureBlock)failurBlock;

/**
 *  POST请求
 */
- (void)Post:(NSString *)urlpath parameters:(NSDictionary *)parameters  success:(successBlock)successBlock failur:(failureBlock)failurBlock;

/**
 * 文件下载
 */
- (void)downloadWithUrlString:(NSString *)urlString filePath:(NSString *)filePath progress:(progressBlock)progress success:(void (^)(NSURL *fileURL))success failur:(failureBlock)failurBlock;

/**
 * 文件上传
 */
- (void)uploadWithUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters fileInfo:(NSDictionary *)fileInfo progress:(progressBlock)progressBlock success:(successBlock)successBlock failur:(failureBlock)failurBlock;

@end
