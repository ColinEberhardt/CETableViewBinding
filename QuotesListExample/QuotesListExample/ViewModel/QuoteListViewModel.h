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

@interface QuoteListViewModel : NSObject

@property (nonatomic, strong) CEObservableMutableArray *quotes;
@property (nonatomic) BOOL paused;

/// A command which when executed searches twitter using the current searchText
@property (nonatomic, strong) RACCommand *toggleStreamingCommand;

@end
