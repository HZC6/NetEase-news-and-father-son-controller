//
//  ViewController.m
//  网易新闻
//
//  Created by mac1 on 16/8/15.
//  Copyright © 2016年 hzc. All rights reserved.
//

#import "ViewController.h"
#import "TopBarViewController.h"
#import "HotClickViewController.h"
#import "VideoViewController.h"
#import "SocialViewController.h"
#import "ReaderViewController.h"
#import "ScienceViewController.h"

#define KScreenW [UIScreen mainScreen].bounds.size.width
#define KScreenH [UIScreen mainScreen].bounds.size.height


@interface ViewController ()<UIScrollViewDelegate>{
    
    UIScrollView *titleScrollView;
    UIScrollView *contentScrollview;
    
    
}

@property(nonatomic,weak)UIButton *clickBtn;

@property(nonatomic,strong)NSMutableArray *buttonArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"网易新闻";
    //ios7以后，导航控制器会随机给一个ScrollView增加一个额外滚动区域
    self.automaticallyAdjustsScrollViewInsets = NO;
    //1 创建标题scrollview
    [self createTitleScrollview];
    //2 创建内容scrollView
    [self createContentScrollview];
    //3 创建所有子控器
    [self setupAllChildViewController];
    //4 设置所有标题
    [self setupTitle];

    
    
}

- (NSMutableArray*)buttonArray{
    
    if (_buttonArray == nil) {
        
        _buttonArray = [NSMutableArray array];
    }
    
    
    return _buttonArray;
}

#pragma mark -
#pragma mark - 切换标题改变颜色方法
- (void)changeButtonColor:(UIButton *)btn{
    
    self.clickBtn.transform = CGAffineTransformIdentity;
    [self.clickBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.transform = CGAffineTransformMakeScale(1.2, 1.2);
    self.clickBtn = btn;
    
    [self titleCenter:btn];
}
#pragma mark -
#pragma mark - 标题居中
- (void)titleCenter:(UIButton *)btn{
    
    CGFloat offsetX = btn.center.x - KScreenW*0.5;
    if (offsetX < 0) {
        
        offsetX = 0;
    }else if (offsetX > titleScrollView.contentSize.width-KScreenW){
        
        offsetX = titleScrollView.contentSize.width-KScreenW;
    }
    
    [titleScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
}
#pragma mark -
#pragma mark - 加载子视图的方法

- (void)loadSubviews:(NSInteger)i{
    
    UIViewController *vc = self.childViewControllers[i];
    UIView *slectView = vc.view;
    slectView.frame = CGRectMake(i*KScreenW, 0, KScreenW, KScreenH);
    [contentScrollview addSubview:slectView];
    
}

#pragma mark -
#pragma mark - button点击方法
- (void)clickButton:(UIButton *)btn{
    
    //获取tag值
    NSInteger i = btn.tag;
    
    [self changeButtonColor:btn];
    
    [self loadSubviews:i];
    //滚到指定的位置
    contentScrollview.contentOffset = CGPointMake(i*KScreenW, 0);
   
    
    
}
#pragma mark -
#pragma mark - 设置标题
- (void)setupTitle{
    
    NSInteger count = self.childViewControllers.count;
    CGFloat btnW = 100;
    CGFloat btnH = titleScrollView.bounds.size.height;
    CGFloat btnX = 0;
    for (NSInteger i=0; i<count; i++) {
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIViewController *vc = self.childViewControllers[i];
        [titleButton setTitle:vc.title forState:UIControlStateNormal];
        btnX = i*btnW;
        titleButton.frame = CGRectMake(btnX, 0, btnW, btnH);
        titleButton.tag = i;
        
        [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [titleButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [titleScrollView addSubview:titleButton];
        
        //设置标题的滚动范围
        titleScrollView.contentSize = CGSizeMake(count*btnW, 0);
        titleScrollView.showsHorizontalScrollIndicator = NO;
        titleScrollView.showsVerticalScrollIndicator = NO;
        
        [self.buttonArray addObject:titleButton];
 
        if (i == 0) {
            
            [self clickButton:titleButton];

        }
        
        
       
    }
    
  
    contentScrollview.contentSize = CGSizeMake(self.childViewControllers.count*KScreenW, 0);
    
}
#pragma mark -
#pragma mark - 创建所有子控器
- (void)setupAllChildViewController{
    
    //头条
    TopBarViewController *topVc = [[TopBarViewController alloc]init ];
    topVc.title = @"头条";
    [self addChildViewController:topVc];
    
    //热点
    HotClickViewController *hotVc = [[HotClickViewController alloc]init];
    hotVc.title = @"热点";
    [self addChildViewController:hotVc];
    
    //社会
    SocialViewController *socialVc = [[SocialViewController alloc]init ];
    socialVc.title = @"社会";
    [self addChildViewController:socialVc];
    
    //视频
    VideoViewController *videoVc = [[VideoViewController alloc]init];
    videoVc.title = @"视频";
    [self addChildViewController:videoVc];
    
    //订阅
    ReaderViewController *readVc = [[ReaderViewController alloc]init ];
    readVc.title = @"订阅";
    [self addChildViewController:readVc];
    
    //科技
    ScienceViewController *scienceVc = [[ScienceViewController alloc]init];
    scienceVc.title = @"科技";
    [self addChildViewController:scienceVc];
    
    
    
}
#pragma mark -
#pragma mark - 创建标题scrollview
- (void)createTitleScrollview{
    
    CGFloat y;
    if (self.navigationController.navigationBar.hidden == YES) {
        
         y = 20;
        
    }else{
        
        y = 64;
    }
    titleScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, y, self.view.frame.size.width, 50)];

    [self.view addSubview:titleScrollView];
    
}

#pragma mark -
#pragma mark - 创建内容scrollView
- (void)createContentScrollview{
    
    CGFloat y = CGRectGetMaxY(titleScrollView.frame);
   contentScrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height-y)];
    
    //横向滚动条隐藏
    contentScrollview.showsHorizontalScrollIndicator = NO;
    //分页
    contentScrollview.pagingEnabled = YES;
    //弹簧
    contentScrollview.bounces = NO;
    
    //设置代理
    contentScrollview.delegate = self;
   
    [self.view addSubview:contentScrollview];
    
}

