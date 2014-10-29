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
@property (nonatomic, strong) NSString *searchText;

/// An array of CETweetViewModel instances which indicate the current search results
@property (nonatomic, strong) NSArray *searchResults;

/// A command which when executed searches twitter using the current searchText
@property (nonatomic, strong) RACCommand *searchCommand;

/// A command which when executed when a tweet is selected
@property (nonatomic, strong) RACCommand *tweetSelectedCommand;

@end
