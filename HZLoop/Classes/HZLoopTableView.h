//
//  HZTableView.h
//  HZPeopleDeputies
//  滚动的消息
//  Created by jh.jiang on 2018/2/8.
//  Copyright © 2018年 hztech. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^clickCellBlock)(NSInteger index,NSString *titleString);
@interface HZLoopTableView : UIView

@property (nonatomic,strong) NSMutableArray *dataList;

/**
 *  字体颜色
 */
@property (nonatomic,strong) UIColor *titleColor;
/**
 *  背景颜色
 */
@property (nonatomic,strong) UIColor *BGColor;
/**
 *  字体大小
 */
@property (nonatomic,assign) CGFloat titleFont;
/**
 *  定时器
 */
@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,strong)UITableView *tableView;

/**
 *  关闭定时器
 */
- (void)removeTimer;

/**
 *  添加定时器
 */
- (void)addTimer;

/**
 *  block回调
 */
@property (nonatomic,copy)void(^clickCellBlock)(NSInteger index,NSString *titleString);

-(void)refresh;
@end
