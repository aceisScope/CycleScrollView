CycleScrollView
===============
<img src="https://github.com/aceisScope/CycleScrollView/raw/master/screenshot.png"/> 

##Description
===
This is a simple UIView with a UIScrollView which presents the effect of endless loop of items.
 
##How to use
===
The CycleScrollView should be initialized with an array of items (which is titles in this demo). Actually by setting `pageViews` (UILabel in the example), you can get whatever views you want.
If you want to display more/less items in the frame, just change `#define ITEM_COUNT 5` tp what you need.
`-setIndex` is used for setting the scrollView to a certain index, note that currentIndex for the scrollView means the one on the very left, not in the middle.

##Methods
===
``` objective-c
- (id)initWithItems:(NSArray*)items andFrame:(CGRect)frame;
- (NSInteger)currentPage;
- (void)setIndex:(NSInteger)index;
```