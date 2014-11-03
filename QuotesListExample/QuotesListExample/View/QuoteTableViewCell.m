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
  
  NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
  [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
  [formatter setMaximumFractionDigits:2];
  [formatter setMinimumFractionDigits:2];
  [formatter setRoundingMode: NSNumberFormatterRoundUp];
  
  // bind the price property, converting it from a number to a string
  [RACObserve(quoteViewModel, price)
    subscribeNext:^(NSNumber *x) {
      self.priceLabel.text = [formatter stringFromNumber:x];
    }];
  
  // bind the background color
  [RACObserve(quoteViewModel, highlight)
    subscribeNext:^(NSNumber *x) {
      if ([x boolValue]) {
        self.backgroundColor = [UIColor redColor];
        [UIView animateWithDuration:0.3f animations:^{
          self.backgroundColor = [UIColor whiteColor];
        }];
      }
    }];
}

@end
