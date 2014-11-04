//
//  ViewController.m
//  QuotesListExample
//
//  Created by Colin Eberhardt on 29/10/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "QuoteListViewController.h"
#import "CETableViewBindingHelper.h"
#import "QuoteListViewModel.h"

@interface QuoteListViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *pauseButton;
@property (weak, nonatomic) IBOutlet UITableView *quotesTableView;

@end

@implementation QuoteListViewController {
  QuoteListViewModel *_viewModel;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
    _viewModel = [QuoteListViewModel new];
    self.title = @"Stock Quotes";
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // bind the pause command to the view
  self.pauseButton.rac_command = _viewModel.toggleStreamingCommand;
  
  // update the button title based on the view mdoel
  RAC(self.pauseButton, title) =
    [RACObserve(_viewModel, paused)
      map:^id(NSNumber *x) {
        return [x boolValue] ? @"Resume" : @"Pause";
      }];

  // bind the table view to the list of quotes
  UINib *nib = [UINib nibWithNibName:@"QuoteTableViewCell" bundle:nil];
  [CETableViewBindingHelper bindingHelperForTableView:self.quotesTableView
                                         sourceSignal:RACObserve(_viewModel, quotes)
                                     selectionCommand:nil
                                         templateCell:nib];
}

@end
