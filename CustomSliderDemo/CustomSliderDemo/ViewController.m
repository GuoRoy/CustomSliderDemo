//
//  ViewController.m
//  CustomSliderDemo
//
//  Created by GuoRoy on 15/11/18.
//  Copyright © 2015年 GuoRoy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<CustomSliderSegmentViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CustomSliderSegmentView * sliderSegment = [[CustomSliderSegmentView alloc] initWithOrginY:30];
    [sliderSegment setTitleColor:[UIColor redColor]];
    [sliderSegment setDelegate:self];
    [sliderSegment setDataSource:@[@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h"]];
    [sliderSegment setIsShowBlock:YES];
    [self.view addSubview:sliderSegment];
    
    CGRect rect = CGRectMake(0, 100, [[UIScreen mainScreen] bounds].size.width, 35.0f);

    CustomSliderSegmentView * sliderSegmentA = [[CustomSliderSegmentView alloc] initWithFrame:rect];
    [sliderSegmentA setDelegate:self];
    [sliderSegmentA setDataSource:@[@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h"]];
    [self.view addSubview:sliderSegmentA];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CustomSliderSegmentViewDelegate -
-(void)didSelectView:(CustomSliderSegmentView *)selectView AtIndex:(NSInteger)index
{
    NSLog(@"SELECT VIEW DID SELECT AT INDEX %d",(int)index);
}

@end
