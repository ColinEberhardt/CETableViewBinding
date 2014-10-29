//
//  CETweetViewModel.m
//  CETableViewBinding
//
//  Created by Colin Eberhardt on 28/04/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import "CETweetViewModel.h"

@implementation CETweetViewModel

+ (instancetype)tweetWithStatus:(NSDictionary *)status {
  CETweetViewModel *tweet = [CETweetViewModel new];
  tweet.status = status[@"text"];
  
  NSDictionary *user = status[@"user"];
  tweet.profileImageUrl = user[@"profile_image_url"];
  tweet.username = user[@"screen_name"];
  tweet.profileBannerUrl = user[@"profile_banner_url"];
  return tweet;
}

@end
