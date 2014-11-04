//
//  QuoteListViewModel.h
//  QuotesListExample
//
//  Created by Colin Eberhardt on 30/10/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "CEObservableMutableArray.h"

/// A view model which contains a list of stock quotes
@interface QuoteListViewModel : NSObject

/// A list of stock quotes
@property (nonatomic, strong) CEObservableMutableArray *quotes;

/// A property that indicates whether price streaming is paused or not
@property (nonatomic) BOOL paused;

/// A command which toggles the streaming state
@property (nonatomic, strong) RACCommand *toggleStreamingCommand;

@end
