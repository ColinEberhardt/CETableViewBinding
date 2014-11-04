//
//  QuoteViewModel.h
//  QuotesListExample
//
//  Created by Colin Eberhardt on 30/10/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ARC4RANDOM_MAX      0x100000000
#define RANDOM_DOUBLE       ((double)arc4random() / ARC4RANDOM_MAX)

typedef NS_ENUM(NSInteger, MoveDirection) {
  MoveDirectionNone = 0,
  MoveDirectionUp,
  MoveDirectionDown
};

/// A view model which represents a single stock quote
@interface QuoteViewModel : NSObject

@property (strong, nonatomic) NSString *symbol;

@property (strong, nonatomic) NSNumber *price;

@property (nonatomic) MoveDirection moveDirection;

@property (nonatomic) BOOL highlight;

- (instancetype) initWithSymbol: (NSString *)symbol;

+ (instancetype) quoteWithSymbol: (NSString *)symbol;

@end
