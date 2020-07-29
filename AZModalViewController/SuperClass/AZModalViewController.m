//
//  AZModalViewController.m
//  AZModalViewController
//
//  Created by minkook yoo on 2020/07/29.
//  Copyright © 2020 minkook yoo. All rights reserved.
//

#import "AZModalViewController.h"


@interface AZModalViewController ()

@property (nonatomic, assign) CGPoint touchBeginPoint;
@property (nonatomic, strong) UIColor *savedBackgroundColor;
@property (nonatomic, strong) UIImageView *dismissDragImageView;

@end


@implementation AZModalViewController

- (instancetype)initWithCoder:(NSCoder *)coder {
    
    self = [super initWithCoder:coder];
    
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    
    return self;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self.view addGestureRecognizer:panGesture];
    
}



#pragma mark - Geture

- (void)panGesture:(UIGestureRecognizer *)recognizer {
    
    switch (recognizer.state) {
            
        case UIGestureRecognizerStateBegan: {
            
            self.touchBeginPoint = [recognizer locationInView:self.view];
            
            UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0.0);
            [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            self.savedBackgroundColor = self.view.backgroundColor;
            self.view.backgroundColor = UIColor.clearColor;
            
            CGFloat viewTranslationY = CGRectGetWidth(self.view.bounds) * 2;
            self.view.transform = CGAffineTransformMakeTranslation(viewTranslationY, 0);
            
            self.dismissDragImageView = [[UIImageView alloc] initWithImage:image];
            self.dismissDragImageView.frame = CGRectMake(-viewTranslationY, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
            [self.view addSubview:self.dismissDragImageView];
            [self.dismissDragImageView sendSubviewToBack:self.view];
            
        }
            break;
            
        case UIGestureRecognizerStateChanged: {
            
            CGPoint touchPt = [recognizer locationInView:self.view];
            
            CGFloat ty = touchPt.y - self.touchBeginPoint.y;
            
            ty = MAX(ty, 0);
            
            self.dismissDragImageView.transform = CGAffineTransformMakeTranslation(0, ty);
            
            
        }
            break;
            
        case UIGestureRecognizerStateEnded: {
            
            self.touchBeginPoint = CGPointZero;
            
            BOOL dismiss = self.dismissDragImageView.transform.ty > CGRectGetHeight(self.view.bounds) * 1 / 2;
            
            [self animateDismissPanGesture:dismiss];
            
        }
            break;
            
        default:
            break;
            
    }
    
}

- (void)animateDismissPanGesture:(BOOL)dismiss {
    
    __weak typeof(self) weakSelf = self;
    
    if (dismiss) {
        
        CGFloat ty = CGRectGetHeight(self.view.bounds);
        
        [UIView animateWithDuration:0.2 animations:^{
            
            weakSelf.dismissDragImageView.transform = CGAffineTransformMakeTranslation(0, ty);;
            
        } completion:^(BOOL finished) {
            
            if (finished) {
                [weakSelf dismissViewControllerAnimated:NO completion:nil];
            }
            
        }];
        
    }
    else {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            weakSelf.dismissDragImageView.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            
            if (finished) {
                
                weakSelf.view.backgroundColor = weakSelf.savedBackgroundColor;
                weakSelf.view.transform = CGAffineTransformIdentity;
                
                if (weakSelf.dismissDragImageView) {
                    [weakSelf.dismissDragImageView removeFromSuperview];
                    weakSelf.dismissDragImageView = nil;
                }
                
            }
            
        }];
        
    }
    
}


@end