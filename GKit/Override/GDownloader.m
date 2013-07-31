//
//  GDownloader.m
//  FakeCall
//
//  Created by Hua Cao on 12-9-23.
//
//

#import "GDownloader.h"
#import "GCore.h"

#if MB_INSTANCETYPE
#import "MBProgressHUD.h"
#endif

static NSMutableArray *_cacheDownloaders = nil;

@interface GDownloader ()
#if MB_INSTANCETYPE
<MBProgressHUDDelegate>
#endif
{
	long long _expectedLength;
	long long _currentLength;
}

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *receivedData;

#if MB_INSTANCETYPE
@property (nonatomic, strong) MBProgressHUD *HUD;
#endif

- (void)start;
@end

@implementation GDownloader

+ (void)initialize
{
	_cacheDownloaders = [[NSMutableArray alloc] init];
}

+ (void)downloadWithURLString:(NSString *)urlString
					 filePath:(NSString *)filePath
{
	[GDownloader downloadWithURLString:urlString
							  filePath:filePath
							 showError:YES];
}
+ (void)downloadWithURLString:(NSString *)urlString
					 filePath:(NSString *)filePath
					showError:(BOOL)showError
{
	GDownloader *downloader = [[GDownloader alloc] init];
	downloader.urlString = urlString;
	downloader.filePath = filePath;
	downloader.isShowError = showError;
	[_cacheDownloaders addObject:downloader];
	[downloader start];

}
- (void)start
{
#if MB_INSTANCETYPE
	self.HUD = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
	_HUD.labelText = NSLocalizedString(@"Downloading...", @"");
	_HUD.delegate = self;
#endif
	NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[self.urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]
												cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
											timeoutInterval:60];
	self.connection = [NSURLConnection connectionWithRequest:theRequest delegate:self];
}

- (void)cancelDownload
{
	[self.connection cancel];
#if MB_INSTANCETYPE
	_HUD.labelText = NSLocalizedString(@"Download Cancelled", @"");
	[_HUD hide:YES afterDelay:2];
#endif
}

#pragma mark -
#pragma mark NSURLConnection delegate methods

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    /* This method is called when the server has determined that it has
	 enough information to create the NSURLResponse. It can be called
	 multiple times, for example in the case of a redirect, so each time
	 we reset the data capacity. */
	
	/* create the NSMutableData instance that will hold the received data */
	
	long long contentLength = [response expectedContentLength];
	if (contentLength == NSURLResponseUnknownLength) {
		contentLength = 500000;
	}
	self.receivedData = [NSMutableData dataWithCapacity:(NSUInteger)contentLength];
	
	_expectedLength = contentLength;
	_currentLength = 0;
#if MB_INSTANCETYPE
	_HUD.mode = MBProgressHUDModeAnnularDeterminate;
#endif
}


- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    /* Append the new data to the received data. */
    [self.receivedData appendData:data];
	
	_currentLength += [data length];
#if MB_INSTANCETYPE
	_HUD.progress = _currentLength / (float)_expectedLength;
#endif
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	if (_expectedLength==_currentLength) {
		[NSFileManager createFileAtPath:self.filePath
							   contents:self.receivedData];
#if MB_INSTANCETYPE
		[_HUD hide:YES];
#endif
	}else{
		if (_isShowError) {
			_HUD.labelText = NSLocalizedString(@"Download Failed.", @"");
			[_HUD hide:YES afterDelay:2];
		}else{
			[_HUD hide:YES];
		}
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	if (_isShowError) {
		_HUD.labelText = error.localizedDescription;
		[_HUD hide:YES afterDelay:2];
	}else{
		[_HUD hide:YES];
	}
}

#pragma mark - MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[_HUD removeFromSuperview];
	self.HUD = nil;
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:self.filePath]) {
		[[NSNotificationCenter defaultCenter] postNotificationName:kGDownloaderDidFinishNotification object:nil];
	}
	
	[_cacheDownloaders removeObject:self];
}

@end
