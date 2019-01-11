//
//  WXApiManager.m
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

#import "WXApiManager.h"
#import "WXApi.h"
#import <cine/cine-Swift.h>

typedef void(^CallBack)(BOOL);
typedef void(^ShareBack)(NSString *, BOOL);

CallBack completion;
ShareBack shareCompletion;

@interface WXApiManager()<WXApiDelegate>

@end

@implementation WXApiManager

#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXApiManager alloc] init];
    });
    return instance;
}

- (void)dealloc {
    self.delegate = nil;
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        
        if (shareCompletion == nil) {
            return;
        }
        
        if (resp.errCode == WXErrCodeUserCancel) {
            NSLog(@"用户取消");
            shareCompletion(@"用户取消",NO);
        }else if (resp.errCode == WXSuccess){
            
            NSLog(@"分享成功");
            shareCompletion(@"",YES);
        }else {
            NSLog(@"分享失败");
            shareCompletion(@"",NO);
        }
        
        shareCompletion = nil;
        
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvAuthResponse:)]) {
            SendAuthResp *authResp = (SendAuthResp *)resp;
            [_delegate managerDidRecvAuthResponse:authResp];
        }
    } else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvAddCardResponse:)]) {
            AddCardToWXCardPackageResp *addCardResp = (AddCardToWXCardPackageResp *)resp;
            [_delegate managerDidRecvAddCardResponse:addCardResp];
        }
    }else if([resp isKindOfClass:[PayResp class]]){
        
        if (completion == nil) {
            return;
        }
        
        //支付返回结果，实际支付结果需要去微信服务器端查询
        if (resp.errCode == WXSuccess) {
            completion(YES);
        }else{
            completion(NO);
        }
        completion = nil;
    }
}

- (void)onReq:(BaseReq *)req {
    if ([req isKindOfClass:[GetMessageFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvGetMessageReq:)]) {
            GetMessageFromWXReq *getMessageReq = (GetMessageFromWXReq *)req;
            [_delegate managerDidRecvGetMessageReq:getMessageReq];
        }
    } else if ([req isKindOfClass:[ShowMessageFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvShowMessageReq:)]) {
            ShowMessageFromWXReq *showMessageReq = (ShowMessageFromWXReq *)req;
            [_delegate managerDidRecvShowMessageReq:showMessageReq];
        }
    } else if ([req isKindOfClass:[LaunchFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvLaunchFromWXReq:)]) {
            LaunchFromWXReq *launchReq = (LaunchFromWXReq *)req;
            [_delegate managerDidRecvLaunchFromWXReq:launchReq];
        }
    }
}
+ (void)registerWechatWithAppID:(NSString *)appID{
    [WXApi registerApp:appID];
}
+ (BOOL)isWXAppInstalled {
    return [WXApi isWXAppInstalled];
}
+ (BOOL) handleOPenUrl:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}
+ (void)sharedFriendWithTitle:(NSString *)title description:(NSString *)description image:(UIImage *)image urlString:(NSString *)urlString callBack:(void(^_Nonnull)(NSString * _Nonnull , BOOL )) completionBlock {
    
    [self sharedFriendWithTitle:title description:description image:image urlString:urlString isTimeLine:true callBack:completionBlock];
}

+ (void) sharedFriendWithTitle:(NSString *)title description:(NSString *)description image:(UIImage *)image urlString:(NSString *)urlString isTimeLine:(BOOL)isTimeLine callBack:(void (^)(NSString * _Nonnull, BOOL))completionBlock {
    
    if (![WXApi isWXAppInstalled]) {
        return;
    }
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:image];
    WXWebpageObject *webObject = [WXWebpageObject object];
    webObject.webpageUrl = urlString;
    message.mediaObject = webObject;
    
    SendMessageToWXReq *req = [SendMessageToWXReq new];
    req.bText = NO;
    req.message = message;
    if (isTimeLine) {
        req.scene = WXSceneTimeline;
    }else {
        req.scene = WXSceneSession;
    }
    [WXApi sendReq:req];
    
    shareCompletion = completionBlock;
    
}

+ (void)sharedFriendWithImageData:(NSData *)imageData callBack:(void (^)(NSString * _Nonnull, BOOL))completionBlock {
    if (![WXApi isWXAppInstalled]) {
        return;
    }
    WXImageObject * obj = [WXImageObject object];
    obj.imageData = imageData;
    WXMediaMessage * message = [WXMediaMessage message];
    message.mediaObject = obj;
    SendMessageToWXReq * req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.scene = WXSceneTimeline;
    req.message = message;
    [WXApi sendReq:req];
    shareCompletion = completionBlock;
}

+ (void)wechatPayWithData:(NSDictionary *_Nonnull)dict callBack:(void(^_Nonnull)(BOOL)) completionBlock{
    completion = completionBlock;
    // 生成请求对象
    PayReq *req = [PayReq new];
    req.nonceStr = dict[@"nonceStr"];
    req.package = dict[@"package"];
    req.partnerId = dict[@"partnerId"];
    req.prepayId = dict[@"prepayId"];
    req.sign = dict[@"sign"];
    // 获取服务器返回的时间戳文字
    NSString *timeStamp = dict[@"timeStamp"];
    // 将文字转换为整数
    req.timeStamp = [timeStamp intValue];
    // 发起支付请求
    [WXApi sendReq:req];
}

+ (void)webViewWithUrl:(NSString *)url {
    // 微信已废弃该接口，不能调用推广公众号
    JumpToBizProfileReq *profileReq = [[JumpToBizProfileReq alloc] init];

    profileReq.username = @"gh_c74309f3c77a";
    
    profileReq.profileType = WXBizProfileType_Normal;
    
    [WXApi sendReq:profileReq];
    
}

+ (void)tempSessionWithUserName:(NSString *)userName {
    // 微信已废弃该接口
    OpenTempSessionReq * req = [[OpenTempSessionReq alloc] init];
    
    req.username = userName;
    
    req.sessionFrom = @"default";
    
    [WXApi sendReq:req];
    
}

@end
