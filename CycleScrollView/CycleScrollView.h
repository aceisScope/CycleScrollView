//
//  CycleScrollView.h
//  CycleScrollView
//
//  Created by B.H.Liu on 12-10-31.
//  Copyright (c) 2012年 B.H.Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CycleScrollView;

@protocol CycleScrollViewDelegate <NSObject>

- (void)willBeginToScroll:(CycleScrollView*)scrollview;
- (void)scrollToIndex:(int)index;

@end

@interface CycleScrollView : UIView
{
    UIScrollView *cycleScrollView;
    int prevIndex;
	int currentIndex;
	int nextIndex;
    
    int first;
    int last;
    
    NSMutableArray *pageViews;
    NSMutableArray *pageTitles;
}

@property (nonatomic,weak) id<CycleScrollViewDelegate>delegate;
- (id)initWithItems:(NSArray*)items andFrame:(CGRect)frame;
- (NSInteger)currentPage;
- (void)setIndex:(NSInteger)index;

@end
