//
//  GuideViewController.m
//
//

#import "WelcomeViewController.h"


#define SPACE_WIDTH 20
#define SCREENWIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREENHEIGHT ([UIScreen mainScreen].bounds.size.height)
#define GUIDE_VIEW_COLOR [UIColor colorWithRed:48.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1.0]



@implementation WelcomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect frame = CGRectMake(0, 0,SCREENWIDTH, SCREENHEIGHT);
    
    
    UIScrollView *myScrollView = [[UIScrollView alloc] initWithFrame:frame];
    myScrollView.pagingEnabled = YES;
    myScrollView.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:myScrollView];
    
    NSInteger contentWidth = myScrollView.frame.size.width - SPACE_WIDTH;
    
    NSFileManager *file = [NSFileManager defaultManager];
    NSBundle *bundle =[NSBundle mainBundle];
    NSString *str = [bundle pathForResource:@"welcome" ofType:@"bundle"];
    NSArray *list = nil;
    if ([file fileExistsAtPath:str])
    {
        list = [file contentsOfDirectoryAtPath:str error:nil];
    }
    
    NSInteger count = list.count/2;
    count = 3;
    for (int i = 0; i < count; ++i)
    {
        CGRect frame = {(contentWidth +SPACE_WIDTH) * i, 0, SCREENWIDTH, SCREENHEIGHT};
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        NSString *path;
        if (SCREENHEIGHT >= 568)
        {
            path  = [NSString stringWithFormat:@"guide_%02d@1136.png",i+1];
        }
        else
        {
            path  = [NSString stringWithFormat:@"guide_%02d.png",i+1];
        }
        
        NSString *main_images_dir_path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"welcome.bundle"];
        NSString *image_path = [main_images_dir_path stringByAppendingPathComponent:path];
        [imageView setImage:[UIImage imageWithContentsOfFile:image_path]];
        imageView.userInteractionEnabled = YES;
        if (i == count-1)
        {
            //creat a button on the last pages
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height);
            [btn setBackgroundColor:[UIColor clearColor]];
            [btn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:btn];
            
//            UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"welcome.bundle/guide_btn"]];
//            [img setFrame:CGRectMake((SCREENWIDTH-130)/2, 400, 130, 46)];//AutoWHGetHeight(400)
//            [imageView addSubview:img];
        
        }
        [myScrollView addSubview:imageView];
    }
    myScrollView.contentSize = CGSizeMake((contentWidth + SPACE_WIDTH) * count, SCREENHEIGHT);
}

- (void)loginAction
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstInstall"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    CATransition *animation = [CATransition animation];
    animation.duration = 0.7 ;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    // private type "cube", "suckEffect", "oglFlip", "rippleEffect", "pageCurl", "pageUnCurl", "cameraIrisHollowOpen", "cameraIrisHollowClose"
    animation.type = @"rippleEffect";
    [[self.view layer] addAnimation:animation forKey:@"animation"];
    [self performSelector:@selector(moveToLeftSide) withObject:nil afterDelay:1];
}
#pragma mark - pages move to left
- (void)moveToLeftSide
{
    [UIView animateWithDuration:0.7
                     animations:^{
                         self.view.frame = CGRectMake(-self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [self.view setHidden:YES];
                         [self.view removeFromSuperview];
                     }];
}

- (void)dealloc
{
    NSLog(@"Guild view ------------------");
}

@end

