//
//  GPayment.h
//  FakeCall
//
//  Created by Hua Cao on 12-9-22.
//
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@protocol GTransactionObserver;
@protocol GPaymentDelegate;

@interface GPayment : NSObject

+ (void)addTransactionObserver:(id<GTransactionObserver>)observer;
+ (void)makePaymentsWithProductIdentifiers:(NSArray *)productIdentifiers
								  delegate:(id<GPaymentDelegate>)delegate;

@end

@protocol GTransactionObserver <NSObject>
- (void)transactionObserverRecordTransaction:(SKPaymentTransaction *)transaction;
- (void)transactionObserverProvideContent:(NSString *)productIdentifier;
@optional
- (void)transactionObserverFailedTransaction:(SKPaymentTransaction *)transaction;
- (void)transactionObserverCanceledTransaction:(SKPaymentTransaction *)transaction;
@end

@protocol GPaymentDelegate <NSObject>
@optional
- (void)paymentCanNotMakePayments;
- (void)paymentProductsRequestDidFinish:(GPayment *)payment;
- (void)payment:(GPayment *)payment productsRequestDidFailWithError:(NSError *)error;
@end