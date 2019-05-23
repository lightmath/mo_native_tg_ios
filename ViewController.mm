#import "ViewController.h"
#import "IctitanUnionSDK.h"
#import "IctitanUnionDelegate.h"
#import "ITTUser.h"
#import "ITTType.h"
#import "AppDelegate.h"

@interface ViewController () <IctitanUnionDelegate>
@property (nonatomic, strong) ITTUser *user;
@end

@implementation ViewController

static ViewController* g_pIOSMainViewController = nil;
//------------------------------------------------------------------------------
+(ViewController*)GetIOSViewController
{
    return g_pIOSMainViewController;
}
//------------------------------------------------------------------------------
-(id)init
{
    self = [super init];
    if( self != nil )
    {
        g_pIOSMainViewController = self;
        return self;
    }
    return Nil;
}
//------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    //保持屏幕常亮，可以通过脚本设置
    [[IctitanUnionSDK sharedInstance] setCallBackController:self];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    self->m_pGLContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if (self->m_pGLContext)
    {
        NSLog(@"iOS OpenGL ES 3.0 context created");
    }
    else
    {
        self->m_pGLContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        if (self->m_pGLContext)
        {
            NSLog(@"iOS OpenGL ES 2.0 context created");
        }
        else
        {
            NSLog(@"iOS OpenGL ES 2.0 context created failed");
        }
    }
    m_pGLKView = (GLKView *)self.view;
    m_pGLKView.context = self->m_pGLContext;
    m_pGLKView.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    m_pGLKView.drawableStencilFormat = GLKViewDrawableStencilFormat8;
    [EAGLContext setCurrentContext:self->m_pGLContext];
    self.preferredFramesPerSecond = 10000;
    
    //conchRuntime 初始化ConchRuntime引擎
    CGRect frame = UIScreen.mainScreen.bounds;
    m_pConchRuntime = [[conchRuntime alloc]initWithView:m_pGLKView frame:frame EAGLContext:m_pGLContext downloadThreadNum:3];
}
//------------------------------------------------------------------------------
- (void)dealloc
{
    [self tearDownGL];
    if ( [EAGLContext currentContext] == self->m_pGLContext )
    {
        [EAGLContext setCurrentContext:nil];
    }
}
//------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    //conchRuntime 内存警告的时候的处理
    [m_pConchRuntime didReceiveMemoryWarning];
}
//------------------------------------------------------------------------------
- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self->m_pGLContext];
}
//------------------------------------------------------------------------------
- (void)update
{
    
}
//------------------------------------------------------------------------------
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    //conchRuntime renderFrame
    [m_pConchRuntime renderFrame];
}
//-------------------------------------------------------------------------------
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //conchRuntime touch
    [m_pConchRuntime touchesBegan:touches withEvent:event];
}
//-------------------------------------------------------------------------------
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //conchRuntime touch
    [m_pConchRuntime touchesMoved:touches withEvent:event];
}
//-------------------------------------------------------------------------------
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //conchRuntime touch
    [m_pConchRuntime touchesEnded:touches withEvent:event];
}
//-------------------------------------------------------------------------------
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    //conchRuntime touch
    [m_pConchRuntime touchesCancelled:touches withEvent:event];
}
//-------------------------------------------------------------------------------
-(NSUInteger)supportedInterfaceOrientations
{
    /*
     UIInterfaceOrientationMaskPortrait,             ===2
     UIInterfaceOrientationMaskPortraitUpsideDown,   ===4
     UIInterfaceOrientationMaskLandscapeLeft,        ===8
     UIInterfaceOrientationMaskLandscapeRight,       ===16
     */
    return [conchConfig GetInstance]->m_nOrientationType;
}
//-------------------------------------------------------------------------------
- (BOOL)shouldAutorotate
{
    return YES;//支持转屏
}
//-------------------------------------------------------------------------------
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.view.frame = m_pConchRuntime->m_currentFrame;
}

// 初始化回调
- (void)IctitanUnionInitCallback:(UnionSdkCallbackCode)code andMessage:(NSString *)message {
    if (ITTCodeSuc == code) {
        //初始化成功
        NSLog(@"初始化成功");
    } else if (ITTCodeFail == code) {
        //初始化失败
        NSLog(@"初始化失败，msg=%@",message);
    }
}

// 登录回调
- (void)IctitanUnionLoginCallback:(UnionSdkCallbackCode)code andMessage:(NSString *)message andUser:(ITTUser *)user {
    if (ITTCodeSuc == code) {
        //登录成功
        NSLog(@"登录成功");
        _user = user;
        // user.accountId   帐号唯一标识
        // user.token       登陆令牌
        // user.channelId   渠道id
        // user.appId       游戏id
        // user.avatarUrl   用户头像URL
        // user.nickname    昵称
        // user.type        帐号类型(facebook,google,apple,guest,amazon)
//        NSLog(@"login account id:%@ , token:%@",user.accountId, user.token);
        
        [AppDelegate setAccount:user];
    } else if (ITTCodeFail == code) {
        //登录失败
        NSLog(@"登录失败：%@", message);
    }
}

// 注销回调
- (void)IctitanUnionLogoutCallback:(UnionSdkCallbackCode)code andMessage:(NSString *)message {
    if (ITTCodeSuc == code) {
        //注销成功
        NSLog(@"注销成功");
        _user = nil;
        [AppDelegate sdkLogoutBack];
    } else if (ITTCodeFail == code) {
        //注销失败
        NSLog(@"注销失败，msg=%@", message);
    }
}

// 支付回调
- (void)IctitanUnionPayCallback:(UnionSdkCallbackCode)code andMessage:(NSString *)message{
    if(ITTCodeSuc==code){
        //支付成功，订单数据通过服务端接口回调
        NSLog(@"支付成功");
    }
    else if (ITTCodeFail==code){
        //支付失败
        NSLog(@"支付失败，msg=%@",message);
    }
}


// 分享回调
- (void)IctitanUnionShareToSocialNetworkCallback:(UnionSdkCallbackCode)code andMessage:(NSString *)message {
    if (ITTCodeSuc == code) {
        //分享成功
        NSLog(@"分享成功");
        [AppDelegate facebookShareBack];
    } else if (ITTCodeFail == code){
        //分享失败
        NSLog(@"分享失败，msg=%@", message);
    }
}


@end
