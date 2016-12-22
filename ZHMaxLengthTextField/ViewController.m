//
//  ViewController.m
//  ZHMaxLengthTextField
//
//  Created by zhong on 2016/12/18.
//  Copyright © 2016年 zhong. All rights reserved.
//

#import "ViewController.h"
#import "UITextField+MaxLength.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textField.charMaxLength = 16;
}

@end
