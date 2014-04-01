//
//  TQRichTextView+Jumei.m
//  Mall
//
//  Created by Hanjia Huang on 14-3-18.
//  Copyright (c) 2014年 Jumei Inc. All rights reserved.
//

#import "TQRichTextView+Jumei.h"
#import <objc/runtime.h>

static void *MATQRichTextViewPrefixStringKey = &MATQRichTextViewPrefixStringKey;

@implementation TQRichTextView (Jumei)


- (void)setPrefixString:(NSString *)prefixString {
    objc_setAssociatedObject(self, MATQRichTextViewPrefixStringKey, prefixString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)prefixString {
    return objc_getAssociatedObject(self, MATQRichTextViewPrefixStringKey);
}

@end






