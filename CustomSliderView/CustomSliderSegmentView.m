//
//  CustomSliderSegmentView.m
//  CustomSliderDemo
//
//  Created by GuoRoy on 15/11/9.
//  Copyright © 2015年 GuoRoy. All rights reserved.
//

#import "CustomSliderSegmentView.h"

@interface CustomSliderSegmentView()
{
    UIScrollView    * _contentScrollView;
    NSMutableArray  * _contentBtnArr;
    UIView          * _blockView;
    NSArray         * _DataSource;
}
@end


#define SliderHeight 35.0f
#define SliderViewBackgroundColor  [UIColor colorWithRed:240/250.0f green:241/250.0f blue:242/250.0f alpha:1.0f]
#define ButtonWidth  80.0f
#define ButtonHeight 35.0f
@implementation CustomSliderSegmentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGRect scrollRect = frame;
        scrollRect.origin.y = 0;
        scrollRect.origin.x = 0;
        if (_buttonHeight == 0)
        {
            _buttonHeight = scrollRect.size.height;
        }
        _contentScrollView = [[UIScrollView alloc] initWithFrame:scrollRect];
        [_contentScrollView setBackgroundColor:SliderViewBackgroundColor];
        [_contentScrollView setShowsVerticalScrollIndicator:NO];
        [_contentScrollView setShowsHorizontalScrollIndicator:NO];
        [self addSubview:_contentScrollView];
    }
    return self;
}


- (instancetype)initWithOrginY:(float)OrginY
{
    CGRect rect = CGRectMake(0, OrginY, [[UIScreen mainScreen] bounds].size.width, SliderHeight);
    self = [super initWithFrame:rect];
    if (self)
    {
        CGRect scrollRect = rect;
        scrollRect.origin.y = 0;
        scrollRect.origin.x = 0;
        if (_buttonHeight == 0)
        {
            _buttonHeight = scrollRect.size.height;
        }
        _contentScrollView = [[UIScrollView alloc] initWithFrame:scrollRect];
        [_contentScrollView setBackgroundColor:SliderViewBackgroundColor];
        [_contentScrollView setShowsVerticalScrollIndicator:NO];
        [_contentScrollView setShowsHorizontalScrollIndicator:NO];
        [self addSubview:_contentScrollView];
    }
    return self;
}

- (void)setSelectIndex:(NSInteger)selectIndex
{
    _selectIndex = selectIndex;
    [self scrollToIndex:selectIndex];
}

- (void)setDataSource:(NSArray *)dataSource
{
    if (_contentBtnArr)
    {
        if ([_contentBtnArr count] > 0)
        {
            [_contentBtnArr makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
        [_contentBtnArr removeAllObjects];
        _contentBtnArr = nil;
    }
    _DataSource = dataSource;
    
    NSMutableArray * arr = [NSMutableArray array];
    int i = 0;
    int offsetX = 0;
    for (NSString * title in dataSource)
    {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (!_titleColor)
        {
            _titleColor = btn.tintColor;
        }
        if (!_titleHighlightColor)
        {
            _titleHighlightColor = [UIColor grayColor];
        }
        [btn setTitleColor:_titleColor forState:UIControlStateSelected];
        [btn setTitleColor:_titleHighlightColor forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(offsetX,0, ButtonWidth, _buttonHeight)];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [btn setTitle:title forState:UIControlStateNormal];
        if (i == 0)
        {
            [self setIsShowBlock:_isShowBlock];
        }
        [btn setSelected:NO];
        offsetX += 80;
        btn.tag = i;
        [btn addTarget:self action:@selector(selectPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_contentScrollView addSubview:btn];
        [arr addObject:btn];
        i ++;
    }
    [_contentScrollView setContentSize:CGSizeMake(offsetX, _contentScrollView.frame.size.height)];
    _contentBtnArr = arr;
    if ([_contentBtnArr count] > 0)
    {
        ((UIButton *)_contentBtnArr[0]).selected = YES;
    }
}

- (void)setIsShowBlock:(BOOL)isShowBlock
{
    _isShowBlock = isShowBlock;
    if (isShowBlock)
    {
        if (_isShowBlock)
        {
            if (_blockView == nil)
            {
                _blockView = [[UIView alloc] init];
                if (_blockColor == nil)
                {
                    _blockColor = [UIColor blueColor];
                }
                [_blockView setBackgroundColor:_blockColor];
            }
            [_blockView setFrame:CGRectMake(0,_buttonHeight - 5, ButtonWidth, 5)];
            [_contentScrollView addSubview:_blockView];
        }
    }
}

- (void)scrollToIndex:(NSInteger)index
{
    CGRect rect = CGRectZero;
    rect.origin.y = 0;
    rect.size.width = ButtonWidth;
    rect.size.height = ButtonHeight;
    //根据记录的选中位置计算当前需要滑动的位置
    if (_selectIndex >= index)
    {
        rect.origin.x = ButtonWidth * (index-1) - ButtonWidth/2;
    }
    else
    {
        rect.origin.x = ButtonWidth * (index+1) + ButtonWidth/2;
    }
    
    if (index == 0)
    {
        rect = CGRectZero;
        rect.size.height = ButtonHeight;
        rect.size.width = ButtonWidth;
    }
    
    [_contentScrollView scrollRectToVisible:rect animated:YES];
    [self sliderBlockUpdateFrameWithIndex:index];
    _selectIndex = index;
    
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectView:AtIndex:)])
    {
        [_delegate didSelectView:self AtIndex:index];
    }
}

- (void)sliderBlockUpdateFrameWithIndex:(NSInteger)index
{
    if (_isShowBlock == NO)
    {
        return;
    }
    UIButton * targetBtn = [_contentBtnArr objectAtIndex:index];
    CGRect rect = [targetBtn frame];
    CGRect targetFrame = [_blockView frame];
    targetFrame.origin.x = rect.origin.x;
    [self markTransationAnimationWithView:_blockView ToFrame:targetFrame];
}

- (void)markTransationAnimationWithView:(UIView *)targetView ToFrame:(CGRect)rect
{
    [UIView beginAnimations:@"TransationAnimation" context:NULL];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    targetView.frame = rect;
    [UIView commitAnimations];
}

- (IBAction)selectPressed:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    int index = (int)btn.tag;
    
    ((UIButton *)_contentBtnArr[_selectIndex]).selected = NO;

    ((UIButton *)_contentBtnArr[index]).selected = YES;
    
    [self scrollToIndex:index];
    NSLog(@"btn ----------%d",index);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
