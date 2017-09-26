//
//  BLCalendarViewController.m
//  calendar
//
//  Created by boundlessocean on 2017/9/24.
//  Copyright © 2017年 lemon. All rights reserved.
//

#import "BLCalendarViewController.h"
@interface BLCalendarViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIPickerView *pickView;
@property (strong, nonatomic) IBOutlet UIView *bgView;

@end
typedef enum : NSUInteger {
    BLComponentTypeMonth,    // 月
    BLComponentTypeDay,      // 日
    BLComponentTypeHour,
    BLComponentTypeSecond
} BLComponentType;
@implementation BLCalendarViewController{
    NSString *_currentDate;
    
    NSMutableArray *_monthArray;
    NSMutableArray *_dayArray;
    NSMutableArray *_hourArray;
    NSMutableArray *_secondArray;
    
}
- (IBAction)sureButtonClick:(id)sender {
    BLCalendarModel *model = [self calculateSelectedDate];
    !_callBackSelectedDate ? : _callBackSelectedDate(model);
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpYMDateDic];
    [self initianizeDefaultDate];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _bgView.layer.cornerRadius = 4;
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [self showDataLabel];
    [self showAnimation];
}

#pragma mark - - get

/** 获取每月的天数 */
- (NSMutableArray *)dayArray{
    
    _dayArray = [NSMutableArray arrayWithCapacity:0];
    
    NSInteger year = [[_currentDate substringToIndex:4] integerValue] ;
    NSInteger month = [[_monthArray objectAtIndex:[_pickView selectedRowInComponent:0]] integerValue];
    NSInteger maxDay = 31;
    if (year % 400 == 0 && month == 2) {
        maxDay = 29;
    } else if ((year % 100 != 0) && (year % 4 == 0) && month == 2){
        maxDay = 29;
    } else if (month == 2){
        maxDay = 28;
    } else if ((month % 2 != 0 && month < 8) || month == 8 || (month % 2 == 0 && month > 8)){
        maxDay = 31;
    } else {
        maxDay = 30;
    }
    for (NSInteger i = 1; i <= maxDay; i++) {
        [_dayArray addObject:[NSString stringWithFormat:@"%@%ld日",i < 10 ? @"0" : @"",i]];
    }
    return _dayArray;
}



#pragma mark - - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 4;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case BLComponentTypeMonth:
            return _monthArray.count;
            break;
        case BLComponentTypeDay:
            return self.dayArray.count;
            break;
        case BLComponentTypeHour:
            return _hourArray.count;
            break;
        case BLComponentTypeSecond:
            return _secondArray.count;
            break;
        default:
            return _secondArray.count;
    }
}

#pragma mark - - UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return pickerView.frame.size.width/5;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 60;
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (component) {
        case BLComponentTypeMonth:
            return _monthArray[row];
            break;
        case BLComponentTypeDay:
            return self.dayArray[row];
            break;
        case BLComponentTypeHour:
            return _hourArray[row];
            break;
        case BLComponentTypeSecond:
            return _secondArray[row];
            break;
        default:
            return _secondArray[row];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:15]];
        pickerLabel.textColor = [UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [pickerView reloadAllComponents];
    [self showDataLabel];
}


#pragma mark - - private

- (void)showAnimation{
    _bgView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8);
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.4
          initialSpringVelocity:0.6
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        _bgView.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)showDataLabel{
    BLCalendarModel *model = [self calculateSelectedDate];
    _dateLabel.text = [NSString stringWithFormat:@"%@ 年 %@ 月 %@ 日 %@:%@",model.year,model.month,model.day,model.hour,model.second];
}

- (BLCalendarModel *)calculateSelectedDate{
    NSString *monthStr = [_monthArray[[_pickView selectedRowInComponent:0]] stringByReplacingOccurrencesOfString:@"月" withString:@""];
    NSString *dayStr = [self.dayArray[[_pickView selectedRowInComponent:1]] stringByReplacingOccurrencesOfString:@"日" withString:@""];
    NSString *hourStr = [_hourArray[[_pickView selectedRowInComponent:2]] stringByReplacingOccurrencesOfString:@"时" withString:@""];
    NSString *secondStr = [_secondArray[[_pickView selectedRowInComponent:3]] stringByReplacingOccurrencesOfString:@"分" withString:@""];
    
    NSString *dateStr = [[[monthStr stringByAppendingString:dayStr] stringByAppendingString:hourStr] stringByAppendingString:secondStr];
    NSInteger date = [dateStr integerValue];
    NSString *year;
    if (date < [[_currentDate substringFromIndex:4] integerValue]) {
        NSInteger yearInt = [[_currentDate substringToIndex:4] integerValue] + 1;
        year = [NSString stringWithFormat:@"%ld",(long)yearInt];
    } else {
        year = [_currentDate substringToIndex:4];
    }
    BLCalendarModel *model = [BLCalendarModel new];
    model.month = monthStr;
    model.year = year;
    model.day = dayStr;
    model.hour = hourStr;
    model.second = secondStr;
    return model;
}

/** 初始化年月数据 */
- (void)setUpYMDateDic{
    
    _monthArray = [NSMutableArray arrayWithCapacity:0];
    _hourArray = [NSMutableArray arrayWithCapacity:0];
    _secondArray = [NSMutableArray arrayWithCapacity:0];
    
    for (NSInteger i = 1; i <= 12; i++) {
        NSString *month = [NSString stringWithFormat:@"%@%ld月",i < 10 ? @"0" : @"",i];
        [_monthArray addObject:month];
    }
    for (NSInteger i = 0; i <= 23; i++) {
        NSString *hour = [NSString stringWithFormat:@"%@%ld时",i < 10 ? @"0" : @"",i];
        [_hourArray addObject:hour];
    }
    for (NSInteger i = 0; i <= 59; i++) {
        NSString *second = [NSString stringWithFormat:@"%@%ld分",i < 10 ? @"0" : @"",i];
        [_secondArray addObject:second];
    }
}

- (void)initianizeDefaultDate{
    //得到当前的时间
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmm"];
    _currentDate = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString *monthOBJ = [[_currentDate substringWithRange:NSMakeRange(4, 2)] stringByAppendingString:@"月"];
    NSString *dayOBJ = [[_currentDate substringWithRange:NSMakeRange(6, 2)] stringByAppendingString:@"日"];
    NSString *hourOBJ = [[_currentDate substringWithRange:NSMakeRange(8, 2)] stringByAppendingString:@"时"];
    NSString *secondOBJ = [[_currentDate substringWithRange:NSMakeRange(10, 2)] stringByAppendingString:@"分"];
    
    [_pickView selectRow:[_monthArray indexOfObject:monthOBJ]  inComponent:0 animated:NO];
    [_pickView selectRow:[_dayArray indexOfObject:dayOBJ]  inComponent:1 animated:NO];
    [_pickView selectRow:[_hourArray indexOfObject:hourOBJ]  inComponent:2 animated:NO];
    [_pickView selectRow:[_secondArray indexOfObject:secondOBJ]  inComponent:3 animated:NO];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end

@implementation BLCalendarModel
@end
