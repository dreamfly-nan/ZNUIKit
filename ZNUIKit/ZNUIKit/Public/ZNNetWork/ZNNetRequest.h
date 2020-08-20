//
//  ZNNetRequest.h
//  ZNNavigationViewController
//
//  Created by 郑楠楠 on 2018/10/27.
//  Copyright © 2018年 郑楠楠. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "ZNResponseMessage.h"
#import "ZNFileModel.h"

//默认的请求成功code
#define REQUEST_SUCCESS 0
//网络出错的通知
#define ZNRequsetNetError @"ZNNetError"

/**
 请求方式
 - RequestModeTypeGet: get请求
 - RequestModeTypePost: post请求
 - RequestModeTypePut: put请求
 - RequestModeTypeDel: delete请求
 - RequestModeTypePatch: patch请求
 */
typedef NS_ENUM(NSUInteger,RequestModeType) {
    RequestModeTypeGet,
    RequestModeTypePost,
    RequestModeTypePut,
    RequestModeTypeDel,
    RequestModeTypePatch
};

/**
 <#Description#>

 - RequestParamtersTypeJson: json形式请求
 - RequestParamtersTypeForm: form表单形式请求
 */
typedef NS_ENUM(NSUInteger,RequestParamtersType) {
    RequestParamtersTypeJson,
    RequestParamtersTypeForm
};

typedef void(^ZNNetRequestDownCompletionHandler)(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error);

typedef NSURL * _Nonnull(^ZNNetRequestDestination)(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response);

typedef void(^ZNNetRequestSuccess)(id _Nullable responseObject, NSInteger code);

typedef void(^ZNNetRequestFail)(NSString * _Nonnull message ,NSInteger code,id _Nullable responseObject);

typedef void(^ZNNetRequestProgress)(CGFloat progress);

@interface ZNNetRequest : AFHTTPSessionManager

//所有的网络请求
@property (nonatomic , strong) NSMutableArray <NSURLSessionDataTask *> * _Nullable allSessionDataTasks;

//请求头的数据设置的代码块
@property (nonatomic , copy) NSDictionary * _Nonnull(^_Nonnull requestHeadBlock)(void);

//请求头的数据设置的代码块
@property (nonatomic , copy) NSDictionary * _Nonnull(^_Nonnull requestParameterBlock)(NSDictionary * _Nullable parameter);

/*
 统一配置请求成功后执行的代码块
 */
@property (nonatomic , copy) ZNResponseMessage * _Nonnull (^_Nonnull requestSuccess)(id _Nonnull responseObject);

//统一配置请求失败后的代码块
@property (nonatomic , copy) void (^_Nonnull requestFail)(NSError * _Nonnull error);

//请求超时的时间设置
@property (nonatomic , assign) CGFloat requestTimeOut;

//获取单例
+ (ZNNetRequest * _Nonnull) getManager;

/// 配置baseUrl
/// @param baseUrl <#baseUrl description#>
+ (void)setAppBaseUrl:(NSString * _Nonnull) baseUrl;

+ (void)POST:(NSString* _Nonnull)url
        type:(RequestParamtersType)type
  parameters:(NSDictionary* _Nullable)parameters
     success:(ZNNetRequestSuccess _Nonnull)success
        fail:(ZNNetRequestFail _Nonnull)fail;

+ (void)GET:(NSString* _Nonnull)url
       type:(RequestParamtersType)type
 parameters:(NSDictionary* _Nullable)parameters
    success:(ZNNetRequestSuccess _Nonnull)success
       fail:(ZNNetRequestFail _Nonnull)fail;

+ (void)PUT:(NSString* _Nonnull)url
       type:(RequestParamtersType)type
 parameters:(NSDictionary* _Nullable)parameters
    success:(ZNNetRequestSuccess _Nonnull)success
       fail:(ZNNetRequestFail _Nonnull)fail;

+ (void)PATCH:(NSString* _Nonnull)url
         type:(RequestParamtersType)type
   parameters:(NSDictionary* _Nullable)parameters
      success:(ZNNetRequestSuccess _Nonnull)success
         fail:(ZNNetRequestFail _Nonnull)fail;

+ (void)DEL:(NSString* _Nonnull)url
       type:(RequestParamtersType)type
 parameters:(NSDictionary* _Nullable)parameters
    success:(ZNNetRequestSuccess _Nonnull)success
       fail:(ZNNetRequestFail _Nonnull)fail;

/**
 文件上传
 
 @param urlStr url
 @param parameters 参数
 @param type 上传参数类型
 @param dataModels 文件数据
 @param progress 进度
 @param success 成功回调
 @param fail 失败回调
 */
+ (void)POST:(NSString * _Nonnull)urlStr
  parameters:(NSDictionary * _Null_unspecified)parameters
   paramters:(RequestParamtersType)type
  dataModels:(NSArray<ZNFileModel*> * _Nonnull)dataModels
    progress:(ZNNetRequestProgress _Nullable)progress
     success:(ZNNetRequestSuccess _Nullable)success
        fail:(ZNNetRequestFail _Nullable)fail;

/**
 文件下载

 @param urlStr <#urlStr description#>
 @param progress <#progress description#>
 @param destination <#destination description#>
 @param completionHandler <#completionHandler description#>
 @return <#return value description#>
 */
+ (NSURLSessionDownloadTask * _Nonnull)downFileWith:(NSString* _Nonnull)urlStr
                                  progress:(ZNNetRequestProgress _Nullable)progress
                               destination:(ZNNetRequestDestination _Nonnull)destination
                         completionHandler:(ZNNetRequestDownCompletionHandler _Nonnull)completionHandler;

@end
