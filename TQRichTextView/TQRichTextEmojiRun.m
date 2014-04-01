//
//  TQRichTextEmojiRun.m
//  TQRichTextViewDemo
//
//  Created by fuqiang on 13-9-21.
//  Copyright (c) 2013年 fuqiang. All rights reserved.
//

#import "TQRichTextEmojiRun.h"

@implementation TQRichTextEmojiRun

- (id)init {
  self = [super init];
  if (self) {
    self.type = richTextEmojiRunType;
    self.isResponseTouch = NO;
  }
  return self;
}

- (BOOL)drawRunWithRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();
  NSString *emojiString =
      [NSString stringWithFormat:@"%@.gif", self.originalText];

  UIImage *image = [UIImage imageNamed:emojiString];
  if (image) {
    CGContextDrawImage(context, rect, image.CGImage);
  }
  return YES;
}

+ (NSArray *)emojiStringArray {
  return [NSArray
      arrayWithObjects:
          @"[爱你]", @"[爱心]", @"[傲慢]", @"[白眼]", @"[抱拳]", @"[鄙视]",
          @"[闭嘴]", @"[便便]", @"[擦汗]", @"[菜刀]", @"[差劲]", @"[大兵]",
          @"[大哭]", @"[蛋糕]", @"[刀]", @"[得意]", @"[凋谢]", @"[调皮]",
          @"[发呆]", @"[发怒]", @"[饭]", @"[奋斗]", @"[尴尬]", @"[勾引]",
          @"[鼓掌]", @"[哈欠]", @"[害羞]", @"[憨笑]", @"[坏笑]", @"[饥饿]",
          @"[惊恐]", @"[惊讶]", @"[咖啡]", @"[可爱]", @"[可怜]", @"[抠鼻]",
          @"[骷髅]", @"[酷]", @"[快哭了]", @"[困]", @"[篮球]", @"[冷汗]",
          @"[礼物]", @"[流汗]", @"[流泪]", @"[玫瑰]", @"[难过]", @"[啤酒]",
          @"[瓢虫]", @"[撇嘴]", @"[乒乓]", @"[强]", @"[敲打]", @"[亲亲]",
          @"[糗大了]", @"[拳头]", @"[弱]", @"[色]", @"[闪电]", @"[胜利]",
          @"[示爱]", @"[衰]", @"[睡]", @"[太阳]", @"[偷笑]", @"[吐]", @"[微笑]",
          @"[委屈]", @"[握手]", @"[西瓜]", @"[吓]", @"[心碎]", @"[嘘]",
          @"[疑问]", @"[阴险]", @"[拥抱]", @"[右哼哼]", @"[月亮]", @"[晕]",
          @"[再见]", @"[炸弹]", @"[折磨]", @"[咒骂]", @"[猪头]", @"[抓狂]",
          @"[龇牙]", @"[足球]", @"[左哼哼]", @"[NO]", @"[OK]", nil];
}

+ (NSString *)analyzeText:(NSString *)string
                runsArray:(NSMutableArray **)runArray {
  NSString *markL = @"[";
  NSString *markR = @"]";
  NSMutableArray *stack = [[NSMutableArray alloc] init];
  NSMutableString *newString =
      [[NSMutableString alloc] initWithCapacity:string.length];

  //偏移索引
  //由于会把长度大于1的字符串替换成一个空白字符。这里要记录每次的偏移了索引。以便简历下一次替换的正确索引
  int offsetIndex = 0;

  for (int i = 0; i < string.length; i++) {
    NSString *s = [string substringWithRange:NSMakeRange(i, 1)];

    if (([s isEqualToString:markL]) ||
        ((stack.count > 0) && [stack[0] isEqualToString:markL])) {
      if (([s isEqualToString:markL]) &&
          ((stack.count > 0) && [stack[0] isEqualToString:markL])) {
        for (NSString *c in stack) {
          [newString appendString:c];
        }
        [stack removeAllObjects];
      }

      [stack addObject:s];

      if ([s isEqualToString:markR] || (i == string.length - 1)) {
        NSMutableString *emojiStr = [[NSMutableString alloc] init];
        for (NSString *c in stack) {
          [emojiStr appendString:c];
        }

        if ([[TQRichTextEmojiRun emojiStringArray] containsObject:emojiStr]) {
          TQRichTextEmojiRun *emoji = [[TQRichTextEmojiRun alloc] init];
          emoji.range = NSMakeRange(i + 1 - emojiStr.length - offsetIndex, 1);
          emoji.originalText = emojiStr;
          [*runArray addObject:emoji];
          [newString appendString:@" "];

          offsetIndex += emojiStr.length - 1;
        } else {
          [newString appendString:emojiStr];
        }

        [stack removeAllObjects];
      }
    } else {
      [newString appendString:s];
    }
  }

  return newString;
}

@end
