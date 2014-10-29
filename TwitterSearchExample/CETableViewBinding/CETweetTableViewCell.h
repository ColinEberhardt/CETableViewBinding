//
//  CETweetTableViewCell.h
//  CETableViewBinding
//
//  Created by Colin Eberhardt on 28/04/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CEReactiveView.h"


@interface CETweetTableViewCell : UITableViewCell <CEReactiveView>

- (void)bindViewModel:(id)viewModel;

@end
