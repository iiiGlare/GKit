//
//  GApp.m
//  FakeCall
//
//  Created by Hua Cao on 12-10-17.
//
//

#import "GApp.h"
#import "GCore.h"

#ifdef UMOnlineConfigDidFinishedNotification
#import "MobClick.h"
#endif

@interface GApp ()
{
	BOOL _isForceUpdate;
}
@property (nonatomic, copy) NSString *updatePath;

@end

static GApp *_sharedApp = nil;

#define kReviewAlertTag 1
#define kUpdateAlertTag 2

@implementation GApp
@synthesize appID=_appID;
@synthesize updatePath=_updatePath;

+ (id)sharedApp
{
	if (_sharedApp==nil) {
		_sharedApp = [[GApp alloc] init];
	}
	return _sharedApp;
}

+ (NSString *)appVersion
{
	NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"]];
	return [dic valueForKey:@"CFBundleVersion"];
}

- (void)reviewWithMessage:(NSString *)message
					appID:(NSString *)appID
{
	self.appID = appID;
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
													message:message
												   delegate:self
										  cancelButtonTitle:NSLocalizedString(@"不，暂时没时间",@"")
										  otherButtonTitles:NSLocalizedString(@"好的，现在就去",@""), nil];
	alert.tag = kReviewAlertTag;
    [alert show];
}

-(void)reviewApp:(NSString*)appID{
    NSString *str = [NSString stringWithFormat:
                     @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",
                     appID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

#pragma mark - Check Update
- (void)checkUpdate
{
	
#ifdef UMOnlineConfigDidFinishedNotification
	[MobClick updateOnlineConfig];
	[MobClick checkUpdateWithDelegate:self selector:@selector(checkUpdateCallBack:)];
#endif
	
}

/*
 "current_version" = "1.0";
 path = "http://www.163.com";
 update = YES;
 "update_log" = test;
 version = "1.1";
 
 */
- (void)checkUpdateCallBack:(NSDictionary *)dic
{
	
#ifdef UMOnlineConfigDidFinishedNotification	
	_isForceUpdate = [[MobClick getConfigParams:@"force_update"] boolValue];
	BOOL update = [[dic valueForKey:@"update"] boolValue];
	NSString *title = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"有可用的新版本", @""),[dic valueForKey:@"version"]];
	NSString *message = [dic valueForKey:@"update_log"];
	self.updatePath = [dic valueForKey:@"path"];
	if (update)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
														message:message
													   delegate:self
											  cancelButtonTitle:(_isForceUpdate?nil:NSLocalizedString(@"忽略此版本", @""))
											  otherButtonTitles:NSLocalizedString(@"访问苹果商店",@""), nil];
		alert.tag = kUpdateAlertTag;
		[alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
	}
#endif
	
}

#pragma mark -
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (kReviewAlertTag==alertView.tag) {
		if (1==buttonIndex) {
			[self reviewApp:self.appID];
		}
	}else if (kUpdateAlertTag==alertView.tag){
		if (1==buttonIndex || _isForceUpdate)
		{
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.updatePath]];
		}
	}
}

#pragma mark - 
- (void)sendSMSWithRecipients:(NSArray *)recipients
						 body:(NSString *)body
					 delegate:(id<MFMessageComposeViewControllerDelegate>)delegate
{
//	if (![MFMessageComposeViewController canSendText])
//	{
//		return;
//	}
	MFMessageComposeViewController *messageViewController = [[MFMessageComposeViewController alloc] init];
    if (messageViewController) {
        [messageViewController setRecipients:recipients];
        [messageViewController setBody:body];
        if (delegate) {
            [messageViewController setMessageComposeDelegate:delegate];
        }else{
            [messageViewController setMessageComposeDelegate:(id<MFMessageComposeViewControllerDelegate>)self];
        }
        [GApplicationRootViewController() presentViewController: messageViewController
                                                       animated: YES
                                                     completion: nil];
    }
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	[controller dismissViewControllerAnimated: YES
                                   completion: nil];
}
#pragma mark - Email
- (void)sendMailWithToRecipients:(NSArray *)toRecipients
						delegate:(id<MFMailComposeViewControllerDelegate>)delegate
{
//	if (![MFMailComposeViewController canSendMail]) {
//		return;
//	}
	MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    if (mailController) {
        [mailController setToRecipients:toRecipients];
        if (delegate) {
            [mailController setMailComposeDelegate:delegate];
        }else{
            [mailController setMailComposeDelegate:(id<MFMailComposeViewControllerDelegate>)self];
        }
        [GApplicationRootViewController() presentViewController: mailController
                                                       animated: YES
                                                     completion: nil];
    }
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated: YES
                                   completion: nil];
}
@end
