//
//  ViewController.m
//  TableWebDemo
//
//  Created by wln100-IOS1 on 16/10/26.
//  Copyright © 2016年 TianXing. All rights reserved.
//

#import "ViewController.h"
#import "WebTableViewCell.h"

#define kScreen_Height      ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width       ([UIScreen mainScreen].bounds.size.width)

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate>
@property (nonatomic, strong) NSArray *allData;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSDictionary *cellHeightDic;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"json" ofType:nil];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    self.allData = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];

    [self loadDataSource];
    [self loadTableView];
}

#pragma mark - loadDataSource
- (void)loadDataSource {
    self.cellHeightDic = [NSMutableDictionary dictionary];
    int value = arc4random() % (5);
    self.dataSource = self.allData[value];
}

#pragma mark - loadTableView
- (void)loadTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64) style:UITableViewStylePlain];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (IBAction)loadNextExercise:(id)sender {
    [self loadDataSource];
    [self.tableView reloadData];
}

#pragma mark - tableView delegate,datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"cell";
    WebTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell==nil) {
        cell = [[WebTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *heightDicKey = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    NSString *contentHeight = [_cellHeightDic valueForKey:heightDicKey];
    cell.webView.frame = CGRectMake(10, 5, kScreen_Width-20, ([contentHeight floatValue]-20));
    [cell.webView loadHTMLString:self.dataSource[indexPath.row] baseURL:nil];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *string = self.dataSource[indexPath.row];
    NSString *key = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    if ([_cellHeightDic.allKeys containsObject:key]) {
        NSString *height = [_cellHeightDic valueForKey:key];
        return [height floatValue];
    } else {
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[string dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, attrStr.length)];
        CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(kScreen_Width-20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
        CGFloat htmlHight = CGRectGetHeight(rect);
        CGFloat height = MAX(htmlHight+40, 60);
        NSString *heightStr = [NSString stringWithFormat:@"%.f", height];
        [_cellHeightDic setValue:heightStr forKey:key];
        return height;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
