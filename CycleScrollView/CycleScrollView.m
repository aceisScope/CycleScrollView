//
//  CycleScrollView.m
//  CycleScrollView
//
//  Created by B.H.Liu on 12-10-31.
//  Copyright (c) 2012年 B.H.Liu. All rights reserved.
//

#import "CycleScrollView.h"

#define ITEM_COUNT 5
#define ITEM_WIDTH 320/(ITEM_COUNT-1)

@interface CycleScrollView () <UIScrollViewDelegate>
- (void)loadPageWithContent:(int)index atIndex:(int)page;
@end

@implementation CycleScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithItems:(NSArray*)items andFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Custom initialization
        pageTitles = [NSMutableArray arrayWithArray:items];
        pageViews = [NSMutableArray array];
        
        self.backgroundColor = [UIColor underPageBackgroundColor];
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"type_background.png"]];
        
        cycleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
        cycleScrollView.delegate = self;
        cycleScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:cycleScrollView];
        
        for (int i = 0; i < [items count]; i ++)
        {
            UILabel *pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(ITEM_WIDTH*i, 0, ITEM_WIDTH, 44)];
            pageLabel.textAlignment = NSTextAlignmentCenter;
            pageLabel.backgroundColor = [UIColor clearColor];
            pageLabel.font = [UIFont fontWithName:@"American Typewriter" size:16];
            [pageViews addObject:pageLabel];
            
            [cycleScrollView addSubview:pageLabel];
        }
        
        currentIndex = 0;
        
        cycleScrollView.contentSize = CGSizeMake((ITEM_COUNT + 2)*ITEM_WIDTH, 44);  //must be ITEM_COUNT + 2
        [cycleScrollView scrollRectToVisible:CGRectMake(1.5*ITEM_WIDTH,0,self.frame.size.width, 44) animated:NO];
        
        [self loadPageWithContent:[pageTitles count]-1 atIndex:0];
        for (int i = 0; i < ITEM_COUNT + 1; i++)
        {
            [self loadPageWithContent:i atIndex:i+1];
        }

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)loadPageWithContent:(int)index atIndex:(int)page
{
    ((UILabel*)pageViews[page]).text = pageTitles[index];
    if (index ==  (currentIndex + 2)%[pageTitles count])
    {
        ((UILabel*)pageViews[page]).textColor = [UIColor colorWithRed:44./256 green:94./256 blue:22./256 alpha:1];
    }
    else
    {
        ((UILabel*)pageViews[page]).textColor = [UIColor blackColor];
    }
}

- (NSInteger)currentPage
{
    return currentIndex;
}

- (void)setIndex:(NSInteger)index
{
    NSInteger length = abs(index - currentIndex);
    if (index > currentIndex)
    {
        for (int i = 1; i <= length ; i++)
        {
            [cycleScrollView scrollRectToVisible:CGRectMake(1.5*ITEM_WIDTH + ITEM_WIDTH,0,cycleScrollView.frame.size.width,cycleScrollView.frame.size.height) animated:NO];
        }
    }
    else if (index <= currentIndex)
    {
        for (int i = 1; i <= length ; i++)
        {
            [cycleScrollView scrollRectToVisible:CGRectMake(1.5*ITEM_WIDTH - ITEM_WIDTH,0,cycleScrollView.frame.size.width,cycleScrollView.frame.size.height) animated:NO];
        }
    }
}

#pragma mark- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    if (_scrollView.contentOffset.x >= 2.0*ITEM_WIDTH)
    {
        float length = _scrollView.contentOffset.x - 2.0*ITEM_WIDTH;
        
        [self loadPageWithContent:currentIndex atIndex:0];
        
        currentIndex = (currentIndex >= [pageTitles count]-1) ? 0 : currentIndex + 1;
        [self loadPageWithContent:currentIndex atIndex:1];
        
        nextIndex = currentIndex;
        for (int i = 2; i < ITEM_COUNT + 2; i ++)
        {
            nextIndex = (nextIndex+1 >= [pageTitles count]) ? 0 : nextIndex + 1;
            [self loadPageWithContent:nextIndex atIndex:i];
        }
        
        [cycleScrollView scrollRectToVisible:CGRectMake(1.5*ITEM_WIDTH+length,0,cycleScrollView.frame.size.width,cycleScrollView.frame.size.height) animated:NO];
    }
    if (_scrollView.contentOffset.x <= 1.0*ITEM_WIDTH)
    {
        float length = 1.0*ITEM_WIDTH - _scrollView.contentOffset.x;
        
        currentIndex = (currentIndex == 0) ? [pageTitles count]-1 : currentIndex - 1;
        [self loadPageWithContent:currentIndex atIndex:1];
        
        prevIndex = currentIndex - 1;
        prevIndex = (prevIndex <= 0) ? [pageTitles count]-1 : prevIndex - 1;
        [self loadPageWithContent:prevIndex atIndex:0];
        
        nextIndex = currentIndex;
        for (int i = 2; i < ITEM_COUNT + 2; i ++)
        {
            nextIndex = (nextIndex+1 >= [pageTitles count]) ? 0 : nextIndex + 1;
            [self loadPageWithContent:nextIndex atIndex:i];
        }
        
        
        [cycleScrollView scrollRectToVisible:CGRectMake(1.5*ITEM_WIDTH - length,0,cycleScrollView.frame.size.width,cycleScrollView.frame.size.height) animated:NO];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSLog(@"current page %d",[self currentPage]);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{    
    [cycleScrollView scrollRectToVisible:CGRectMake(round((float)scrollView.contentOffset.x/(ITEM_WIDTH/2))*(ITEM_WIDTH/2),0,cycleScrollView.frame.size.width,cycleScrollView.frame.size.height) animated:YES];
}


@end
