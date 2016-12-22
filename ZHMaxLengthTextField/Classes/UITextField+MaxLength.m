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
    
    UITextRange *markedTextRange = [textField markedTextRange];
    if ([destString charLength] <= textField.charMaxLength) {
        textField.lastTextContent = destString;
        return;
    }
    
    if (markedTextRange && ![markedTextRange isEmpty]) {
        return;
    }

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
