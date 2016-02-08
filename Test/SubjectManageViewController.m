
//

#import "SubjectManageViewController.h"
#import "ArrayData.h"
#import "MainViewController.h"
#define BUTTON_WIDTH 90
#define BUTTON_HEIGHT 30

@interface SubjectManageViewController ()<UIScrollViewDelegate>
//选中的数组
@property (strong, nonatomic) NSMutableArray *selectedSubjectArr;

//未选中数组
@property (strong, nonatomic) NSMutableArray *unSelectedSubjectArr;

@property (weak, nonatomic) MainViewController *parentController;

//选中的表头
@property (strong ,nonatomic) UIView *selectSubjectArea;
//未选中表头
@property (strong ,nonatomic) UIView *unSelectSubjectArea;

@property (strong, nonatomic) NSLayoutConstraint *widthConstrain;

@end

@implementation SubjectManageViewController
//返回对象
+ (id)initWithSelectedSubjectAndParentController:(NSArray *)subjectArr parentController:(MainViewController *)parentController {
    SubjectManageViewController *controller = [[SubjectManageViewController alloc] init];
    
    controller.selectedSubjectArr = [NSMutableArray arrayWithArray:subjectArr];
    
    controller.unSelectedSubjectArr = [NSMutableArray array];
    
    NSArray *allSubjectArr = [ArrayData allArray];
    // 计算出未被选中的集合
    for(NSString *subject in allSubjectArr) {
        if(![subjectArr containsObject:subject]) {
            [controller.unSelectedSubjectArr addObject:subject];
        }
    }

    controller.parentController = parentController;
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //画界面-头视图
    UIView* titleView = [[UIView alloc] init];
    titleView.translatesAutoresizingMaskIntoConstraints = NO;
    titleView.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:titleView];
    
    //画界面-滚动视图
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.showsVerticalScrollIndicator = FALSE;
    scrollView.showsHorizontalScrollIndicator = FALSE;

    //画按钮
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setBackgroundColor:[UIColor redColor]];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    confirmBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [confirmBtn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:scrollView];
    [self.view addSubview:confirmBtn];
    //布局滚动视图与按钮和标题
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[titleView]-(0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleView)]];
    [self.view  addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(scrollView)]];
    [self.view  addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[confirmBtn]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(confirmBtn)]];
    [self.view  addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[titleView(60)]-(0)-[scrollView]-(0)-[confirmBtn(40)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleView,scrollView,confirmBtn)]];

    [self initScrollView:scrollView];
    [self createButton:titleView];
}

-(void)createButton:(UIView*)titleView{

    UILabel *label = [[UILabel alloc] init];
    label.text = @"筛选";
    UILabel *label1 = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label1.translatesAutoresizingMaskIntoConstraints = NO;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"<<" forState:UIControlStateNormal];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    label.textAlignment = UITextAlignmentCenter;
    [button addTarget:self action:@selector(backVC) forControlEvents:UIControlEventTouchUpInside];
    
    [titleView addSubview:label1];
    [titleView addSubview:label];
    [titleView addSubview:button];
    
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[button(10)]-[label]-(0)-[label1]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button,label,label1)]];
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[button]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button,label,label1)]];
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label1]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label1)]];
    
    
    

}

/**
 返回VC
 */
-(void)backVC{

    [self dismissViewControllerAnimated:YES completion:nil];

}


/*
 * 选中区域控件，button表格绘制
 */
-(void)createSelectedArea:(UIView *)contentView {
 
    for(int i = 0; i < self.selectedSubjectArr.count; i++) {

        CGPoint point = [self getBtnPoint:i];
        
        CGRect frame = CGRectMake(point.x, point.y, BUTTON_WIDTH , BUTTON_HEIGHT);
        
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString* title = [self.selectedSubjectArr objectAtIndex:i];
        
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor redColor]];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        //设置圆角
        btn.layer.cornerRadius = 10;
        btn.layer.masksToBounds = YES;
        
        btn.frame = frame;
        //第一个button不能点击
        if (!i==0) {
        [btn addTarget:self action:@selector(moveDown:) forControlEvents:UIControlEventTouchUpInside];
        }
      
        
        [contentView addSubview:btn];
    }
}

