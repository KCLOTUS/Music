//
//  VCSecond.m
//  导航栏和工具栏
//
//  Created by 万家乐 on 2018/4/4.
//  Copyright © 2018年 万家乐. All rights reserved.
//

#import "VCSecond.h"
#import "ViewController.h"

@interface VCSecond ()

@end

@implementation VCSecond

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"PlayList";
    [self getMusicUrl];
    
    //P1:视图的尺寸和位置 P2:风格
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    //自动调整子视图大小
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    //设置头部视图和尾部视图
    _tableView.tableHeaderView = nil;
    _tableView.tableFooterView = nil;
    //设置代理
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //刷新数据
    [_tableView reloadData];
    
    [self.view addSubview:_tableView];
}

//处理沙盒数据
- (void) getMusicUrl
{
    num = 0;
    //获取沙盒里所有的m4a和mp3
    _m4aArray = [NSBundle pathsForResourcesOfType:@"m4a" inDirectory:[[NSBundle mainBundle] resourcePath]];
    _mp3Array = [NSBundle pathsForResourcesOfType:@"mp3" inDirectory:[[NSBundle mainBundle] resourcePath]];
    //将获取的数据放入一个整合的数组
    _musicArray = [[NSMutableArray alloc] init];
    [_musicArray addObjectsFromArray:_m4aArray];
    [_musicArray addObjectsFromArray:_mp3Array];
    //解析整合数组内的所有url并放入一个专门放置url的数组
    _urlArray = [[NSMutableArray alloc] init];
    for (NSString *filePath in _musicArray) {
        NSURL *url = [NSURL fileURLWithPath:filePath];
        [_urlArray addObject:url];
        //NSLog(@"%@",_urlArray);
    }
}

//设置数据视图的组数
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//设置每组元素的行数
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_urlArray count];
}

//选中单元格函数
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"选中单元格！ %ld,%ld",indexPath.section,indexPath.row);
    //standardUserDefaults:获取全局唯一的实例对象
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:indexPath.row forKey:@"num"];
    //NSLog(@"%ld",indexPath.row);
    //讲当前视图控制器弹出，返回到上一级。
    [self.navigationController popViewControllerAnimated:YES];
}

//创建单元格对象
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellStr = @"cell";
    UITableViewCell* cell = [_tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        //创建一个单元格
        //P1:风格 P2:单元格复用标记
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellStr];
    }
    
    //获取音乐数据
    NSData *data = nil;
    NSString* title = nil;
    NSString* Artist = nil;
    // 初始化媒体文件
    AVURLAsset *mp3Asset = [AVURLAsset URLAssetWithURL:[_urlArray objectAtIndex:num] options:nil];
    // 读取文件中的数据
    for (NSString *format in [mp3Asset availableMetadataFormats]) {
        for (AVMetadataItem *metadataItem in [mp3Asset metadataForFormat:format]) {
            //artwork这个key对应的value里面存的就是封面缩略图，其它key可以取出其它摘要信息，例如title- 标题
            if ([metadataItem.commonKey isEqualToString:@"artwork"]) {
                data = (NSData*)metadataItem.value;//提取图片
            }
            if([metadataItem.commonKey isEqualToString:@"title"]){
                title = (NSString*)metadataItem.value;//提取歌曲名
            }
            if([metadataItem.commonKey isEqualToString:@"artist"]){
                Artist = (NSString*)metadataItem.value;//提取歌手名
            }
        }
    }
    //设置单元格内容
    cell.imageView.image = [UIImage imageWithData:data];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = Artist;
    
    num++;
    return cell;
}

//设置单元格高度
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
