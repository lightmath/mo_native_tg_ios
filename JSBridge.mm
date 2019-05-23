#import "JSBridge.h"
#import "AppDelegate.h"
#import "IctitanUnionSDK.h"
#import "ITTType.h"
#import "ITTUser.h"
#import "ITTRole.h"
#import "IctitanUnionPaymentParam.h"
#import "IctitanUnionSDK.h"
@implementation JSBridge

+(void)hideSplash
{
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.launchView hide];
}
+(void)setTips:(NSArray*)tips
{
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.launchView.tips = tips;
}
+(void)setFontColor:(NSString*)color
{
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.launchView setFontColor:color];
}
+(void)bgColor:(NSString*)color
{
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.launchView setBackgroundColor:color];
}
+(void)loading:(NSNumber*)percent
{
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.launchView setPercent:percent.integerValue];
}
+(void)showTextInfo:(NSNumber*)show
{
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.launchView showTextInfo:show.intValue > 0];
}

+(NSString *)getToken{
    extern NSString *token;
    return token;
}

+(NSString *)getAppid{
    return @"53001";
}

+(NSString *)getPackName{
    return @"com.eskyfun.crossgateios";
}

+(NSString *)getUserId{
    extern NSString *userid;
    return userid;
}

+(void)startSDK{
    extern Boolean isInited;
    extern ITTUser* account;
    
    isInited = YES;
    if(account){
        [AppDelegate sendAccount:account];
        
    }else{
        [JSBridge sdkLogin];
    }
}

+(void)sdkLogin{
    [AppDelegate SDKLogin];
}

+(void)sdkLogout {
    [AppDelegate SDKLogout];
}

+(void)selectGameServer:(NSString *)serverId :(NSString *)serverName{
//    [[Mlbb sharedInstance] selectGameServerWithServerId:serverId serverName:serverName];
}
//创角
+(void)createGameRole:(NSString *)serverId
                     :(NSString *)serverName
                     :(NSString *) roleId
                     :(NSString * ) roleName
                     :(NSString *) prof
{
    NSLog(@">>>createRole");
    ITTRole *param = [[ITTRole alloc] init];
    [param setServerId:serverId];
    [param setServerName:serverName];
    [param setRoleId:roleId];
    [param setRoleName:roleName];
    [param setRoleLevel:@"1"];
    [param setRoleProfession:prof];
    [param setSendType:ITTROLE_EVENT_CREATE];
    [[IctitanUnionSDK sharedInstance] reportRoleInfo:param];
}
//升级
+(void)roleLevelUpgrade:(NSString *) prof
                      :(NSString *) serverId
                      :(NSString *) serverName
                      :(NSString *) roleId
                      :(NSString *) roleName
                      :(NSString *) level
{
    NSLog(@">>>roleLevelUpgrade");
    ITTRole *param = [[ITTRole alloc] init];
    [param setServerId:serverId];
    [param setServerName:serverName];
    [param setRoleId:roleId];
    [param setRoleName:roleName];
    [param setRoleLevel:level];
    [param setRoleProfession:prof];
    [param setSendType:ITTROLE_EVENT_LEVELUPGRADE];
    [[IctitanUnionSDK sharedInstance] reportRoleInfo:param];
}

//进入游戏
+(void)roleReport :(NSString *) prof
                  :(NSString *) serverId
                  :(NSString *) serverName
                  :(NSString *) roleId
                  :(NSString *) roleName
                  :(NSString *) level
{
    ITTRole *param = [[ITTRole alloc] init];
    [param setServerId:serverId];
    [param setServerName:serverName];
    [param setRoleId:roleId];
    [param setRoleName:roleName];
    [param setRoleLevel:level];
    [param setRoleProfession:prof];
    [param setSendType:ITTROLE_EVENT_ENTERGAME];
    [[IctitanUnionSDK sharedInstance] reportRoleInfo:param];
}

+(void)paymentDefault:(NSString *) serverId
                     :(NSString *) serverName
                     :(NSString *) roleId
                     :(NSString *) roleName
                     :(NSString *) roleLvl
                     :(NSString *) profession
                     :(NSString *) productId
                     :(NSString *) desc
                     :(NSString *) amount
                     :(NSString *) extra
{
    IctitanUnionPaymentParam *param = [[IctitanUnionPaymentParam alloc] init];
    [param setServerId:serverId];
    [param setServerName:serverName];
    [param setRoleId:roleId];
    [param setRoleName:roleName];
    [param setRoleLevel:roleLvl];
    [param setRoleProfession:profession];
    [param setProductId:productId];
    [param setProductDescription:desc];
    [param setAmount:amount];
    [param setCurrency:@"USD"];
    [param setExtra:extra];
    
    [[IctitanUnionSDK sharedInstance] pay:param];
}

//facebook分享
+(void)facebookShare {
    NSString *shareId = @"1001";
    NSDictionary *shareParams = @{@"displayName": @"你好啊"};
    [[IctitanUnionSDK sharedInstance] shareToSocialNetwork:shareId andShareParam:shareParams];
    NSLog(@">>>facebookShare");
    
}

@end

