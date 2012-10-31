CycleScrollView
===============

This is a simple UIView with a UIScrollView which presents the effect of endless loop of items.
<img src="https://github.com/aceisScope/CycleScrollView/raw/master/screenshot.png"/>  

##How to use
===
The CycleScrollView should be initialized with an array of items (which is titles in this demo). Actually by setting `pageViews` (UILabel in the example), you can get whatever views you want.
If you want to display more/less items in the frame, just change `#define ITEM_COUNT 5` tp what you need.

##Methods
===
``` objective-c
- (id)initWithItems:(NSArray*)items andFrame:(CGRect)frame;
- (NSInteger)currentPage;
```