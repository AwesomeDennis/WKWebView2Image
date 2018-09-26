//
//  WKWebView+Tofile.h
//  DNLongImage
//
//  Created by dingxiao on 2018/9/26.
//  Copyright © 2018 AwesomeDennis. All rights reserved.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKWebView (Tofile)
- (UIImage *)imageRepresentation;

- (NSData *)PDFData;
@end

NS_ASSUME_NONNULL_END
