//
//  CETweetTableViewCell.m
//  CETableViewBinding
//
//  Created by Colin Eberhardt on 28/04/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import "CETweetTableViewCell.h"
#import "CETweetViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface CETweetTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleTextField;
@property (weak, nonatomic) IBOutlet UILabel *usernameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *ghostImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIView *titleBackgroundView;

@end

@implementation CETweetTableViewCell

- (void)bindViewModel:(id)viewModel {
  
  CETweetViewModel *tweet = (CETweetViewModel *)viewModel;
  
  // some general styling
  self.ghostImageView.contentMode = UIViewContentModeScaleToFill;
  self.ghostImageView.alpha = 0.5;
  
  self.profileImage.layer.borderColor = [UIColor whiteColor].CGColor;
  self.profileImage.layer.borderWidth = 2.0f;
  self.profileImage.layer.cornerRadius = 5.0f;
  
  self.titleBackgroundView.layer.cornerRadius = 5.0f;
  
  // set the tweet 'status' label, sizing it to fit the text
  self.titleTextField.frame = CGRectInset(self.titleBackgroundView.frame, 5.0f, 5.0f) ;
  self.titleTextField.text = tweet.status;
  [self.titleTextField sizeToFit];
  
  // set the username
  self.usernameTextField.text = tweet.username;
  
  // use signals to fetch the images for each image view
  self.profileImage.image = nil;
  [[self signalForImage:[NSURL URLWithString:tweet.profileBannerUrl]]
    subscribeNext:^(id x) {
      self.ghostImageView.image = x;
    }];
  
  self.ghostImageView.image = nil;
  [[self signalForImage:[NSURL URLWithString:tweet.profileImageUrl]]
    subscribeNext:^(id x) {
      self.profileImage.image = x;
    }];
}

// creates a signal that fetches an image in the background, delivering
// it on the UI thread. This signal 'cancels' itself if the cell is re-used before the
// image is downloaded.
-(RACSignal *)signalForImage:(NSURL *)imageUrl {
  
  RACScheduler *scheduler = [RACScheduler schedulerWithPriority:RACSchedulerPriorityBackground];
  
  RACSignal *imageDownloadSignal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
      NSData *data = [NSData dataWithContentsOfURL:imageUrl];
      UIImage *image = [UIImage imageWithData:data];
      [subscriber sendNext:image];
      [subscriber sendCompleted];
      return nil;
    }] subscribeOn:scheduler];
  
  return [[imageDownloadSignal
          takeUntil:self.rac_prepareForReuseSignal]
          deliverOn:[RACScheduler mainThreadScheduler]];
  
}

@end
