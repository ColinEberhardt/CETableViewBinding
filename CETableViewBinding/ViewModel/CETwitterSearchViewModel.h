//
//  CETwitterSearchViewModel.h
//  CETableViewBinding
//
//  Created by Colin Eberhardt on 28/04/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

/// A view model which provides a mechanism for searching twitter
@interface CETwitterSearchViewModel : NSObject

/// The current search text
@property NSString *searchText;

/// An array of CETweetViewModel instances which indicate the current search results
@property NSArray *searchResults;

@property RACCommand *searchCommand;

@end
