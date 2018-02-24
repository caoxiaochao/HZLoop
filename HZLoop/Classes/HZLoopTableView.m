//
//  HZTableView.m
//  HZPeopleDeputies
//
//  Created by jh.jiang on 2018/2/8.
//  Copyright © 2018年 hztech. All rights reserved.
//

#import "HZLoopTableView.h"

static NSString *identifier = @"CellID";
@interface HZLoopTableView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSIndexPath *markedIndexPath;
@property (nonatomic,assign)NSInteger markIndex;
@end

@implementation HZLoopTableView

-(void)setDataList:(NSMutableArray *)dataList{
    _dataList = dataList;
    [self initUI];
}

-(void)initUI{
    self.tableView = [[UITableView alloc]initWithFrame:self.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableView];
    [self initData];
}

-(void)initData{
    if (_dataList == nil) {
        [self removeTimer];
        return;
    }
    
    if (_dataList.count == 1) {
        [self removeTimer];
    }else{
        //将最后一条数据插入到第一条
        id lastObj = [_dataList lastObject];
        [_dataList insertObject:lastObj atIndex:0];
        [self addTimer];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSInteger number = indexPath.row;
    if (indexPath.row == 0)
    {
        //第一条数据和最后一条数据相同
        number = self.dataList.count-1;
    }
    cell.textLabel.text = self.dataList[indexPath.row];
    cell.textLabel.textColor = _titleColor;
    cell.textLabel.font = [UIFont systemFontOfSize:_titleFont];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    _markedIndexPath = indexPath;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.clickCellBlock(indexPath.row, self.dataList[indexPath.row]);
}

- (void)addTimer{
    //初始化滚动到第二条数据(实际是第一条)
    [self.tableView setContentOffset:CGPointMake(0 , 44) animated:YES];
    _markIndex = 2;
    /*
     scheduledTimerWithTimeInterval:  滑动视图的时候timer会停止
     这个方法会默认把Timer以NSDefaultRunLoopMode添加到主Runloop上，而当你滑tableView的时候，就不是NSDefaultRunLoopMode了，这样，你的timer就会停了。
     self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(nextLabel) userInfo:nil repeats:YES];
     */
    self.timer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(nextLabel) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/**
 tableView 滚动到下一个cell
 判断最后一个 调到首个
 */
- (void)nextLabel {
    [_tableView setContentOffset:CGPointMake(0, _markIndex * 44) animated:YES];
    _markIndex++;
}

//当滚动时调用scrollView的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"%f\n%lu",self.tableView.contentOffset.y,44*self.dataList.count);
    if (self.tableView.contentOffset.y == 44*(self.dataList.count-1)) {
        //当滚动到最后一条数据时，静默跳转回第一条（数据相同，肉眼看不出来跳转了）
        _markIndex = 1;
        [_tableView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
}

-(void)setClickCellBlock:(void (^)(NSInteger, NSString *))clickCellBlock{
    _clickCellBlock = clickCellBlock;
}

- (void)removeTimer {
    
    [self.timer invalidate];
    self.timer = nil;
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}

-(void)refresh{
    if (self.tableView != nil) {
        [self.tableView reloadData];
    }
}
@end
