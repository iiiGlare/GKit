//
// Created by Cao Hua <glare.ch@gmail.com> on 2012
// Copyright 2012 GKit
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "GApp.h"
#import "GCore.h"

@interface GApp ()
@end

@implementation GApp

+ (void)reviewApp:(NSString*)appID {
    NSString *str = [NSString stringWithFormat:
                     @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",
                     appID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

+ (void)updateApp:(NSString *)appID {
    NSString *str = [NSString stringWithFormat:
                     @"https://itunes.apple.com/app/id%@",
                     appID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

//- (void)sendSMSWithRecipients:(NSArray *)recipients
//						 body:(NSString *)body
//					 delegate:(id<MFMessageComposeViewControllerDelegate>)delegate
//{
////	if (![MFMessageComposeViewController canSendText])
////	{
////		return;
////	}
//	MFMessageComposeViewController *messageViewController = [[MFMessageComposeViewController alloc] init];
//    if (messageViewController) {
//        [messageViewController setRecipients:recipients];
//        [messageViewController setBody:body];
//        if (delegate) {
//            [messageViewController setMessageComposeDelegate:delegate];
//        }else{
//            [messageViewController setMessageComposeDelegate:(id<MFMessageComposeViewControllerDelegate>)self];
//        }
//        [GApplicationRootViewController() presentViewController: messageViewController
//                                                       animated: YES
//                                                     completion: nil];
//    }
//}
//- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
//{
//	[controller dismissViewControllerAnimated: YES
//                                   completion: nil];
//}
//#pragma mark - Email
//- (void)sendMailWithToRecipients:(NSArray *)toRecipients
//						delegate:(id<MFMailComposeViewControllerDelegate>)delegate
//{
////	if (![MFMailComposeViewController canSendMail]) {
////		return;
////	}
//	MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
//    if (mailController) {
//        [mailController setToRecipients:toRecipients];
//        if (delegate) {
//            [mailController setMailComposeDelegate:delegate];
//        }else{
//            [mailController setMailComposeDelegate:(id<MFMailComposeViewControllerDelegate>)self];
//        }
//        [GApplicationRootViewController() presentViewController: mailController
//                                                       animated: YES
//                                                     completion: nil];
//    }
//}
//- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
//{
//    [controller dismissViewControllerAnimated: YES
//                                   completion: nil];
//}

@end
