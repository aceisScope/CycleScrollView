//
//  CycleScrollView.h
//  CycleScrollView
//
//  Created by B.H.Liu on 12-10-31.
//  Copyright (c) 2012年 B.H.Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CycleScrollView : UIView
{
    UIScrollView *cycleScrollView;
    int prevIndex;
	int currentIndex;
	int nextIndex;
    
    NSMutableArray *pageViews;
    NSMutableArray *pageTitles;
}

- (id)initWithItems:(NSArray*)items andFrame:(CGRect)frame;
- (NSInteger)currentPage;

@end