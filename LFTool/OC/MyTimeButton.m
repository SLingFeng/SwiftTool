//
//  MyTimeButton.m
//
//  Copyright © 2016年 孙凌锋. All rights reserved.
//

#import "MyTimeButton.h"

@interface MyTimeButton ()
{
    NSInteger _oldTime;
}
//    上一次的文本
@property (copy, nonatomic) NSString *oldText;

@property (strong, nonatomic) NSTimer * timer;

@property (retain, nonatomic) UIColor * oldColor;

@end

@implementation MyTimeButton

-(instancetype)init {
    if (self = [super init]) {
        [self setupTime];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupTime];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupTime];
    }
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    [self setupTime];
}

-(void)setupTime {
    _oldText = @"验证码";
//    [self addTarget:self action:@selector(onClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self setTitle:@"验证码" forState:(UIControlStateNormal)];
     kWeakSelf(weakSelf);
    self.onClickStartTiming = ^() {
        weakSelf.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:weakSelf selector:@selector(timeChange:) userInfo:nil repeats:YES];
//        weakSelf.oldColor = weakSelf.backgroundColor;
//        weakSelf.status = MyStatusFailure;
        weakSelf.oldText = weakSelf.titleLabel.text;
        weakSelf.timer.fireDate = [NSDate distantPast];
        weakSelf.enabled = NO;
    };
    self.status = 0;
    self.layer.cornerRadius = 5;
}

-(void)onClick {
   
    
    if (self.onClickStartTiming) {
        self.onClickStartTiming();
    }
}

-(void)timeChange:(NSTimer *)sender {
    if (0 >= _timeNum) {
        _timeNum = _oldTime;
        sender.fireDate = [NSDate distantFuture];
        [sender invalidate];
        self.titleLabel.text = _oldText;
        [self setTitle:_oldText forState:(UIControlStateNormal)];
//        self.status = MyStatusSuccess;
//        [self setBackgroundColor:self.oldColor];
        [self setStatus:0];
        return;
    }
    NSInteger temp = _timeNum--;
    self.titleLabel.text = [NSString stringWithFormat:@"%ldS", (long)temp];
    [self setTitle:[NSString stringWithFormat:@"%ldS", (long)temp] forState:(UIControlStateNormal)];
    [self setStatus:1];
}

- (void)reStartTime {
    if (self.timer == nil && _timeNum < 60) {
        self.onClickStartTiming();
    }
}

-(void)resetTime {
    _timeNum = _oldTime;
    self.timer.fireDate = [NSDate distantFuture];
    [self.timer invalidate];
    [self setTitle:_oldText forState:(UIControlStateNormal)];
    self.enabled = YES;
}

-(void)stopTime {
    self.timer.fireDate = [NSDate distantFuture];
    if (_timer.isValid) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(void)dealloc {
    self.timer.fireDate = [NSDate distantFuture];
    if (_timer.isValid) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
}

-(void)setTimeNum:(NSInteger)timeNum {
    if (_timeNum  != timeNum) {
        _timeNum = timeNum;
        _oldTime = timeNum;
    }
}

- (void)setStatus:(NSInteger)status {
    _status = status;
    if (status == 0) {
        self.enabled = 1;
        [self setBackgroundColor:[SLFCommonTools colorHex:@"#379AFF"]];
        [self setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    }else if (status == 1) {
        self.enabled = 0;
        [self setBackgroundColor:[SLFCommonTools colorHex:@"#DDDDDD"]];
        [self setTitleColor:[SLFCommonTools colorHex:@"#666666"] forState:(UIControlStateNormal)];
    }
}

@end
