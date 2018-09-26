//
//  ViewController.m
//  DNLongImage
//
//  Created by dingxiao on 2018/9/26.
//  Copyright © 2018 AwesomeDennis. All rights reserved.
//

#import "ViewController.h"
#import "WKWebView+Tofile.h"
#import <WebKit/WebKit.h>

@interface ViewController ()<WKNavigationDelegate, UIDocumentInteractionControllerDelegate>
@property (nonatomic, strong) UIDocumentInteractionController *docInteractionController;
@property (nonatomic, strong) WKWebView *webview;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"To image"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(convertToImage:)];
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"To PDF"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(convertToPDF:)];
    
    
    [self docInteractionController];
    [self webview];
    self.view.autoresizesSubviews = YES;
    
}

- (void)convertToImage:(UIBarButtonItem *)item{
    UIImage *image = [self.webview imageRepresentation];
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *imagePath = [documentPath stringByAppendingPathComponent:@"temp.png"];
    BOOL result = [imageData writeToFile:imagePath atomically:YES];
    if (result) {
        _docInteractionController.URL = [NSURL fileURLWithPath:imagePath];
        [_docInteractionController presentPreviewAnimated:YES];
    }
}

- (void)convertToPDF:(UIBarButtonItem *)item{
    NSData *pdfData = [self.webview PDFData];
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *pdfPath = [documentPath stringByAppendingPathComponent:@"temp.pdf"];
    BOOL result = [pdfData writeToFile:pdfPath atomically:YES];
    if (result) {
        _docInteractionController.URL = [NSURL fileURLWithPath:pdfPath];
        [_docInteractionController presentPreviewAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIDocumentInteractionControllerDelegate Methods
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller{
    return self;
}

#pragma mark -
#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.title = webView.title;
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [webView evaluateJavaScript:@"document.body.innerText='Request Failed'" completionHandler:NULL];
}

#pragma mark - getter

- (WKWebView *)webview {
    if (!_webview) {
        _webview = [[WKWebView alloc] initWithFrame:self.view.bounds];
        _webview.navigationDelegate = self;
        _webview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_webview loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"AA" ofType:@"html"]]]];
        [self.view addSubview:_webview];
    }
    return _webview;
}

- (UIDocumentInteractionController *)docInteractionController {
    if (!_docInteractionController) {
        _docInteractionController = [[UIDocumentInteractionController alloc] init];
        _docInteractionController.delegate = self;
    }
    return _docInteractionController;
}

@end
