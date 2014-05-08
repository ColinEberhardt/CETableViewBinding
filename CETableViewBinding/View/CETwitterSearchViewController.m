//
//  CEViewController.m
//  CETableViewBinding
//
//  Created by Colin Eberhardt on 28/04/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import "CETwitterSearchViewController.h"
#import "CETwitterSearchViewModel.h"
#import "CETableViewBindingHelper.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface CETwitterSearchViewController ()

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *searchResultsTable;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@property (strong, nonatomic) CETwitterSearchViewModel *viewModel;

@end

@implementation CETwitterSearchViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
	
  self.viewModel = [CETwitterSearchViewModel new];
  
  // bind the UITextField text updates to the view model
  RAC(self.viewModel, searchText) = self.searchTextField.rac_textSignal;
  
  // bind a button to the search command
  self.searchButton.rac_command = self.viewModel.searchCommand;
  
  // when the search executes hide the keyboard
  [self.viewModel.searchCommand.executing subscribeNext:^(id x) {
    [self.searchTextField resignFirstResponder];
  }];
  
  // show a network activity indicator when the search is being executed
  RAC([UIApplication sharedApplication], networkActivityIndicatorVisible) =
    self.viewModel.searchCommand.executing;
  
  
  UINib *nib = [UINib nibWithNibName:@"CETweetTableViewCell" bundle:nil];
  [CETableViewBindingHelper bindingHelperForTableView:self.searchResultsTable
                                         sourceSignal:RACObserve(self.viewModel, searchResults)
                                     selectionCommand:self.viewModel.tweetSelectedCommand
                                         templateCell:nib];
}

@end
