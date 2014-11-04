//
//  QuoteTableViewCell.m
//  QuotesListExample
//
//  Created by Colin Eberhardt on 30/10/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import "QuoteTableViewCell.h"
#import "QuoteViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface QuoteTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *symbolLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation QuoteTableViewCell 

- (void)bindViewModel:(id)viewModel {
  QuoteViewModel *quoteViewModel = (QuoteViewModel *)viewModel;
  
  self.symbolLabel.text = quoteViewModel.symbol;
  
  static NSNumberFormatter *formatter = nil;
  if (formatter == nil) {
    formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:2];
    [formatter setMinimumFractionDigits:2];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
  }
  
  // bind the price property, converting it from a number to a string
  [[RACObserve(quoteViewModel, price)
    takeUntil:self.rac_prepareForReuseSignal]
    subscribeNext:^(NSNumber *x) {
      self.priceLabel.text = [formatter stringFromNumber:x];
    }];
  
  // bind the move direction
  [[RACObserve(quoteViewModel, moveDirection)
    takeUntil:self.rac_prepareForReuseSignal]
    subscribeNext:^(NSNumber *x) {
      UIColor *color = [UIColor blackColor];
      if ([x intValue] == MoveDirectionUp) {
        color = [UIColor greenColor];
      }
      if ([x intValue] == MoveDirectionDown) {
        color = [UIColor redColor];
      }
      self.priceLabel.textColor = color;
    }];
  
  // bind the background color
  [[RACObserve(quoteViewModel, highlight)
    takeUntil:self.rac_prepareForReuseSignal]
    subscribeNext:^(NSNumber *x) {
      self.backgroundColor = [x boolValue] ? [UIColor yellowColor] : [UIColor whiteColor];
    }];
}

@end
