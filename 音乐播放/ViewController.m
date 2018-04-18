//
//  ViewController.m
//  音乐播放
//
//  Created by 万家乐 on 2018/4/10.
//  Copyright © 2028年 万家乐. All rights reserved.
//

#import "ViewController.h"
#import "VCSecond.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isPlay = NO;
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    int n = [ud integerForKey:@"num"];
    num = n;
    [self getMusicUrl];
    [self getSystemSize];
    [self createAVPlyaer];
}

- (void) viewWillAppear:(BOOL)animated
{
    //NSLog(@"viewWillAppear 视图即将显示");
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    int n = [ud integerForKey:@"num"];
    if (num == n) {
        
    }else{
        num = n;
        [self createAVPlyaer];
        if (isPlay) {
            [_player play];
        }else{
            [_player pause];
        }
    }
}

//获取屏幕尺寸并处理UI
- (void) getSystemSize {
    _phoneWidth = [UIScreen mainScreen].bounds.size.width;
    _typeHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    _titleHeight = self.navigationController.navigationBar.frame.size.height;
    _phoneHeight = [UIScreen mainScreen].bounds.size.height - _typeHeight - _titleHeight;
    
    self.title = @"Music";
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem* btn = [[UIBarButtonItem alloc] initWithTitle:@"PlayList" style:UIBarButtonItemStylePlain target:self action:@selector(pressRight)];
    self.navigationItem.leftBarButtonItem = btn;
    
    //专辑封面
    _iView = [[UIImageView alloc] initWithFrame:CGRectMake(30,_titleHeight+_typeHeight+30,_phoneWidth-60, _phoneWidth-60)];
    _iView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Music.jpg"]];
    [self.view addSubview:_iView];
    //音乐进度条
    _musicPress = [[UISlider alloc] init];
    _musicPress.frame = CGRectMake(30,_iView.frame.origin.y+_iView.frame.size.height+30, _phoneWidth-60, 5);
    _musicPress.value = 0;
    _musicPress.maximumValue = 100;
    _musicPress.minimumValue = 0;
    [_musicPress addTarget:self action:@selector(volChange:) forControlEvents:UIControlEventValueChanged];
    _musicPress.tag = 101;
    [self.view addSubview:_musicPress];
    //歌曲名
    _label = [[UILabel alloc] initWithFrame:CGRectMake(60, (_phoneHeight-_musicPress.frame.origin.y-_musicPress.frame.size.height)/5+_musicPress.frame.origin.y, _phoneWidth-120, 20)];
    _label.text = @"歌曲名";
    _label.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:_label];
    //播放按钮
    _btnPlayer = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnPlayer.frame = CGRectMake((_phoneWidth-50)/2,(_phoneHeight-_label.frame.origin.y-_label.frame.size.height)/2+_label.frame.origin.y, 50, 40);
    [_btnPlayer setTitle:@"播放" forState:UIControlStateNormal];
    _btnPlayer.titleLabel.textAlignment = UITextAlignmentCenter;
    [_btnPlayer addTarget:self action:@selector(pressPlay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnPlayer];
    //上一首
    _btnPause = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnPause.frame = CGRectMake(30, _btnPlayer.frame.origin.y, 50, 40);
    [_btnPause setTitle:@"上一首" forState:UIControlStateNormal];
    _btnPlayer.titleLabel.textAlignment = UITextAlignmentLeft;
    [_btnPause addTarget:self action:@selector(pressLast) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnPause];
    //下一首
    _btnStop = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnStop.frame = CGRectMake(_phoneWidth-80, _btnPlayer.frame.origin.y, 50, 40);
    [_btnStop setTitle:@"下一首" forState:UIControlStateNormal];
    _btnPlayer.titleLabel.textAlignment = UITextAlignmentRight;
    [_btnStop addTarget:self action:@selector(pressNext) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnStop];
    //音量控制
    _volSlider = [[UISlider alloc] init];
    _volSlider.frame = CGRectMake(30, _phoneHeight+_typeHeight+_titleHeight-30, _phoneWidth-60, 5);
    _volSlider.maximumValue = 100;
    _volSlider.minimumValue = 0;
    [_volSlider setValue:50];
    [_volSlider addTarget:self action:@selector(volChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_volSlider];
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

- (void) pressRight
{
    //NSLog(@"press");
    VCSecond* vcSecond = [[VCSecond alloc] init];
    [self.navigationController pushViewController:vcSecond animated:YES];
}

- (void) createAVPlyaer
{
    //创建音频播放器对象
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[_urlArray objectAtIndex:num] error:nil];
    //准备播放
    [_player prepareToPlay];
    //循环播放次数
    _player.numberOfLoops = 0;
    //设置播放进度
    _player.currentTime = 0;
    //设置音量大小
    _player.volume = 0.5;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateT) userInfo:nil repeats:YES];
    _player.delegate = self;
    [self musicImageWithMusicURL:[_urlArray objectAtIndex:num]];
}

//提取音乐文件信息
- (void) musicImageWithMusicURL:(NSURL *)url {
    NSData *data = nil;
    NSString* title = nil;
    // 初始化媒体文件
    AVURLAsset *mp3Asset = [AVURLAsset URLAssetWithURL:url options:nil];
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
        }
    }
    if (!data) {
        // 如果音乐没有图片，就返回默认图片
        _iView.image =  [UIImage imageNamed:@"Music"];
    }
    _iView.image =  [UIImage imageWithData:data];
    if (title == nil) {
        // 如果音乐没有图片，就返回默认图片
        _label.text = @"";
    }
    _label.text = title;
}

//音乐播放完毕
- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    //NSLog(@"%ld",num);
    [self pressNext];
    [_timer invalidate];
}

- (void) pressPlay
{
    if (!isPlay) {
        //NSLog(@"播放音乐");
        [_player play];
        [_btnPlayer setTitle:@"暂停" forState:UIControlStateNormal];
        isPlay = YES;
    }else{
        //NSLog(@"暂停音乐");
        [_player pause];
        [_btnPlayer setTitle:@"播放" forState:UIControlStateNormal];
        isPlay = NO;
    }
    
}

- (void) pressLast
{
    if (num >0) {
        //NSLog(@"上一首");
        num --;
        [self createAVPlyaer];
        if (isPlay) {
            isPlay = NO;
            [self pressPlay];
        }
    }else{
        //NSLog(@"第一首");
    }
}

- (void) pressNext
{
    if (num < _urlArray.count-1) {
        num ++;
        //NSLog(@"下一首");
    }else{
        num = 0;
        //NSLog(@"最后一首");
    }
    [self createAVPlyaer];
    if (isPlay) {
        isPlay = NO;
        [self pressPlay];
    }
}

//更新进度条
- (void)updateT
{
    _musicPress.value = _player.currentTime/_player.duration*100;
}

- (void) volChange:(UISlider*) slilder
{
    if (slilder.tag == 101) {
        _player.currentTime = slilder.value/100*_player.duration-0.001;
    }else{
        //设置音量大小
        _player.volume = slilder.value/100;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
