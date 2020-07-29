//
//  AZModalViewController.h
//  AZModalViewController
//
//  Created by minkook yoo on 2020/07/29.
//  Copyright © 2020 minkook yoo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class AZModalViewController;

@protocol AZModalViewControllerDelegate < NSObject >

@optional

- (void)willPullDownGestureTouchPoint:(CGPoint)touchPoint;
- (void)didPullDownGestureTouchPoint:(CGPoint)touchPoint;

- (void)willDismissModalViewController;

@end



@interface AZModalViewController : UIViewController

/// default 0.5. ( 0  ~  1 ).
@property (nonatomic, assign) CGFloat limitRatioFromViewHeight;


@property (nonatomic, weak, nullable) id <AZModalViewControllerDelegate> delegate;


@end



NS_ASSUME_NONNULL_END
