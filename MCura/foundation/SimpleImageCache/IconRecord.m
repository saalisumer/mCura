//
//  IconRecord.m


#import "IconRecord.h"
#import "ImageCache.h"
//#import "Utils.h"
//#import "Constants.h"

@implementation IconRecord

@synthesize url, icon, imageConnection=_imageConnection, activeDownload=_activeDownload, size, indexPaths;

-(id)init {
	self = [super init];
	if (self) {
		self.indexPaths = [[[NSMutableArray alloc] init] autorelease];
	}
	return self;
}

-(void)dealloc {
	[self cancelDownload];
	self.url = Nil;
	self.icon = Nil;
	self.indexPaths = Nil;
	[super dealloc];
}

-(void)cancelDownload {
	_parent = Nil;
	[_imageConnection cancel];
	self.imageConnection = Nil;
	self.activeDownload = Nil;
}

-(void)startDownloadWithUrl:(NSString*)iconUrl withParent:(ImageCache*)downloader withSize:(CGSize)sz {
	_parent = downloader;
	self.url = iconUrl;
	self.size = sz;

	NSMutableData *data = [NSMutableData data];
	self.activeDownload = data;

    // alloc+init and start an NSURLConnection; release on completion/failure
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:
                             [NSURLRequest requestWithURL:
                              [NSURL URLWithString:iconUrl]] delegate:self];
	self.imageConnection = conn;
	[conn release];
}

#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	self.activeDownload = Nil;
	self.imageConnection = Nil;

	self.icon = Nil; // TODO: use not available image
	[_parent downloadFinishedWithIconRecord:self];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    // Set appIcon and clear temporary data/image
    UIImage *image = [[UIImage alloc] initWithData:_activeDownload];
    BOOL adjustmentDesired = self.size.width != 0 && self.size.height != 0 && image != Nil; 
    if (adjustmentDesired && (image.size.width > self.size.width || image.size.height > self.size.height)) {
		UIImage* imgTemp = image;
                CGSize itemSize = CGSizeMake(self.size.width, self.size.height);
		UIGraphicsBeginImageContext(itemSize);
		CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
		[image drawInRect:imageRect];
		image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		[imgTemp release];
		self.icon = image;
    }
	else {
		self.icon = image;
		[image release];
	}

    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
	
	// TODO: use not available image
	if (image == Nil) {
	}
	
    // call our parent and tell it that our icon is ready for display
	[_parent downloadFinishedWithIconRecord:self];
}

@end
