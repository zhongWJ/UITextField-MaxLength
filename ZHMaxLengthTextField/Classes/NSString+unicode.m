//
// Created by zhong on 2016/12/21.
// Copyright (c) 2016 zhong. All rights reserved.
//

#import "NSString+unicode.h"


@implementation NSString (unicode)
- (NSUInteger)charLength {
    if ([self length] == 0) {
        return 0;
    }
    
    NSInteger charLength = 0;
    char *p = (char *)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i = 0; i < [self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++) {
        if (*p) {
            charLength++;
        }
        
        p++;
    }
    return charLength;
}

@end
