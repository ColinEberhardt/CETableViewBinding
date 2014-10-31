//
//  QuoteListViewModel.m
//  QuotesListExample
//
//  Created by Colin Eberhardt on 30/10/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import "QuoteListViewModel.h"
#import "QuoteViewModel.h"

@implementation QuoteListViewModel

- (instancetype)init {
  if (self = [super init]) {
    NSArray * initialQuotes = @[[QuoteViewModel quoteWithSymbol:@"MKS.L"],
                                [QuoteViewModel quoteWithSymbol:@"EXPN.L"],
                                [QuoteViewModel quoteWithSymbol:@"AV.L"],
                                [QuoteViewModel quoteWithSymbol:@"LLOY.L"],
                                [QuoteViewModel quoteWithSymbol:@"LSE.L"],
                                [QuoteViewModel quoteWithSymbol:@"RBS.L"],
                                [QuoteViewModel quoteWithSymbol:@"REL.L"]];
    self.quotes = [[CEObservableMutableArray alloc] initWithArray:initialQuotes];
    
    [self performSelector:@selector(updatePrices) withObject:self afterDelay:1.0f];
  }
  return self;
}

- (void)updatePrices {
  [self performSelector:@selector(updatePrices) withObject:self afterDelay:1.0f];
  
  for (QuoteViewModel *quote in self.quotes) {
    
    if (RANDOM_DOUBLE > 0.5) {
      quote.price = @(quote.price.doubleValue + (RANDOM_DOUBLE * 10.0) - 5.0);
    }
  }
}

@end
