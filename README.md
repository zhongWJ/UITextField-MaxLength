# UITextField+MaxLength
控制UITextField最长字节长度UITextField+MaxLength分类

在项目中，会遇到需要限制UITextField字节长度需求。也就是对输入的unicode字节长度做限制。一般一个英文或数字一个字节，汉字两个字节。

微信的昵称编辑输入框也是这样的需求，但它的实现有个比较大的问题是，当输入到最后时，由于中文输入法的特殊性，汉字的拼音较长，汉字拼音还未输完，就已经达到了输入框最大长度，导致最后的汉字不能输入问题。

故实现了一个简单的UITextField+MaxLength分类，通过直接简单设置属性charMaxLength，就能达到限制输入框字节长度。并且解决了中文输入汉语拼音较长，最后不能输入的问题。

以下例子限制输入框长度为16个字节，也就是16个英文字母或数字，8个汉字:
```
#import "UITextField+MaxLength.h"

UITextField *textField = [[UITextField alloc] init];
textField.charMaxLength = 16;
```
