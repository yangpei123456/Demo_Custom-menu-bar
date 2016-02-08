

#import "MainViewController.h"
#import "ArrayData.h"
#import "SubjectManageViewController.h"

@interface MainViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) UIButton *selectedBtn;
@property (weak, nonatomic) IBOutlet UIButton *tableView;

@end

@implementation MainViewController

- (void)viewWillAppear:(BOOL)animated {
    
    self.selectedBtn = nil;
    //设置代理
    self.scrollView.delegate = self;
    
    // 移除所有子元素
    for(UIButton *subView in self.scrollView.subviews) {
        [subView removeFromSuperview];
    }
    
    //向滚动视图中添加按钮
    int nextPointX = 20;
    int scrollWidth = 0;
    
    if (!self.selectedSubjectArray) {
        self.selectedSubjectArray = [ArrayData defaultSelectedSubject];
    }
    
    for (int i = 0; i < self.selectedSubjectArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *title = [self.selectedSubjectArray objectAtIndex:i];
        
        //设置普通状态（黑字白底）
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor whiteColor];
        
        //设置选中状态
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        btn.titleLabel.font  = [UIFont systemFontOfSize:16];
        
        btn.layer.cornerRadius = 10;
        btn.layer.masksToBounds = YES;
        
        
        [btn addTarget:self action:@selector(onTitleButtonClick:) forControlEvents:UIControlEventTouchUpInside];

        //设置按钮的frame
        CGRect iframe = CGRectMake(nextPointX, 15, [self getButtonByTitle:btn title:title], 25);
        btn.frame = iframe;
        [self.scrollView addSubview:btn];
        
        nextPointX += iframe.size.width;
        // 计算滚动区域大小
        scrollWidth = nextPointX + iframe.size.width;
        
    }
    //设置滚动视图内容大小
    self.scrollView.contentSize = CGSizeMake(scrollWidth-60, self.scrollView.bounds.size.height);
    
    // 设置默认选中
    if(!self.selectedBtn) {
        [self onTitleButtonClick:self.scrollView.subviews[0]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSInteger)getButtonByTitle:(UIButton *)btn title:(NSString *)title {
    UIFont *font = btn.titleLabel.font;
    CGSize size =  [title sizeWithFont:font];
    return size.width + 30;
}

- (void)onTitleButtonClick:(UIButton *)btn {
    if(self.selectedBtn != nil) {
        [self.selectedBtn setSelected:NO];
        self.selectedBtn.backgroundColor = [UIColor whiteColor];
    }
    [btn setSelected:YES];
    btn.backgroundColor = [UIColor redColor];
    self.selectedBtn = btn;
    
    // 在控件中创建一个button
    [self.tableView setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.tableView.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.tableView setTitle:[NSString stringWithFormat:@"显示【%@】的内容\n做成TableView",btn.titleLabel.text ] forState:UIControlStateNormal];
    
}
// 点击更多事件，跳转到设置页
- (IBAction)clickMore:(id)sender {
    SubjectManageViewController *subjectVC = [SubjectManageViewController initWithSelectedSubjectAndParentController:self.selectedSubjectArray parentController:self];
    [self presentViewController:subjectVC animated:YES completion:nil];
//    [self.navigationController pushViewController:subjectVC animated:NO];
}




@end
