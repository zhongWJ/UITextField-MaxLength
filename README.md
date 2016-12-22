# ZHMaxLengthTextField
控制UITextField最长字节长度UITextField+MaxLength分类

在项目中，会遇到需要限制UITextField字节长度需求。也就是对输入字符的unicode字节做限制。例如一个英文或数字一个字节，汉字两个字节。

故实现了一个简单的UITextField+MaxLength分类，通过直接简单设置属性charMaxLength，就能达到限制输入框字节长度。

以下例子限制输入框长度为16个字节，也就是16个英文字母或数字，8个汉字:
```
#import "UITextField+MaxLength.h"

UITextField *textField = [[UITextField alloc] init];
textField.charMaxLength = 16;
```