-(void)createUnSelectedArea:(UIView *)contentView {
    for(int i = 0; i < self.unSelectedSubjectArr.count; i++) {

        CGPoint point = [self getBtnPoint:i];
        
        CGRect frame = CGRectMake(point.x, point.y, BUTTON_WIDTH, BUTTON_HEIGHT);
        
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString* title = [self.unSelectedSubjectArr objectAtIndex:i];
        
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        //设置圆角
        btn.layer.cornerRadius = 10;
        btn.layer.masksToBounds = YES;
        btn.layer.borderWidth = 1;
        
        btn.frame = frame;
        
        [btn addTarget:self action:@selector(moveUp:) forControlEvents:UIControlEventTouchUpInside];
        
        [contentView addSubview:btn];
    }
}

//滚动视图上添加个View
-(void)createUnSelectedBar:(UIView *)contentView {
    UILabel* unSelectedLabel = [[UILabel alloc] init];
    unSelectedLabel.text = @"未订阅内容";
    
    unSelectedLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:unSelectedLabel];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[unSelectedLabel]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(unSelectedLabel)]];
    
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[unSelectedLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(unSelectedLabel)]];

}

//滚动视图上添加个View
-(void)createSelectedBar:(UIView *)contentView {
    UILabel *sLabel1 = [[UILabel alloc] init];
    sLabel1.text = @"已订阅内容";
    sLabel1.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *sLabel2 = [[UILabel alloc] init];
    sLabel2.text = @"点击移除，拖动排序";
    sLabel2.translatesAutoresizingMaskIntoConstraints = NO;
    sLabel2.textColor = [UIColor redColor];
    sLabel2.font = [UIFont systemFontOfSize:14];
    //靠右
    sLabel2.textAlignment = UITextAlignmentRight;
    
    [contentView addSubview:sLabel1];
    [contentView addSubview:sLabel2];
    
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[sLabel1]-[sLabel2(==sLabel1)]-(10)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(sLabel1,sLabel2)]];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[sLabel1]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(sLabel1,sLabel2)]];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[sLabel2]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(sLabel2)]];
}

-(void)initScrollView:(UIScrollView *)scrollView {
    // 1. 创建selectedSubjectBar
    UIView *selectedSubjectBar = [[UIView alloc] init];
    selectedSubjectBar.translatesAutoresizingMaskIntoConstraints = NO;
    
    [scrollView addSubview:selectedSubjectBar];
    
    // 2. 创建选中主题的表格
    UIView *selectedView = [[UIView alloc] init];
    selectedView.translatesAutoresizingMaskIntoConstraints = NO;
    [scrollView addSubview:selectedView];

    // 3. 创建unSelectedSubjectBar
    UIView* unSelectedSubjectBar = [[UIView alloc] init];
    unSelectedSubjectBar.translatesAutoresizingMaskIntoConstraints = NO;
    unSelectedSubjectBar.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:unSelectedSubjectBar];
    //4. 创建未选中主题的表格
    UIView* unSelectedView = [[UIView alloc] init];
    unSelectedView.translatesAutoresizingMaskIntoConstraints = NO;
    [scrollView addSubview:unSelectedView];
    // 设置布局
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[selectedSubjectBar]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(selectedSubjectBar)]];
    [selectedSubjectBar addConstraint:[NSLayoutConstraint constraintWithItem:selectedSubjectBar attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:self.view.bounds.size.width - 10]];
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[unSelectedSubjectBar(==selectedSubjectBar)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(unSelectedSubjectBar,selectedSubjectBar)]];
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[selectedView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(selectedView)]];
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[unSelectedView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(unSelectedView)]];
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[selectedSubjectBar(40)][selectedView]-[unSelectedSubjectBar(40)]-[unSelectedView(400)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(selectedSubjectBar,selectedView, unSelectedSubjectBar, unSelectedView)]];
    
    // 选中区域初始化高度--view---自适应button高度
    float selectedViewHeight = [self getBtnPoint:self.selectedSubjectArr.count - 1].y + BUTTON_HEIGHT +10;
    self.widthConstrain = [NSLayoutConstraint constraintWithItem:selectedView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:selectedViewHeight];
    
    [selectedView addConstraint:self.widthConstrain];

    self.selectSubjectArea = selectedView;
    self.unSelectSubjectArea = unSelectedView;
    // 绘制子容器
    [self createSelectedBar:selectedSubjectBar];
    [self createUnSelectedBar:unSelectedSubjectBar];
    [self createSelectedArea:selectedView];
    [self createUnSelectedArea:unSelectedView];
    
}

