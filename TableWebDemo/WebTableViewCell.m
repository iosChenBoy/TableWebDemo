//
//  WebTableViewCell.m
//  TableWebDemo
//
//  Created by wln100-IOS1 on 16/10/26.
//  Copyright © 2016年 TianXing. All rights reserved.
//

#import "WebTableViewCell.h"
#define kScreen_Height      ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width       ([UIScreen mainScreen].bounds.size.width)

@interface WebTableViewCell () <UIWebViewDelegate>

@end
@implementation WebTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(10, 5, kScreen_Width-20, 1)];
        self.webView.delegate = self;
        [self.webView sizeToFit];
        self.webView.scrollView.scrollEnabled = NO;
        self.webView.backgroundColor = [UIColor whiteColor];
        self.webView.opaque = NO; //去掉下面黑线
        self.webView.scrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.webView];
    }
    return self;
}

#pragma mark - webView delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //横线超过屏幕则换行
    NSString *js = @"function imgAutoFit() { \
    var imgs = document.getElementsByTagName('p'); \
    for (var i = 0; i < imgs.length; ++i) {\
    var img = imgs[i];   \
    img.style.maxWidth = %f;   \
    img.style.wordWrap = 'break-word'; \
    } \
    }";
    js = [NSString stringWithFormat:js, kScreen_Width - 20];
    [webView stringByEvaluatingJavaScriptFromString:js];
    [webView stringByEvaluatingJavaScriptFromString:@"imgAutoFit()"];
    
    //图片大小
    [webView stringByEvaluatingJavaScriptFromString:
     @"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth;"
     "var maxwidth = 300.0;" // UIWebView中显示的图片宽度
     "for(i=0;i <document.images.length;i++){"
     "myimg = document.images[i];"
     "if(myimg.width > maxwidth){"
     "oldwidth = myimg.width;"
     "myimg.width = maxwidth;"
     "}"
     "}"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
