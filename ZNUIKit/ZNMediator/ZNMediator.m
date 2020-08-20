//
//  ZNMediator.m
//  ZNMediator
//
//  Created by 郑楠楠 on 2020/7/23.
//  Copyright © 2020 郑楠楠. All rights reserved.
//

#import "ZNMediator.h"
#import <UIKit/UIKit.h>

@interface ZNMediator()

/// 对target对象进行缓存
@property (nonatomic, strong) NSMutableDictionary *cachedTarget;

@end

@implementation ZNMediator

+ (instancetype _Nonnull)sharedInstance{
    static ZNMediator *mediator;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mediator = [[ZNMediator alloc] init];
    });
    return mediator;
}

#pragma mark - ZNMediatorDelegate

/*
 scheme://[target]/[action]?[params]
 url sample:
 aaa://targetA/actionB?id=1234
 */

- (id)performActionWithUrl:(NSURL *)url completion:(void (^)(NSDictionary *))completion
{
    if (url == nil) {
        return nil;
    }
    
    NSMutableArray *params = [[NSMutableArray alloc] init];
    NSString *urlString = [url query];
    for (NSString *param in [urlString componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        [params addObject:[elts lastObject]];
//        [params setObject:[elts lastObject] forKey:[elts firstObject]];
    }
    
    // 这里这么写主要是出于安全考虑，防止黑客通过远程方式调用本地模块。这里的做法足以应对绝大多数场景，如果要求更加严苛，也可以做更加复杂的安全逻辑。
    NSString *actionName = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    if ([actionName hasPrefix:@"native"]) {
        return @(NO);
    }
    
    // 这个demo针对URL的路由处理非常简单，就只是取对应的target名字和method名字，但这已经足以应对绝大部份需求。如果需要拓展，可以在这个方法调用之前加入完整的路由逻辑
    id result = [self performTarget:url.host action:actionName params:params shouldCacheTarget:NO];
    if (completion) {
        if (result) {
            completion(@{@"result":result});
        } else {
            completion(nil);
        }
    }
    return result;
}

- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSArray *)params shouldCacheTarget:(BOOL)shouldCacheTarget
{
    if (targetName == nil || actionName == nil) {
        return nil;
    }
    
    // generate target
    NSString *targetClassString = [NSString stringWithFormat:@"%@%@",self.targetPrefix,targetName];
    ///获取缓存中的target对象
    NSObject *target = self.cachedTarget[targetClassString];
    
    if (target == nil) {
        Class targetClass = NSClassFromString(targetClassString);
        target = [[targetClass alloc] init];
    }

    // generate action
    NSString *actionString = [NSString stringWithFormat:@"%@%@",self.actionPrefix,actionName];
    SEL action = NSSelectorFromString(actionString);
    
    if (target == nil) {
        // 这里是处理无响应请求的地方之一，这个demo做得比较简单，如果没有可以响应的target，就直接return了。实际开发过程中是可以事先给一个固定的target专门用于在这个时候顶上，然后处理这种请求的
        [self NoTargetActionResponseWithTargetString:targetClassString selectorString:actionString originParams:params];
        return nil;
    }
    
    if (shouldCacheTarget) {
        self.cachedTarget[targetClassString] = target;
    }

    if ([target respondsToSelector:action]) {
        return [self safePerformAction:action target:target params:params];
    } else {
        // 这里是处理无响应请求的地方，如果无响应，则尝试调用对应target的notFound方法统一处理
        SEL action = NSSelectorFromString(@"notFound:");
        if ([target respondsToSelector:action]) {
            return [self safePerformAction:action target:target params:params];
        } else {
            // 这里也是处理无响应请求的地方，在notFound都没有的时候，这个demo是直接return了。实际开发过程中，可以用前面提到的固定的target顶上的。
            [self NoTargetActionResponseWithTargetString:targetClassString selectorString:actionString originParams:params];
            [self.cachedTarget removeObjectForKey:targetClassString];
            return nil;
        }
    }
}

- (void)releaseCachedTargetWithFullTargetName:(NSString *)fullTargetName
{
    /*
     fullTargetName在oc环境下，就是Target_XXXX。要带上Target_前缀。暂时不支持swift。
     */
    if (fullTargetName == nil) {
        return;
    }
    [self.cachedTarget removeObjectForKey:fullTargetName];
}

#pragma mark - private methods

- (void)NoTargetActionResponseWithTargetString:(NSString *)targetString selectorString:(NSString *)selectorString originParams:(NSArray *)originParams
{
    SEL action = NSSelectorFromString([NSString stringWithFormat:@"%@response:",self.actionPrefix]);
    NSObject *target = [[NSClassFromString([NSString stringWithFormat:@"%@NoTargetAction",self.targetPrefix]) alloc] init];
    
    [self safePerformAction:action target:target params:originParams];
}

