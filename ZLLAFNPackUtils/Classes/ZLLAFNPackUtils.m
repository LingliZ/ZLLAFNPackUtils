//
//  ZLLAFNPackUtils.m
//  AFNPack
//
//  Created by autonavi on 17/6/14.
//  Copyright © 2017年 autonavi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZLLAFNPackUtils.h"
#import "AFNetworking.h"

@interface ZLLAFNPackUtils()

@property(nonatomic,strong)AFHTTPSessionManager *manager;

@end

@implementation ZLLAFNPackUtils

SingleM(Utils);

-(AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
        //用来解析text/html类型的数据
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _manager;
}

/**
 * GET
 */
-(void)Get:(NSString *)urlpath parameters:(NSDictionary *)parameters progerss:(progressBlock)progressBlock success:(successBlock)successBlock failur:(failureBlock)failurBlock
{
    [self.manager GET:urlpath parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
      
        if (progressBlock) {
            progressBlock(downloadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"____请求成功______-%@",responseObject);
        id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (successBlock) {
            successBlock(obj);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failurBlock) {
            failurBlock(error);
        }
    }];
}

/**
 * POST
 */
-(void)Post:(NSString *)urlpath parameters:(NSDictionary *)parameters  success:(successBlock)successBlock failur:(failureBlock)failurBlock;
{
    [self.manager POST:urlpath parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (successBlock) {
            successBlock(obj);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failurBlock) {
            failurBlock(error);
        }
    }];
}

/**
 * 文件下载
 */
- (void)downloadWithUrlString:(NSString *)urlString filePath:(NSString *)filePath progress:(progressBlock)progressBlock success:(void (^)(NSURL *fileURL))success failur:(void (^)(NSError *error))failur
{
    __block NSString *fullPath = filePath;
    NSURLSessionDownloadTask *task = [self.manager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progressBlock) {
            progressBlock(downloadProgress);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        if (!fullPath){
            fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
        }
        return [NSURL fileURLWithPath:fullPath];

    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (success && !error) {
            success(filePath);
        }
        if (failur && error) {
            failur(error);
        }
    }];
    [task resume];
}

/**
 * 文件上传
 */
-(void)uploadWithUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters fileInfo:(NSDictionary *)fileInfo progress:(progressBlock)progressBlock success:(successBlock)successBlock failur:(failureBlock)failurBlock
{
    NSString *name = fileInfo[@"name"];
    NSString *fileName = fileInfo[@"fileName"];
    NSString *filePath = fileInfo[@"filePath"];
    NSString *mimeType = fileInfo[@"mimeType"];
    name = name?name:@"file";
    [self.manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (!fileName ||!mimeType) {
             [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:name error:nil];
            return;
        }
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:name fileName:fileName mimeType:mimeType error:nil];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progressBlock) {
            progressBlock(uploadProgress);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (successBlock) {
            successBlock(obj);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failurBlock) {
            failurBlock(error);
        }
    }];
}
@end
