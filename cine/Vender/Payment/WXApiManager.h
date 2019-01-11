//
//  WXApiManager.h
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

/**
 * @ 微信SDK管理对象
 * @ 管理 WXApi
 * @
 */

#import <UIKit/UIKit.h>
@class GetMessageFromWXReq;
@class ShowMessageFromWXReq;
@class LaunchFromWXReq;
@class SendMessageToWXResp;
@class SendAuthResp;
@class AddCardToWXCardPackageResp;

@protocol WXApiManagerDelegate <NSObject>

@optional

- (void)managerDidRecvGetMessageReq:(GetMessageFromWXReq *_Nullable)request;

- (void)managerDidRecvShowMessageReq:(ShowMessageFromWXReq *_Nullable)request;

- (void)managerDidRecvLaunchFromWXReq:(LaunchFromWXReq *_Nullable)request;

- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *_Nullable)response;

- (void)managerDidRecvAuthResponse:(SendAuthResp *_Nullable)response;

- (void)managerDidRecvAddCardResponse:(AddCardToWXCardPackageResp *_Nullable)response;

@end

@interface WXApiManager : NSObject

@property (nonatomic, assign) _Nullable id <WXApiManagerDelegate> delegate;
/// 单利对象
+ (instancetype _Nonnull )sharedManager;
/// 判断微信是否安装
+ (BOOL) isWXAppInstalled;
/// 向微信 Sdk 注册 appId
+ (void) registerWechatWithAppID:(NSString *_Nonnull)appID;
/// 判断微信的 openUrl 是否可用
+ (BOOL) handleOPenUrl:(NSURL *_Nonnull)url;
/// 分享到朋友圈
+ (void)sharedFriendWithTitle:(NSString *_Nullable)title description:(NSString *_Nullable)description image:(UIImage *_Nullable)image urlString:(NSString *_Nullable)urlString callBack:(void(^_Nonnull)(NSString * _Nonnull , BOOL )) completionBlock;
+ (void)sharedFriendWithTitle:(NSString *_Nullable)title description:(NSString *_Nullable)description image:(UIImage *_Nullable)image urlString:(NSString *_Nullable)urlString isTimeLine:(BOOL)isTimeLine callBack:(void(^_Nonnull)(NSString * _Nonnull , BOOL )) completionBlock;
/// 分享图片到朋友圈
+ (void)sharedFriendWithImageData:(NSData * _Nonnull)imageData callBack:(void(^_Nonnull)(NSString * _Nonnull , BOOL )) completionBlock;
/// 微信支付数据及支付结果的回调
+ (void)wechatPayWithData:(NSDictionary *_Nonnull)dict callBack:(void(^_Nonnull)(BOOL)) completionBlock;
/// 调用微信网页,公众号网页
+ (void)webViewWithUrl:(NSString *_Nonnull)url;
/// 发起临时对话窗口
+ (void)tempSessionWithUserName:(NSString *_Nonnull)userName;

@end
