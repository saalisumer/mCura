//
//  ImageCache.h


@protocol ImageCacheDelegate;
@class IconRecord;

@interface ImageCache : NSObject
{
    NSMutableDictionary *_imageDownloadsInProgress;
    id <ImageCacheDelegate> delegate;
}

@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic, assign) id <ImageCacheDelegate> delegate;

- (void)startDownloadForUrl:(NSString*)url withSize:(CGSize)size forIndexPath:(NSIndexPath*)path; // pass 0, 0 to not perform any adjustment
- (void)cancelDownload;
- (void)downloadFinishedWithIconRecord:(IconRecord*)record;
- (UIImage*)iconForUrl:(NSString*)url;
- (void)purge:(NSInteger)maxCount;

@end

@protocol ImageCacheDelegate 
-(void)iconDownloadedForUrl:(NSString*)url forIndexPaths:(NSArray*)paths withImage:(UIImage*)img withDownloader:(ImageCache*)downloader;
@end
