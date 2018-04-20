//
//  ViewController.h
//  音乐播放
//
//  Created by 万家乐 on 2018/4/10.
//  Copyright © 2018年 万家乐. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVFoundation/AVFoundation.h"
@interface ViewController : UIViewController
<
AVAudioPlayerDelegate
>

{
    UIButton* _btnPlayer;
    UIButton* _btnPause;
    UIButton* _btnStop;
    
    UILabel* _label;
    
    UIImageView* _iView;
    
    UISlider* _musicPress;
    
    UISlider* _volSlider;
    
    UISwitch* _volOn;
    
    AVAudioPlayer* _player;
    
    NSTimer* _timer;
    
    NSInteger num;
    
    BOOL isPlay;//作为是否播放的判断
    
    //用来处理音乐数据
    NSArray* _m4aArray;
    NSArray* _mp3Array;
    NSMutableArray* _musicArray;
    NSMutableArray* _urlArray;
}

@property (nonatomic,assign) float phoneWidth;

@property (nonatomic,assign) float phoneHeight;

@property (nonatomic,assign) float typeHeight;

@property (nonatomic,assign) float titleHeight;

@end

