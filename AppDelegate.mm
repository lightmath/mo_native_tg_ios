#import "AppDelegate.h"
#import "ViewController.h"
#import "conchRuntime.h"
#import "IctitanUnionSDK.h"
#import "ITTType.h"
#import "ITTUser.h"

#import <conchRuntime.h>

NSString* flatform;
NSString* userid;
NSString* token;
ITTUser *account;

Boolean isInited;

@implementation AppDelegate
+(void) RunJS:(NSString *) code{
    if(isInited){
        NSLog(@"%@", code);
        //        code = @"app.SDK.onLoginSuc(\'{\"email\" : \"shanonder@163.com\",\"accountId\" : \"12384760\",\"loginMethod\" : 0,\"isRegister\" : 0,\"token\" : \"0d174fb1d16bce44e70c2de9e9561680\"}\');";
        [[conchRuntime GetIOSConchRuntime] runJS:( code)];
    }
}
+(void) sendAccount:(ITTUser *)account{
    NSError * error = nil;
    NSDictionary *dic = [self ITTUserToDictionary:account];
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NULL error:&error];
    NSString * jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"sendAccount:%@",jsonStr);
    NSString * msg = [[NSString alloc] initWithFormat:@"%@%@%@", @"app.SDK.onLoginSuc(\'", jsonStr , @"');"  ];
    //    NSString * msg = [NSString initWithFormat:@"%@%@%@", @"app.SDK.onLoginSuc(", jsonStr , @");"  ];
    //        [[conchRuntime GetIOSConchRuntime] runJS:msg];
    [AppDelegate RunJS:msg];
    
}

+(void) SDKLogin{
    [[IctitanUnionSDK sharedInstance] login];
}

//设置用户信息
+(void) setAccount:(ITTUser*)user{
    // user.accountId   帐号唯一标识
    // user.token       登陆令牌
    // user.channelId   渠道id
    // user.appId       游戏id
    account = user;
    userid = account.accountId;
    token = account.token;
    NSLog(@"login account id:%@ , token:%@",userid, token);
    
    [AppDelegate sendAccount:user];
}

+(void) SDKLogout{
    [[IctitanUnionSDK sharedInstance] logout];
}

+(void)sdkLogoutBack {
    NSString * msg = @"app.SDK.onLogoutSuc()";
    [AppDelegate RunJS:msg];
    isInited = false;
    account = NULL;
    userid = NULL;
    token = NULL;
}

+(void)facebookShareBack {
    NSString * msg = @"app.SDK.fbShareSuc('1')";
    [AppDelegate RunJS:msg];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ;
    ViewController* pViewController  = [[ViewController alloc] init];
    _window.rootViewController = pViewController;
    [_window makeKeyAndVisible];
    
    _launchView = [[LaunchView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_window.rootViewController.view addSubview:_launchView.view];
    //不自动锁屏
    [UIApplication sharedApplication].idleTimerDisabled=YES;
    
    [[IctitanUnionSDK sharedInstance] init:ITTDebugStatusOn];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    m_kBackgroundTask = [application beginBackgroundTaskWithExpirationHandler:^{
        if(self->m_kBackgroundTask != UIBackgroundTaskInvalid )
        {
            NSLog(@">>>>>backgroundTask end");
            [application endBackgroundTask:self->m_kBackgroundTask];
            self->m_kBackgroundTask = UIBackgroundTaskInvalid;
        }
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[IctitanUnionSDK sharedInstance] applicationDidBecomeActive:application];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [[IctitanUnionSDK sharedInstance] application:application openURL:url options:options];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler{
    return [[IctitanUnionSDK sharedInstance] application:application continueUserActivity:userActivity restorationHandler:restorationHandler];
}

+ (NSDictionary *)ITTUserToDictionary:(ITTUser *)account{
    NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[account.accountId, account.token, account.channelId, account.appId, account.avatarUrl, account.nickname, account.type] forKeys:@[@"userId",@"token",@"channelId",@"appId",@"avatarUrl",@"nickname",@"type"]];
    return dic;
}

@end
