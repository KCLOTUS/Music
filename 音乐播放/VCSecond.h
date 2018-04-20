//
//  VCSecond.h
//  导航栏和工具栏
//
//  Created by 万家乐 on 2018/4/4.
//  Copyright © 2018年 万家乐. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVFoundation/AVFoundation.h"

@interface VCSecond : UIViewController
<UITableViewDelegate,
UITableViewDataSource,
AVAudioPlayerDelegate>

{
    //定义一个数据视图对象
    UITableView* _tableView;
    
    //用来处理音乐数据
    NSArray* _m4aArray;
    NSArray* _mp3Array;
    NSMutableArray* _musicArray;
    NSMutableArray* _urlArray;
    
    //添加导航按钮
    UIBarButtonItem* _btnEdit;
    UIBarButtonItem* _btnFinish;
    //设置编辑状态
    BOOL _isEdit;
    
    int num;
}

@end
