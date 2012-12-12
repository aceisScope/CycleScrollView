//
//  CycleScrollView.m
//  CycleScrollView
//
//  Created by B.H.Liu on 12-10-31.
//  Copyright (c) 2012年 B.H.Liu. All rights reserved.
//

#import "CycleScrollView.h"

#warning ITEM_COUNT MUST BE AN ODD NUMBER
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
        
        for (int i = 0; i < ITEM_COUNT + 2; i ++)
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
        
        first = 0;
        last = ITEM_COUNT + 1;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tapGesture];

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
    ((UILabel*)pageViews[page]).tag = index;
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

- (void)clearColorForCurrentPage
{
    int page = (first + ITEM_COUNT/2 +1)%[pageViews count];
    ((UILabel*)pageViews[page]).textColor = [UIColor blackColor];
}

- (void)setColorForCurrentPage
{
    int page = (first + ITEM_COUNT/2 +1)%[pageViews count];
    ((UILabel*)pageViews[page]).textColor = [UIColor colorWithRed:44./256 green:94./256 blue:22./256 alpha:1];
}

#pragma mark- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    if (_scrollView.contentOffset.x >= 2.0*ITEM_WIDTH)
    {
        [self clearColorForCurrentPage];
        
        [self loadPageWithContent:((UILabel*)pageViews[last]).tag == [pageTitles count]-1 ? 0:((UILabel*)pageViews[last]).tag+1 atIndex:first];
        [(UILabel*)pageViews[first] setFrame:CGRectMake(((UILabel*)pageViews[last]).frame.origin.x , 0, ITEM_WIDTH, 44)];
        last = first;
        first = first == [pageViews count]-1?0:first+1;
        
        currentIndex = (currentIndex >= [pageTitles count]-1) ? 0 : currentIndex + 1;
        
        for (int i = 0; i <= ITEM_COUNT; i ++)
        {
            [(UILabel*)pageViews[(i+first)%[pageViews count]] setFrame:CGRectMake(i*ITEM_WIDTH, 0, ITEM_WIDTH, 44)];
        }
        
        [self setColorForCurrentPage];
        
        [cycleScrollView scrollRectToVisible:CGRectMake(1.5*ITEM_WIDTH,0,cycleScrollView.frame.size.width,cycleScrollView.frame.size.height) animated:NO];
    }
    if (_scrollView.contentOffset.x <= 1.0*ITEM_WIDTH)
    {
        [self clearColorForCurrentPage];
        
        [self loadPageWithContent:((UILabel*)pageViews[first]).tag == 0 ? pageTitles.count -1 :((UILabel*)pageViews[first]).tag - 1 atIndex:last];
        [(UILabel*)pageViews[last] setFrame:CGRectMake(((UILabel*)pageViews[first]).frame.origin.x, 0, ITEM_WIDTH, 44)];
        first = last;
        last = last == 0? [pageViews count] - 1:last -1;
        
        currentIndex = (currentIndex == 0) ? [pageTitles count]-1 : currentIndex - 1;
        
        for (int i = 1; i <= ITEM_COUNT+1; i ++)
        {
            [(UILabel*)pageViews[(i+first)%[pageViews count]] setFrame:CGRectMake(i*ITEM_WIDTH, 0, ITEM_WIDTH, 44)];
        }
        
        [self setColorForCurrentPage];
        
        [cycleScrollView scrollRectToVisible:CGRectMake(1.5*ITEM_WIDTH,0,cycleScrollView.frame.size.width,cycleScrollView.frame.size.height) animated:NO];    }
}

- (void)handleTap:(UITapGestureRecognizer*)sender
{
    CGPoint point = [sender locationInView:self];
    
    int m = ITEM_COUNT - 2;
    int position = (int)point.x/(ITEM_WIDTH/2);
    
    if (position == m || position == m+1) return;
    else if (position < m)
    {
        [self setIndex:currentIndex - (m+(position%2 == 0)-position)/2];
    }
    else if (position > m+1)
    {
        [self setIndex:currentIndex + (position - (m + (position%2 == 0)))/2];
    }
            
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(scrollToIndex:)])
    {
        [self.delegate scrollToIndex:[self currentPage]];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(scrollToIndex:)])
    {
        [self.delegate scrollToIndex:[self currentPage]];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //NSLog(@"current page DidEndDragging %d",[self currentPage]);
    
    float length = round((float)scrollView.contentOffset.x/(ITEM_WIDTH/2));
    if (length == 2.0) length = 3;
    if (length == 4.0) length = 5;
    [cycleScrollView scrollRectToVisible:CGRectMake(length*(ITEM_WIDTH/2),0,cycleScrollView.frame.size.width,cycleScrollView.frame.size.height) animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //NSLog(@"will beging dragging");
    if ([self.delegate respondsToSelector:@selector(willBeginToScroll:)])
    {
        [self.delegate willBeginToScroll:self];
    }
}



@end
