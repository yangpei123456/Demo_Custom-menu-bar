

#import "ArrayData.h"

@implementation ArrayData

static NSArray* _allSubjectArray;
static NSArray* _defaultSelectedSubjectArray;

+(NSArray *)allArray
{
    if (!_allSubjectArray) {
        _allSubjectArray = @[@"全部",@"舞蹈",@"按摩",@"羽毛球",@"美发",@"健身",@"网球",@"家装设计",@"翻译",@"市场营销",@"平面设计",@"美食",@"绘画",@"宠物",@"UI设计",@"情感咨询",@"带跑步",@"模特",@"音乐",@"练唱歌",@"导游",@"瑜伽",@"法律",@"游泳",@"美甲",@"摄影",@"家教",@"心里咨询",@"看电影",@"逛商场",@"兼职猎头",@"文字处理",@"玩游戏",@"占卜",@"台球",@"高尔夫",@"滑雪",@"口语"
                           ];
        
    }
    return _allSubjectArray;
}

+(NSArray *)defaultSelectedSubject
{
    if (!_defaultSelectedSubjectArray) {
        _defaultSelectedSubjectArray = @[@"全部",@"舞蹈",@"按摩",@"羽毛球",@"美发",@"健身",@"网球",@"家装设计",@"翻译",@"市场营销",@"平面设计",@"美食",@"绘画",@"宠物",@"UI设计"];
        
    }
    return _defaultSelectedSubjectArray;
}


@end
