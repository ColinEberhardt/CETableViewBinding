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
   
    self.quotes = [[CEObservableMutableArray alloc] init];
    self.paused = NO;
    
    // create a few quotes
    for (NSUInteger i=0; i<10; i++) {
      [self.quotes addObject:[self newQuote]];
    }
    
    // periodically update the prices
    [[[RACSignal interval:1.0f onScheduler:[RACScheduler mainThreadScheduler]]
      filter:^BOOL(id value) {
        return !self.paused;
      }]
      subscribeNext:^(id x) {
        [self updatePrices];
      }];
    
    self.toggleStreamingCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
      self.paused = !self.paused;
      return [RACSignal empty];
    }];
  }
  return self;
}

/// performs various random mutations on the array
- (void)updatePrices {
  
  // remove the highlight
  for (QuoteViewModel *quote in self.quotes) {
    if (quote.highlight) {
      quote.highlight = NO;
    }
  }
  
  // randomly update some prices
  for (QuoteViewModel *quote in self.quotes) {
    if (RANDOM_DOUBLE > 0.9) {
      quote.price = @(quote.price.doubleValue + (RANDOM_DOUBLE * 10.0) - 5.0);
      quote.highlight = YES;
    }
  }
  
  // randomly add quotes
  if (RANDOM_DOUBLE > 0.8) {
    NSUInteger randomIndex = (NSUInteger)(RANDOM_DOUBLE * (double)self.quotes.count);
    [self.quotes insertObject:[self newQuote] atIndex:randomIndex];
  }
  
  // randomly remove quotes
  if (RANDOM_DOUBLE > 0.8) {
    NSUInteger randomIndex = (NSUInteger)(RANDOM_DOUBLE * (double)self.quotes.count);
    [self.quotes removeObjectAtIndex:randomIndex];
  }
  
  // randomly replace quotes
  if (RANDOM_DOUBLE > 0.8) {
    NSUInteger randomIndex = (NSUInteger)(RANDOM_DOUBLE * (double)self.quotes.count);
    QuoteViewModel *quote = [self newQuote];
    [self.quotes replaceObjectAtIndex:randomIndex withObject:quote];
  }
}

NSString *letters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";

- (QuoteViewModel *) newQuote {
  return [QuoteViewModel quoteWithSymbol:[self randomStringWithLength:4]];
}

-(NSString *) randomStringWithLength: (int) len {
  NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
  for (int i=0; i<len; i++) {
    [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
  }
  return randomString;
}

@end
