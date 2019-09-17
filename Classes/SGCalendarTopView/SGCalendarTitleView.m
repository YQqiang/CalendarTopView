//
//  SGCalendarTitleView.m
//  CalendarTopView
//
//  Created by sungrow on 2018/8/13.
//  Copyright © 2018年 sungrow. All rights reserved.
//

#import "SGCalendarTitleView.h"

@interface SGCalendarTitleView ()

/**
 滚动视图
 */
@property(strong, nonatomic) UIScrollView *scrollView;

/**
 滚动下划线
 */
@property(strong, nonatomic) UIView *line;

/**
 所有的Button集合
 */
@property(nonatomic, strong) NSMutableArray <UIButton *>*items;

/**
 所有的Button的宽度集合
 */
@property(nonatomic, copy) NSArray *itemsWidth;

/**
 被选中前面的宽度合（用于计算是否进行超过一屏，没有一屏则进行平分）
 */
@property(nonatomic, assign) CGFloat selectedTitlesWidth;

/**
 滚动视图的宽
 */
@property(nonatomic, assign) CGFloat navigationTabBarWidth;

@end

@implementation SGCalendarTitleView

#pragma mark - lazy

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createView];
}

#pragma mark - view
- (void)createView {
    [self loadDataAndView];
}

#pragma mark - action
-(void)loadDataAndView {
    //初始化数组
    self.items = [[NSMutableArray alloc]init];
    self.itemsWidth = [[NSArray alloc]init];
    self.selectedColor = [UIColor whiteColor];
    self.noSlectedColor = [UIColor blackColor];
    self.lineColor = [UIColor blueColor];
    self.titleFont = [UIFont systemFontOfSize:15.f];
    _navigationTabBarWidth = self.bounds.size.width;
    CGRect scrollViewRect = self.bounds;
    scrollViewRect.size.width = _navigationTabBarWidth;
    
    //初始化滚动
    if (!self.scrollView) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:scrollViewRect];
        if (@available(iOS 11.0, *)) {
            self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        self.scrollView.backgroundColor = self.backgroundColor;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:self.scrollView];
    }
}


/**
 计算宽度

 @param titles titles
 @return widths
 */
- (NSArray *)getButtonsWidthWithTitles:(NSArray *)titles {
    NSMutableArray *widths = [@[] mutableCopy];
    _selectedTitlesWidth = 0;
    for (NSString *title in titles) {
        CGSize size = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.titleFont} context:nil].size;
        CGFloat eachButtonWidth = size.width + 20.f;
        _selectedTitlesWidth += eachButtonWidth;
        NSNumber *width = [NSNumber numberWithFloat:eachButtonWidth];
        [widths addObject:width];
    }
    if (_selectedTitlesWidth < self.navigationTabBarWidth) {
        [widths removeAllObjects];
        NSNumber *width = [NSNumber numberWithFloat:self.navigationTabBarWidth/ titles.count];
        for (int index = 0; index < titles.count; index++) {
            [widths addObject:width];
        }
    }
    return widths;
}

/**
 初始化Button

 @param widths 宽度
 @return 总宽度
 */
- (CGFloat)contentWidthAndAddNavTabBarItemsWithButtonsWidth:(NSArray *)widths {
    [self cleanData];
    CGFloat buttonX = 0;
    for (NSInteger index = 0; index < widths.count; index++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonX, 0, [widths[index] floatValue], self.bounds.size.height);
        button.titleLabel.font = self.titleFont;
        button.backgroundColor = [UIColor clearColor];
        [button setTitle:self.titleArray[index] forState:UIControlStateNormal];
        [button setTitleColor:self.noSlectedColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
        
        [_items addObject:button];
        buttonX += [widths[index] floatValue];
    }
    if (widths.count) {
        [self showLineWithButtonWidth:[widths[0] floatValue]];
    }
    return buttonX;
}


/**
 选中

 @param currentIndex 下标
 */
- (void)setCurrentIndex:(NSInteger)currentIndex {
    if (_items.count > 0) {
        _currentIndex = currentIndex;
        UIButton *button = nil;
        button = _items[currentIndex];
        [button setTitleColor:self.selectedColor forState:UIControlStateNormal];
        CGFloat offsetX = button.center.x - self.navigationTabBarWidth * 0.5;
        CGFloat offsetMax = _selectedTitlesWidth - self.navigationTabBarWidth;
        if (offsetX < 0 || offsetMax < 0) {
            offsetX = 0;
        } else if (offsetX > offsetMax){
            offsetX = offsetMax;
        }
        [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
        [button.titleLabel sizeToFit];
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.2f animations:^{
            weakSelf.line.frame = CGRectMake(0, weakSelf.line.frame.origin.y, button.titleLabel.bounds.size.width + 16, weakSelf.line.frame.size.height);
            CGPoint lineCenter = weakSelf.line.center;
            lineCenter.x = button.center.x;
            weakSelf.line.center = lineCenter;
        }];
    }
}

-(void)setTitleArray:(NSArray *)titleArray {
    _titleArray = titleArray;
    _itemsWidth = [self getButtonsWidthWithTitles:titleArray];
    CGFloat contentWidth = [self contentWidthAndAddNavTabBarItemsWithButtonsWidth:_itemsWidth];
    self.scrollView.contentSize = CGSizeMake(contentWidth, 0);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_navigationTabBarWidth != self.bounds.size.width) {
        _navigationTabBarWidth = self.bounds.size.width;
        self.scrollView.frame = self.bounds;
        self.titleArray = self.titleArray;
        self.currentIndex = self.currentIndex;
    }
}

/**
 增加下划线

 @param width 下划线宽度
 */
- (void)showLineWithButtonWidth:(CGFloat)width {
    _line = [[UIView alloc] initWithFrame:CGRectMake(2.0f, self.bounds.size.height - 3.0f, width - 4.0f, 3.0f)];
    _line.layer.cornerRadius = 3;
    _line.backgroundColor = self.lineColor;
    [self.scrollView addSubview:_line];
}

- (void)cleanData {
    [_items removeAllObjects];
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}


/**
 选中事件

 @param button 按钮
 */
- (void)itemPressed:(UIButton *)button {
    NSInteger index = [_items indexOfObject:button];
    [self curSelectedIndex:index];
    
    [UIView animateWithDuration:0.1 animations:^{
        button.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            button.transform = CGAffineTransformIdentity;
        }completion:^(BOOL finished) {
        }];
    }];
}

/**
 选中的当前下标

 @param index 下标
 */
- (void)curSelectedIndex:(NSInteger)index {
    BOOL canExecute = self.currentIndex != index;
    if (self.forceSelectedIndex) {
        canExecute = YES;
    }
    if (canExecute) {
        self.currentIndex = index;
        if ([self.delegate respondsToSelector:@selector(calendarTitleView:didSelectedIndex:)]) {
            [self.delegate calendarTitleView:self didSelectedIndex:index];
        }
    }
    
    //修改选中跟没选中的Button字体颜色
    for (int i = 0; i < _items.count; i++) {
        [_items[i] setTitleColor:(i == index)?self.selectedColor:self.noSlectedColor forState:UIControlStateNormal];
    }
}

#pragma mark - setter

- (void)setLineColor:(UIColor *)LineColor {
    _lineColor = LineColor;
    self.line.backgroundColor = LineColor;
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    self.currentIndex = _currentIndex;
}

@end
