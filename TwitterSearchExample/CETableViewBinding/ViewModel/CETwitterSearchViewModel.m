//
//  CETwitterSearchViewModel.m
//  CETableViewBinding
//
//  Created by Colin Eberhardt on 28/04/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import "CETwitterSearchViewModel.h"
#import "CETweetViewModel.h"
#import "RACEXTScope.h"
#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>


typedef NS_ENUM(NSInteger, RWTwitterInstantError) {
  RWTwitterInstantErrorAccessDenied,
  RWTwitterInstantErrorNoTwitterAccounts,
  RWTwitterInstantErrorInvalidResponse
};

static NSString * const RWTwitterInstantDomain = @"TwitterInstant";

@interface CETwitterSearchViewModel ()

@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) ACAccountType *twitterAccountType;

@end

@implementation CETwitterSearchViewModel

- (id)init {
  if (self = [super init]) {
    [self initialize];
  }
  return self;
}

- (void) initialize {
  
  // set up access to twitter
  self.accountStore = [[ACAccountStore alloc] init];
  self.twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];

  [[self requestAccessToTwitterSignal]
       subscribeNext:^(id x) {
         NSLog(@"Access accepted");
       }];
  
  // create the search command, using a signal that searches twitter
  self.searchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                            return [self signalForSearchWithText:self.searchText];
                           }];
  
  // create a signal which converts the results of a twitter search
  // into an array of CETweetViewModel instances
  RACSignal *searchResultsSignal =
    [[[self.searchCommand.executionSignals
      flattenMap:^RACStream *(id value) {
        return value;
      }]
      deliverOn:[RACScheduler mainThreadScheduler]]
      map:^id(NSDictionary *jsonSearchResult) {
        return [jsonSearchResult[@"statuses"] linq_select:^id(id tweet) {
          return [CETweetViewModel tweetWithStatus:tweet];
        }];
      }];
  
  RAC(self, searchResults) = searchResultsSignal;
  
  // create the tweet selected command, that simply logs
  self.tweetSelectedCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(CETweetViewModel *selectedViewModel) {
    NSLog(selectedViewModel.status);
    return [RACSignal empty];
  }];
}

- (RACSignal *)requestAccessToTwitterSignal {
  
  // 1 - define an error
  NSError *accessError = [NSError errorWithDomain:RWTwitterInstantDomain
                                             code:RWTwitterInstantErrorAccessDenied
                                         userInfo:nil];
  
  // 2 - create the signal
  @weakify(self)
  return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    // 3 - request access to twitter
    @strongify(self)
    [self.accountStore
     requestAccessToAccountsWithType:self.twitterAccountType
     options:nil
     completion:^(BOOL granted, NSError *error) {
       // 4 - handle the response
       if (!granted) {
         [subscriber sendError:accessError];
       } else {
         [subscriber sendNext:nil];
         [subscriber sendCompleted];
       }
     }];
    return nil;
  }];
}

- (SLRequest *)requestforTwitterSearchWithText:(NSString *)text {
  NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/search/tweets.json"];
  NSDictionary *params = @{@"q" : text};
  
  SLRequest *request =  [SLRequest requestForServiceType:SLServiceTypeTwitter
                                           requestMethod:SLRequestMethodGET
                                                     URL:url
                                              parameters:params];
  return request;
}

- (RACSignal *)signalForSearchWithText:(NSString *)text {
  
  // 1 - define the errors
  NSError *noAccountsError = [NSError errorWithDomain:RWTwitterInstantDomain
                                                 code:RWTwitterInstantErrorNoTwitterAccounts
                                             userInfo:nil];
  
  NSError *invalidResponseError = [NSError errorWithDomain:RWTwitterInstantDomain
                                                      code:RWTwitterInstantErrorInvalidResponse
                                                  userInfo:nil];
  
  // 2 - create the signal block
  @weakify(self)
  void (^signalBlock)(RACSubject *subject) = ^(RACSubject *subject) {
    @strongify(self);
    
    // 3 - create the request
    SLRequest *request = [self requestforTwitterSearchWithText:text];
    
    // 4 - supply a twitter account
    NSArray *twitterAccounts = [self.accountStore accountsWithAccountType:self.twitterAccountType];
    if (twitterAccounts.count == 0) {
      [subject sendError:noAccountsError];
      return;
    }
    [request setAccount:[twitterAccounts lastObject]];
    
    // 5 - perform the request
    [request performRequestWithHandler: ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
      if (urlResponse.statusCode == 200) {
        
        // 6 - on success, parse the response
        NSDictionary *timelineData = [NSJSONSerialization JSONObjectWithData:responseData
                                                                     options:NSJSONReadingAllowFragments
                                                                       error:nil];
        [subject sendNext:timelineData];
        [subject sendCompleted];
      }
      else {
        // 7 - send an error on failure
        [subject sendError:invalidResponseError];
      }
    }];
  };
  
  RACSignal *signal = [RACSignal startLazilyWithScheduler:[RACScheduler scheduler]
                                                    block:signalBlock];
  
  return signal;
}

@end