- (id)safePerformAction:(SEL) action target:(NSObject *)target params:(NSArray *)params
{
    
    if (target == nil) {
        //传入的target不存在 就抛异常
        NSString * info = @"target对象为空";
        @throw [[NSException alloc] initWithName:@"target对象为空" reason:info userInfo:nil];
        return nil;
    }
    NSMethodSignature* methodSig = [target methodSignatureForSelector:action];
    if(methodSig == nil) {
        //传入的方法不存在 就抛异常
        NSString*info = [NSString stringWithFormat:@"-[%@ %@]:unrecognized selector sent to instance",[self class],NSStringFromSelector(action)];
        @throw [[NSException alloc] initWithName:@"方法没有" reason:info userInfo:nil];
        return nil;
    }
    
    //3、、创建NSInvocation对象
    NSInvocation*invocation = [NSInvocation invocationWithMethodSignature:methodSig];
    //5、设置参数
    /*
     当前如果直接遍历参数数组来设置参数
     如果参数数组元素多余参数个数，那么就会报错
     */
    NSInteger arguments = methodSig.numberOfArguments - 2;
    /*
     如果直接遍历参数的个数，会存在问题
     如果参数的个数大于了参数值的个数，那么数组会越界
     */
    /*
     谁少就遍历谁
     */
    NSUInteger objectsCount = params.count;
    NSInteger count = MIN(arguments, objectsCount);
    for (int i = 0; i<count; i++) {
        NSObject*obj = params[i];
        //处理参数是NULL类型的情况
        if ([obj isKindOfClass:[NSNull class]]) {
            obj = nil;
        }
        [invocation setArgument:&obj atIndex:i+2];
    }
    
    //4、保存方法所属的对象
    [invocation setSelector:action];
    [invocation setTarget:target];
    
    //NSLog(@"methodReturnType = %s",signature.methodReturnType);
    //NSLog(@"methodReturnTypeLength = %zd",signature.methodReturnLength);
    const char * resultType = [methodSig methodReturnType];
    if (strcmp(resultType, @encode(void)) == 0) {
        [invocation invoke];
        return nil;
    }else if(strcmp(resultType, @encode(int)) == 0){
        int result = 0;
        [invocation invoke];
        [invocation getReturnValue:&result];
        return @(result);
    }else if(strcmp(resultType, @encode(unsigned int)) == 0){
        unsigned int result = 0;
        [invocation invoke];
        [invocation getReturnValue:&result];
        return @(result);
    }else if(strcmp(resultType, @encode(long)) == 0){
        long result = 0;
        [invocation invoke];
        [invocation getReturnValue:&result];
        return @(result);
    }else if(strcmp(resultType, @encode(unsigned long)) == 0){
        unsigned long result = 0;
        [invocation invoke];
        [invocation getReturnValue:&result];
        return @(result);
    }else if(strcmp(resultType, @encode(long long)) == 0){
        long long result = 0;
        [invocation invoke];
        [invocation getReturnValue:&result];
        return @(result);
    }else if(strcmp(resultType, @encode(short)) == 0){
        short result = 0;
        [invocation invoke];
        [invocation getReturnValue:&result];
        return @(result);
    }else if(strcmp(resultType, @encode(unsigned short)) == 0){
        unsigned short result = 0;
        [invocation invoke];
        [invocation getReturnValue:&result];
        return @(result);
    }else if(strcmp(resultType, @encode(NSInteger)) == 0){
        NSInteger result = 0;
        [invocation invoke];
        [invocation getReturnValue:&result];
        return @(result);
    }else if(strcmp(resultType, @encode(NSUInteger)) == 0){
        NSUInteger result = 0;
        [invocation invoke];
        [invocation getReturnValue:&result];
        return @(result);
    }else if(strcmp(resultType, @encode(BOOL)) == 0){
        BOOL result = 0;
        [invocation invoke];
        [invocation getReturnValue:&result];
        return @(result);
    }else if(strcmp(resultType, @encode(bool)) == 0){
        bool result = 0;
        [invocation invoke];
        [invocation getReturnValue:&result];
        return @(result);
    }else if(strcmp(resultType, @encode(double)) == 0){
        double result = 0;
        [invocation invoke];
        [invocation getReturnValue:&result];
        return @(result);
    }else if(strcmp(resultType, @encode(float)) == 0){
        float result = 0;
        [invocation invoke];
        [invocation getReturnValue:&result];
        return @(result);
    }else if(strcmp(resultType, @encode(CGFloat)) == 0){
        CGFloat result = 0;
        [invocation invoke];
        [invocation getReturnValue:&result];
        return @(result);
    }else if(strcmp(resultType, @encode(char)) == 0){
        char result = 0;
        [invocation invoke];
        [invocation getReturnValue:&result];
        return @(result);
    }else if(strcmp(resultType, @encode(unsigned char)) == 0){
        unsigned char result = 0;
        [invocation invoke];
        [invocation getReturnValue:&result];
        return @(result);
    }else{
        id result = nil;
        [invocation invoke];
        //getReturnValue获取返回值
        [invocation getReturnValue:&result];
        ///将对象转为CF对象，未执行该函数会导致其返还的对象提前被释放
        CFBridgingRetain(result);
        return result;
    }
}

#pragma mark - getters and setters
- (NSMutableDictionary *)cachedTarget
{
    if (_cachedTarget == nil) {
        _cachedTarget = [[NSMutableDictionary alloc] init];
    }
    return _cachedTarget;
}

- (NSString *)targetPrefix{
    if (!_targetPrefix) {
        _targetPrefix = @"Target_";
    }
    return _targetPrefix;
}

- (NSString *)actionPrefix{
    if (!_actionPrefix) {
        _actionPrefix = @"action_";
    }
    return _actionPrefix;
}

@end
