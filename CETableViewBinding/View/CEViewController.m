//
//  CEViewController.m
//  CETableViewBinding
//
//  Created by Colin Eberhardt on 28/04/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import "CEViewController.h"
#import "CETwitterSearchViewModel.h"
#import "CETableViewBindingHelper.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface CEViewController ()

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *searchResultsTable;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@property (strong, nonatomic) CETwitterSearchViewModel *viewModel;

@end

@implementation CEViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
	
  self.viewModel = [CETwitterSearchViewModel new];
  
  RAC(self.viewModel, searchText) = self.searchTextField.rac_textSignal;
  
  self.searchButton.rac_command = self.viewModel.searchCommand;
  
  [self.viewModel.searchCommand.executing subscribeNext:^(id x) {
    [self.searchTextField resignFirstResponder];
  }];
  
  RAC([UIApplication sharedApplication], networkActivityIndicatorVisible) = self.viewModel.searchCommand.executing;
  
  
  UINib *nib = [UINib nibWithNibName:@"CETweetTableViewCell" bundle:nil];
  [CETableViewBindingHelper bindingHelperForTableView:self.searchResultsTable sourceSignal:RACObserve(self.viewModel, searchResults) selectionCommand:Nil templateCell:nib];
}

@end
