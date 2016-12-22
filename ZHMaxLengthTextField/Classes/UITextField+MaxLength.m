//
// Created by zhong on 2016/12/18.
// Copyright (c) 2016 zhong. All rights reserved.
//

#import "UITextField+MaxLength.h"
#import <objc/runtime.h>
#import "NSString+unicode.h"

@interface UITextField (MaxLength_Private)

@property (nonatomic, copy) NSString *lastTextContent;

@end

@interface ZHTextFieldObserver: NSObject
@end

@implementation ZHTextFieldObserver

- (void)textFieldDidChanged:(UITextField *)textField {
    NSString *destString = textField.text;
    NSString *lastString = textField.lastTextContent;
    
    if ([destString charLength] <= textField.charMaxLength) {
        textField.lastTextContent = destString;
        return;
    }
    
    //对中文输入做特殊处理，当正在输入中文时，输入框中拼音处于marked状态，
    //故此时不做长度限制判断
    UITextRange *markedTextRange = [textField markedTextRange];
    if (markedTextRange && ![markedTextRange isEmpty]) {
        return;
    }

    //此处是考虑到UITextField初始内容长度就超过了最长限制，那么限制用户
    //只能删减直到达到长度限制。
    if ([lastString charLength] > textField.charMaxLength && [destString length] < [lastString length]) {
        textField.lastTextContent = destString;
        return;
    }

    textField.text = textField.lastTextContent;
}

- (void)textFieldStartEditing:(UITextField *)textField {
    textField.lastTextContent = textField.text;
}

@end

static ZHTextFieldObserver *textFieldObserver;

@implementation UITextField (MaxLength_Private)

@dynamic lastTextContent;

- (void)setLastTextContent:(NSString *)lastTextContent {
    objc_setAssociatedObject(self, @selector(lastTextContent), lastTextContent, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)lastTextContent {
    return objc_getAssociatedObject(self, @selector(lastTextContent));
}

@end

@implementation UITextField (MaxLength)

@dynamic charMaxLength;

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        textFieldObserver = [[ZHTextFieldObserver alloc] init];
    });
}

- (void)setCharMaxLength:(NSUInteger)charMaxLength {
    objc_setAssociatedObject(self, @selector(charMaxLength), @(charMaxLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (charMaxLength > 0) {
        [self addTarget:textFieldObserver action:@selector(textFieldStartEditing:) forControlEvents:UIControlEventEditingDidBegin];
        [self addTarget:textFieldObserver action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    }
}

- (NSUInteger)charMaxLength {
    NSNumber *number = objc_getAssociatedObject(self, @selector(charMaxLength));
    return [number unsignedIntegerValue];
}

@end
