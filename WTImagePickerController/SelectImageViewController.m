//
//  SelectImageViewController.m
//  TakePhoto
//
//  Created by SongWentong on 14/11/17.
//  Copyright (c) 2014年 SongWentong. All rights reserved.
//

#import "SelectImageViewController.h"

@interface SelectImageViewController () <UIScrollViewDelegate>
{
    UIScrollView *myScrollView;
    UIImageView *imageViewToZoom;
    UIView *rectView;
    UIImageView *thumbImageView;
    
//    取消按钮
    UIButton *cancelButton;
}
@end

//屏幕宽度
static CGFloat screenWidth;
static CGFloat screenHeight;
@implementation SelectImageViewController

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationController.navigationBarHidden = YES;
    
    
    
    // Do any additional setup after loading the view.
    screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
    screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    myScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    myScrollView.delegate = self;
    
    myScrollView.minimumZoomScale = 1.0;
    myScrollView.maximumZoomScale = 4.0;
    myScrollView.backgroundColor = [UIColor redColor];
//    myScrollView.layer.borderColor = [UIColor whiteColor].CGColor;
//    myScrollView.layer.borderWidth = 1.0;
    myScrollView.clipsToBounds = NO;
    CGFloat topInset = 100;
    myScrollView.contentInset = UIEdgeInsetsMake(topInset, 0, screenHeight-screenWidth-topInset, 0);
//    myScrollView.alwaysBounceHorizontal = NO;
//    myScrollView.alwaysBounceVertical = NO;
    [self.view addSubview:myScrollView];
    
    
    imageViewToZoom = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    imageViewToZoom.image = _editImage;
    CGSize imageSize = _editImage.size;

    CGFloat heightForImageView = (imageSize.height*screenWidth)/imageSize.width;
    imageViewToZoom.frame = CGRectMake(0, 0, screenWidth, heightForImageView);
    imageViewToZoom.backgroundColor = [UIColor yellowColor];
    myScrollView.contentSize = CGSizeMake(screenWidth, heightForImageView);
    imageViewToZoom.userInteractionEnabled = NO;
    [myScrollView addSubview:imageViewToZoom];
    
    
    
    rectView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, screenWidth, screenWidth)];
    rectView.userInteractionEnabled = NO;
    rectView.backgroundColor = [UIColor clearColor];
    rectView.layer.borderColor = [UIColor whiteColor].CGColor;
    rectView.layer.borderWidth = 1.0;
    [self.view addSubview:rectView];


    
    
    
    thumbImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, screenHeight-150, 150, 150)];
    thumbImageView.hidden = YES;
    [self.view addSubview:thumbImageView];
    
    [self configView];
    
}

-(void)configView
{
    cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, screenHeight-60, 100, 60);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.view addSubview:cancelButton];
    [cancelButton addTarget:self
                     action:@selector(pop)
           forControlEvents:UIControlEventTouchUpInside];
}

-(void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(UIImage*)currentImage
{
    UIImage *image = nil;
//    contentOffset
    

    CGFloat width = _editImage.size.width/(myScrollView.contentSize.width/320);
    CGPoint p = myScrollView.contentOffset;
    
    
    
    CGFloat x = (p.x*_editImage.size.width)/myScrollView.contentSize.width;
    CGFloat y = ((p.y+100)*_editImage.size.height)/myScrollView.contentSize.height;
    CGRect area = CGRectMake(x, y, width, width);
    image = [self cropImageWithImage:imageViewToZoom.image andArea:area];
    return image;
}

-(UIImage*)cropImageWithImage:(UIImage*)image andArea:(CGRect)area
{
    CGImageRef returnImage = CGImageCreateWithImageInRect(image.CGImage, area);
    UIImage *result = nil;
    result = [UIImage imageWithCGImage:returnImage scale:1.0 orientation:image.imageOrientation];
    CFBridgingRelease(returnImage);
    return result;
}
-(void)done
{
    UIImage *currentImage = [self currentImage];
    [_delegate selectImageDidSelectImage:self
                                   image:currentImage];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
//    NSLog(@"%s",__func__);
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageViewToZoom;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    UIImage *currentImage = [self currentImage];
    thumbImageView.image = currentImage;
}

@end
