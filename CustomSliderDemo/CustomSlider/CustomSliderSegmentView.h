//
//  CustomSliderSegmentView.h
//  CustomSliderDemo
//
//  Created by GuoRoy on 15/11/9.
//  Copyright © 2015年 GuoRoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomSliderSegmentView;

@protocol CustomSliderSegmentViewDelegate <NSObject>

- (void)didSelectView:(CustomSliderSegmentView *)selectView AtIndex:(NSInteger)index;

@end


@interface CustomSliderSegmentView : UIView
@property (assign,nonatomic) id<CustomSliderSegmentViewDelegate> delegate;
@property (assign,nonatomic) NSInteger selectIndex;

@property (nonatomic, strong) UIColor * blockColor;
@property (nonatomic, strong) UIColor * titleColor;
@property (nonatomic, strong) UIColor * titleHighlightColor;

@property (nonatomic, assign) CGFloat buttonHeight;
@property (nonatomic, assign) CGFloat buttonWidth;

@property (nonatomic, assign) BOOL isShowBlock;

- (instancetype)initWithOrginY:(float)OrginY;
- (void)setDataSource:(NSArray *)dataSource;

@end
