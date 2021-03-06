//
//  XWDialVC.m
//  QwayCallDemo
//
//  Created by viviwu on 2016/10/20.
//  Copyright © 2016年 viviwu. All rights reserved.
//

#import "XWDialVC.h"
#import "AppDelegate.h"

@interface XWDialVC ()
@property (strong, nonatomic) IBOutlet UILabel *registrationStateLabel;
@property (strong, nonatomic) IBOutlet UITextField *numberTF;
@property (nonatomic, copy) NSString * dialNumber;
@property (nonatomic, copy) NSString * dialName;
@end

@implementation XWDialVC
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if (self) {
        
        //检测 sip注册状态
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(registrationUpdate:)
                                                     name:kXWCallRegistrationUpdate
                                                   object:nil];
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kXWCallRegistrationUpdate object:nil];
}

- (void)registrationUpdate:(NSNotification*)notif
{
    XWCallRegistrationState state = [[notif.userInfo objectForKey: @"state"] intValue];
    NSString * message=[notif.userInfo objectForKey: @"message"];
    NSString * stateInfo=message;
    _registrationStateLabel.text=message;
    NSLog(@"registrationUpdate:------>\n%@", notif.userInfo);
    switch (state) {
        case XWCallRegistrationNone:
            stateInfo=@"CallRegistration None";
            break;
            
        case XWCallRegistrationProgress:
            stateInfo=@"CallRegistration Progress";
            break;
            
        case XWCallRegistrationOk:
            stateInfo=@"CallRegistration Ok";
            self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
            break;
            
        case XWCallRegistrationCleared:
            stateInfo=@"CallRegistration Cleared";
            break;
            
        case XWCallRegistrationFailed:
            stateInfo=@"CallRegistration Failed";
            self.view.backgroundColor=[UIColor brownColor];
            break;
        
        default:
            break;
    }
    
    self.title=stateInfo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dialName=@"vivi";
    _dialNumber=@"13048839909";
    // Do any additional setup after loading the view.
}

- (IBAction)refreshSipConnect:(id)sender {
    [[XWCallCenter instance] proxyCoreWithAppKey:kAppID
                                        Memberid:memberid
                                       Memberkey:memberkey];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (![kUserDef_OBJ(@"sipphone") length] ||
        ![kUserDef_OBJ(@"sippw") length] ||
        ![kUserDef_OBJ(@"logintoken") length] ||
        ![kUserDef_OBJ(@"sipserver") length] ||
        ![kUserDef_OBJ(@"tcpserver") length])
    {
        self.view.backgroundColor=[UIColor brownColor];
        [[XWCallCenter instance] proxyCoreWithAppKey:kAppID
                                            Memberid:memberid
                                           Memberkey:memberkey];
    }else{
        self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    }
}
- (IBAction)stopEdit:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)makeVoipCall:(id)sender {
    [self.view endEditing:YES];
    if (_numberTF.text.length>0){
        self.dialNumber=_numberTF.text;
    }else{
        return;
    }
    [[XWCallCenter instance]call:self.dialNumber
                     displayName:self.dialName
                        transfer:NO];
}

- (IBAction)logoutAction:(id)sender {
    self.view.backgroundColor=[UIColor brownColor];
    
    [kAppDel logoutAction];
}

//- (IBAction)makeOutCall:(id)sender {
//    
//    if (self.dialNumber.length>0) {
//        if (![[self.dialNumber substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"])
//        {
//            if ([self.dialNumber rangeOfString:@"+"].location !=NSNotFound)
//            {
//                self.dialNumber  = (NSString *)[self.dialNumber  stringByReplacingOccurrencesOfString:@"+" withString:@"00"];
//            }else{
//                self.dialNumber = [NSString stringWithFormat:@"00%@%@", kUserDef_OBJ(@"countryCode"), self.dialNumber];
//            }
//        }
//        NSLog(@"%s--%@", __func__, self.dialNumber);
//        [[XWCallCenter instance]call:self.dialNumber displayName:self.dialName transfer:NO];
//    }
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
