//
//  CycleScrollViewController.m
//  CycleScrollView
//
//  Created by B.H.Liu on 12-10-30.
//  Copyright (c) 2012年 B.H.Liu. All rights reserved.
//

#import "CycleScrollViewController.h"

#define ITEM_COUNT 5
#define ITEM_WIDTH 320/(ITEM_COUNT-1)

@interface CycleScrollViewController () <UIScrollViewDelegate>
- (void)loadPageWithContent:(int)index atIndex:(int)page;
@end

@implementation CycleScrollViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithItems:(NSArray *)items
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        pageTitles = [NSMutableArray arrayWithArray:items];
        pageViews = [NSMutableArray array];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [self.view setFrame:frame];
    cycleScrollView.frame = CGRectMake(0, 0, frame.size.width, 44);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor underPageBackgroundColor];
    
    cycleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    cycleScrollView.delegate = self;
    cycleScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:cycleScrollView];
    
    for (int i = 0; i < 10; i ++)
    {
        UILabel *pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(ITEM_WIDTH*i, 0, ITEM_WIDTH, 44)];
        pageLabel.textAlignment = NSTextAlignmentCenter;
        pageLabel.backgroundColor = [UIColor clearColor];
        [pageViews addObject:pageLabel];
        
        [cycleScrollView addSubview:pageLabel];
    }
    
    currentIndex = 0;
    
    cycleScrollView.contentSize = CGSizeMake((ITEM_COUNT + 2)*ITEM_WIDTH, 44);  //must be ITEM_COUNT + 2
	[cycleScrollView scrollRectToVisible:CGRectMake(1.5*ITEM_WIDTH,0,self.view.frame.size.width, 44) animated:NO];
    
    [self loadPageWithContent:[pageTitles count]-1 atIndex:0];
    for (int i = 0; i < ITEM_COUNT + 1; i++)
    {
        [self loadPageWithContent:i atIndex:i+1];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadPageWithContent:(int)index atIndex:(int)page
{
    ((UILabel*)pageViews[page]).text = pageTitles[index];
    if (index ==  (currentIndex + 2)%[pageTitles count])
    {
        ((UILabel*)pageViews[page]).textColor = [UIColor blueColor];
    }
    else
    {
        ((UILabel*)pageViews[page]).textColor = [UIColor blackColor];
    }
}


#pragma mark- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{    
    if (_scrollView.contentOffset.x >= 2.0*ITEM_WIDTH)
    {        
        [self loadPageWithContent:currentIndex atIndex:0];
        
        currentIndex = (currentIndex >= [pageTitles count]-1) ? 0 : currentIndex + 1;
        [self loadPageWithContent:currentIndex atIndex:1];
        
        nextIndex = currentIndex;
        for (int i = 2; i < ITEM_COUNT + 2; i ++)
        {
            nextIndex = (nextIndex+1 >= [pageTitles count]) ? 0 : nextIndex + 1;
            [self loadPageWithContent:nextIndex atIndex:i];
        }
        
        [cycleScrollView scrollRectToVisible:CGRectMake(1.5*ITEM_WIDTH,0,cycleScrollView.frame.size.width,cycleScrollView.frame.size.height) animated:NO];
    }
    if (_scrollView.contentOffset.x <= 1.0*ITEM_WIDTH)
    {        
        currentIndex = (currentIndex == 0) ? [pageTitles count]-1 : currentIndex - 1;
        [self loadPageWithContent:currentIndex atIndex:1];
        
        prevIndex = (prevIndex == 0) ? [pageTitles count]-1 : prevIndex - 1;
        [self loadPageWithContent:prevIndex atIndex:0];
        
        nextIndex = currentIndex;
        for (int i = 2; i < ITEM_COUNT + 2; i ++)
        {
            nextIndex = (nextIndex+1 >= [pageTitles count]) ? 0 : nextIndex + 1;
            [self loadPageWithContent:nextIndex atIndex:i];
        }
        
        
        [cycleScrollView scrollRectToVisible:CGRectMake(1.5*ITEM_WIDTH,0,cycleScrollView.frame.size.width,cycleScrollView.frame.size.height) animated:NO];
    }
    
    NSLog(@"scroll currentIndex %d",currentIndex);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"DidEndDecelerating current index %d",currentIndex);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"DidEndDragging current index %d",currentIndex);
    
    [cycleScrollView scrollRectToVisible:CGRectMake(round((float)scrollView.contentOffset.x/(ITEM_WIDTH/2))*(ITEM_WIDTH/2),0,cycleScrollView.frame.size.width,cycleScrollView.frame.size.height) animated:YES];
}

@end
