//
//  GApp.h
//  FakeCall
//
//  Created by Hua Cao on 12-10-17.
//
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@interface GApp : NSObject

+ (id)sharedApp;
+ (NSString *)appVersion;

@property (nonatomic, copy) NSString *appID;
- (void)reviewWithMessage:(NSString *)message
					appID:(NSString *)appID;
- (void)reviewApp:(NSString*)appID;

//
- (void)checkUpdate;

//
- (void)sendSMSWithRecipients:(NSArray *)recipients
						 body:(NSString *)body
					 delegate:(id<MFMessageComposeViewControllerDelegate>)delegate;
- (void)sendMailWithToRecipients:(NSArray *)toRecipients
						delegate:(id<MFMailComposeViewControllerDelegate>)delegate;

@end
