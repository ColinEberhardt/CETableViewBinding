//
//  ViewController.m
//  QuotesListExample
//
//  Created by Colin Eberhardt on 29/10/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import "QuoteListViewController.h"
#import "CETableViewBindingHelper.h"
#import "QuoteListViewModel.h"

@interface QuoteListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *quotesTableView;

@end

@implementation QuoteListViewController {
  QuoteListViewModel *_viewModel;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
    _viewModel = [QuoteListViewModel new];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  UINib *nib = [UINib nibWithNibName:@"QuoteTableViewCell" bundle:nil];
  [CETableViewBindingHelper bindingHelperForTableView:self.quotesTableView
                                         sourceSignal:RACObserve(_viewModel, quotes)
                                     selectionCommand:nil
                                         templateCell:nib];
}

@end
