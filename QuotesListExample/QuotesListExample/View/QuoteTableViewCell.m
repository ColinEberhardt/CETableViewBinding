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
  RAC(self.priceLabel, text) = [RACObserve(quoteViewModel, price) map:^id(NSNumber *x) {
    return [formatter stringFromNumber:x];
  }];
}

@end
