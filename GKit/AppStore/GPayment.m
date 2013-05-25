//
//  GPayment.m
//  FakeCall
//
//  Created by Hua Cao on 12-9-22.
//
//

#import "GPayment.h"
#import "GCore.h"
//#import "MBProgressHUD.h"

#pragma mark - 
@interface GPaymentTransactionObserver : NSObject
<SKPaymentTransactionObserver>
//, MBProgressHUDDelegate>

@property (nonatomic, weak) id<GTransactionObserver> observer;
//@property (nonatomic, strong) MBProgressHUD *HUD;

@end

@implementation GPaymentTransactionObserver

#pragma mark - SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions //__OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
{
	for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
			case SKPaymentTransactionStatePurchasing:
                break;
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}

#pragma mark - 
- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
	GPRINT(@"completeTransaction");
	
//	[self.HUD hide:YES];
	
    // Your application should implement these two methods.
	[_observer transactionObserverRecordTransaction:transaction];
	[_observer transactionObserverProvideContent:transaction.payment.productIdentifier];
	
    // Remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
	GPRINT(@"restoreTransaction");
	
//	[self.HUD hide:YES];
	
    // Your application should implement these two methods.
	[_observer transactionObserverRecordTransaction:transaction.originalTransaction];
	[_observer transactionObserverProvideContent:transaction.originalTransaction.payment.productIdentifier];
	
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
	GPRINT(@"failedTransaction");
	
//	[self.HUD hide:YES];
	
    if (transaction.error.code != SKErrorPaymentCancelled) {
        if ([_observer respondsToSelector:@selector(transactionObserverFailedTransaction:)]) {
			[_observer transactionObserverFailedTransaction:transaction];
		}else{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
															message:transaction.error.localizedDescription
														   delegate:nil
												  cancelButtonTitle:NSLocalizedString(@"I know",@"")
												  otherButtonTitles:nil];
			[alert show];
		}
    }else{
		if ([_observer respondsToSelector:@selector(transactionObserverCanceledTransaction:)]) {
			[_observer transactionObserverCanceledTransaction:transaction];
		}
	}
	
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

#pragma mark - MBProgressHUDDelegate
//- (void)hudWasHidden:(MBProgressHUD *)hud
//{
//	[self.HUD removeFromSuperview];
//	self.HUD = nil;
//}


@end

#pragma mark -
@interface GPayment ()
<SKProductsRequestDelegate>

@property (nonatomic, strong) NSArray *productIdentifiers;
@property (nonatomic, unsafe_unretained) id<GPaymentDelegate> delegate;

@property (nonatomic, strong) SKProductsRequest *productsRequest;
@property (nonatomic, strong) NSArray *validProducts;

@end

static GPaymentTransactionObserver *_sharedTransactionObserver = nil;
static NSMutableArray *_sharedPayments = nil;

@implementation GPayment
@synthesize
productIdentifiers = _productIdentifiers,
delegate = _delegate;
@synthesize
productsRequest = _productsRequest,
validProducts = _validProducts;

+ (void)initialize
{
	_sharedTransactionObserver = [[GPaymentTransactionObserver alloc] init];
	_sharedPayments = [[NSMutableArray alloc] init];
}

+ (void)addTransactionObserver:(id<GTransactionObserver>)observer
{
	_sharedTransactionObserver.observer = observer;
	[[SKPaymentQueue defaultQueue] addTransactionObserver:_sharedTransactionObserver];
}
+ (void)makePaymentsWithProductIdentifiers:(NSArray *)productIdentifiers
								  delegate:(id<GPaymentDelegate>)delegate
{
	//Determine whether payments can be processed.
	if ([SKPaymentQueue canMakePayments]) {
		//show hud
//		_sharedTransactionObserver.HUD = [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] windows] objectAtIndex:0] animated:YES];
//		_sharedTransactionObserver.HUD.delegate = _sharedTransactionObserver;
//		_sharedTransactionObserver.HUD.labelText = NSLocalizedString(@"Purchasing...", @"");
		//Retrieve information about products
		GPayment *payment = [[GPayment alloc] init];
		payment.delegate = delegate;
		payment.productIdentifiers = productIdentifiers;
		payment.productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:productIdentifiers]];
		payment.productsRequest.delegate = payment;
		[_sharedPayments addObject:payment];
		[payment.productsRequest start];
	}else{
		//can not make payments
		if (delegate && [delegate respondsToSelector:@selector(paymentCanNotMakePayments)]) {
			[delegate paymentCanNotMakePayments];
		}else{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
															message:NSLocalizedString(@"Payments can not be processed.", @"")
														   delegate:nil
												  cancelButtonTitle:NSLocalizedString(@"I know",@"")
												  otherButtonTitles:nil];
			[alert show];
		}
	}
}

#pragma mark - SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	GPRINT(@"productsRequestReceiveResponse");
	self.validProducts = response.products;
	[_validProducts enumerateObjectsUsingBlock:^(SKProduct *obj, NSUInteger idx, BOOL *stop){

		//enumerate valid products
//		NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
//		[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
//		[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
//		[numberFormatter setLocale:obj.priceLocale];
//		NSString *formattedString = [numberFormatter stringFromNumber:obj.price];		
//		GPRINT(@"\ntitle:%@\ndes:%@\nprice:%@",obj.localizedTitle,obj.localizedDescription,formattedString);
		
		//create a payment object and add it to the payment queue
		SKPayment *payment = [SKPayment paymentWithProduct:obj];
		[[SKPaymentQueue defaultQueue] addPayment:payment];
		
	}];
	
	if (_validProducts.count == 0)
	{
//		[_sharedTransactionObserver.HUD hide:YES];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
														message:NSLocalizedString(@"Payments can not be processed.", @"")
													   delegate:nil
											  cancelButtonTitle:NSLocalizedString(@"I know",@"")
											  otherButtonTitles:nil];
		[alert show];
	}
}
- (void)requestDidFinish:(SKRequest *)request
{
	GPRINT(@"paymentProductsRequestDidFinish");
	if (_delegate && [_delegate respondsToSelector:@selector(paymentProductsRequestDidFinish:)]) {
		[_delegate paymentProductsRequestDidFinish:self];
	}
	[_sharedPayments removeObject:self];
}
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
	GPRINT(@"productsRequestDidFailWithError");
//	[_sharedTransactionObserver.HUD hide:YES];
	if (_delegate && [_delegate respondsToSelector:@selector(payment:productsRequestDidFailWithError:)]) {
		[_delegate payment:self productsRequestDidFailWithError:error];
	}else{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
														message:error.localizedDescription
													   delegate:nil
											  cancelButtonTitle:NSLocalizedString(@"I know",@"")
											  otherButtonTitles:nil];
		[alert show];
	}
	[_sharedPayments removeObject:self];
}

@end