#pragma mark -
#pragma mark - 滚动代理方法


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger i = scrollView.contentOffset.x/KScreenW;
    UIButton *button = self.buttonArray[i];
    
    [self changeButtonColor:button];
    
    [self loadSubviews:i];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger i = scrollView.contentOffset.x/KScreenW;
    
    NSInteger leftIndex = i;
    NSInteger rightIndex = i+1;
 
    UIButton *leftBtn = self.buttonArray[leftIndex];
    UIButton *rightBtn;
    
    if (rightIndex < self.childViewControllers.count) {
        rightBtn = self.buttonArray[rightIndex];
    }
    
    
    CGFloat scalR = scrollView.contentOffset.x/KScreenW;
    scalR = scalR-leftIndex;
    CGFloat scalL = 1 -scalR;
    
    
   // 0~1 => 1 ~ 1.3
    //缩放按钮
    leftBtn.transform = CGAffineTransformMakeScale(scalL*0.3+1, scalL*0.3+1);
    rightBtn.transform = CGAffineTransformMakeScale(scalR*0.3+1, scalR*0.3+1);
    //颜色渐变
    
    UIColor *leftColor = [UIColor colorWithRed:scalL green:0 blue:0 alpha:1];
    UIColor *righttColor = [UIColor colorWithRed:scalR green:0 blue:0 alpha:1];
    
    [rightBtn setTitleColor:righttColor forState:UIControlStateNormal];
    [leftBtn setTitleColor:leftColor forState:UIControlStateNormal];
}


@end
