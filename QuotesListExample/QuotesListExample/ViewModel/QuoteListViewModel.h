//
//  QuoteListViewModel.h
//  QuotesListExample
//
//  Created by Colin Eberhardt on 30/10/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CEObservableMutableArray.h"

@interface QuoteListViewModel : NSObject

@property (nonatomic, strong) CEObservableMutableArray *quotes;

@end
