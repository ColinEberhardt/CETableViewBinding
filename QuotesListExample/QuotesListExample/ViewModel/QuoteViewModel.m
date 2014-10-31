//
//  QuoteViewModel.m
//  QuotesListExample
//
//  Created by Colin Eberhardt on 30/10/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import "QuoteViewModel.h"

@implementation QuoteViewModel

- (instancetype)initWithSymbol:(NSString *)symbol {
  if (self = [super init]) {
    self.symbol = symbol;
    
    self.price = @(RANDOM_DOUBLE * 50.0 + 80.0);
  }
  return self;
}

+ (instancetype)quoteWithSymbol:(NSString *)symbol {
  return [[QuoteViewModel alloc] initWithSymbol:symbol];
}

@end