- (void)moveUp:(UIButton *)btn {
    NSString *subject = btn.titleLabel.text;
    
    // 修改数据
    [self.unSelectedSubjectArr removeObject:subject];
    [self.selectedSubjectArr addObject:subject];
    
    // 修改按钮样式
    CGRect frame = btn.frame;
    [btn setHidden:true];
    //动漫起始点
    frame.origin.x = 10;
    frame.origin.y = 10;
    btn.frame = frame;
    
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    btn.layer.borderWidth = 0;
    //移除对象
    [btn removeFromSuperview];
    [self.selectSubjectArea addSubview:btn];
    
    // 开启动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    
    [btn setHidden:false];
    
    CGPoint point = [self getBtnPoint:self.selectedSubjectArr.count - 1];
    frame.origin.x = point.x;
    frame.origin.y = point.y;
    btn.frame = frame;
    
    float selectedViewHeight = [self getBtnPoint:self.selectedSubjectArr.count - 1].y + BUTTON_HEIGHT +10;
    self.widthConstrain.constant = selectedViewHeight;
    
    [self.view.subviews[0] layoutSubviews];
    
    [UIView commitAnimations];
    //开启未选中动漫
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    // 重新排列未选中按钮
    for(UIButton *button in self.unSelectSubjectArea.subviews) {
        NSString *title = button.titleLabel.text;
        CGPoint p = [self getBtnPoint:[self.unSelectedSubjectArr indexOfObject:title]];
        
        CGRect pFrame = button.frame;
        pFrame.origin.x = p.x;
        pFrame.origin.y = p.y;
        button.frame = pFrame;
    }
    [UIView commitAnimations];
   
    // 2. 修改点击事件--点击的btn,以免再点击还是向上飞
    [btn removeTarget:self action:@selector(moveUp:) forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:self action:@selector(moveDown:) forControlEvents:UIControlEventTouchUpInside];
}

/*
 * 获取一个按钮的坐标
 */
- (CGPoint)getBtnPoint:(NSInteger) index {
    NSInteger row = index / 4;    // 第几行，一行4个, (从0开始)
    NSInteger column = index % 4; // 第几列(从0开始)
    
    float leading = 10; // X方向缩进
    float spaceX = 10;  // X方向间隔
    
    float top = 10;
    float spaceY = 10;
    
    float x = leading + column * BUTTON_WIDTH + column * spaceX;
    float y = top + row * BUTTON_HEIGHT + row * spaceY;
    
    return CGPointMake(x, y);
 
}

- (void)moveDown:(UIButton *)btn {
    
    NSString *subject = btn.titleLabel.text;
    
    // 修改数据
    [self.selectedSubjectArr removeObject:subject];
    [self.unSelectedSubjectArr addObject:subject];
    
    // 修改按钮样式
    CGRect frame = btn.frame;
    [btn setHidden:true];
    frame.origin.x = 10;
    frame.origin.y = 10;
    btn.frame = frame;
    
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.borderWidth = 1;
    
    [btn removeFromSuperview];
    [self.unSelectSubjectArea addSubview:btn];
    
    // 开启动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    
    [btn setHidden:false];
    
    CGPoint point = [self getBtnPoint:self.unSelectedSubjectArr.count - 1];
    frame.origin.x = point.x;
    frame.origin.y = point.y;
    btn.frame = frame;
    
    float selectedViewHeight = [self getBtnPoint:self.selectedSubjectArr.count - 1].y + BUTTON_HEIGHT +10;
    self.widthConstrain.constant = selectedViewHeight;
    
    [self.view.subviews[0] layoutSubviews];
    
    [UIView commitAnimations];
    
    // 开启动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    // 重新排列选中按钮
    for(UIButton *button in self.selectSubjectArea.subviews) {
        NSString *title = button.titleLabel.text;
        CGPoint p = [self getBtnPoint:[self.selectedSubjectArr indexOfObject:title]];
        
        CGRect pFrame = button.frame;
        pFrame.origin.x = p.x;
        pFrame.origin.y = p.y;
        button.frame = pFrame;
    }
    [UIView commitAnimations];
    
    // 2. 修改点击事件
  [btn removeTarget:self action:@selector(moveDown:) forControlEvents:UIControlEventTouchUpInside];//删除下事件
  [btn addTarget:self action:@selector(moveUp:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)confirm:(UIButton *)btn {
    
//    NSLog(@"%@", self.parentController);
    self.parentController.selectedSubjectArray = [NSArray arrayWithArray:self.selectedSubjectArr];

    [self dismissViewControllerAnimated:YES completion:nil];
    


}
@end
