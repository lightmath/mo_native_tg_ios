#import <UIKit/UIKit.h>
#import "LaunchView.h"
#import "ITTUser.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
@public
    UIBackgroundTaskIdentifier m_kBackgroundTask;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LaunchView *launchView;

+(void)RunJS: (NSString*) code;
+(void)SDKLogin;
+(void)SDKLogout;
+(void)sdkLogoutBack;
+(void)facebookShareBack;
+(void)sendAccount: (ITTUser*) account;
+(void)setAccount: (ITTUser*)account;
@end
