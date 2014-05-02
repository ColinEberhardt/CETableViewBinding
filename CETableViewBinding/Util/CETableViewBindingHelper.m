//
//  RWTableViewBindingHelper.m
//  RWTwitterSearch
//
//  Created by Colin Eberhardt on 24/04/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import "CETableViewBindingHelper.h"
#import "CEReactiveView.h"

@interface CETableViewBindingHelper () <UITableViewDataSource, UITableViewDelegate>

@property UITableView *tableView;
@property NSArray *data;
@property UITableViewCell *templateCell;
@property RACCommand *selection;

@end

@implementation CETableViewBindingHelper {
  
}

- (instancetype)initWithTableView:(UITableView *)tableView
                     sourceSignal:(RACSignal *)source
                 selectionCommand:(RACCommand *)selection
                     templateCell:(UINib *)templateCellNib {
  
  if (self = [super init]) {
    self.tableView = tableView;
    self.data = [NSArray array];
    self.selection = selection;
    
    // each time the view model updates the array property, store the latest
    // value and reload the table view
    [source subscribeNext:^(id x) {
      self.data = x;
      [self.tableView reloadData];
    }];
    
    // create an instance of the template cell and register with the table view
    self.templateCell = [[templateCellNib instantiateWithOwner:nil options:nil] firstObject];
    [self.tableView registerNib:templateCellNib forCellReuseIdentifier:self.templateCell.reuseIdentifier];
    
    // use the template cell to set the row height
    self.tableView.rowHeight = self.templateCell.bounds.size.height;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
  }
  return self;
}

+ (instancetype)bindingHelperForTableView:(UITableView *)tableView
                             sourceSignal:(RACSignal *)source
                         selectionCommand:(RACCommand *)selection
                             templateCell:(UINib *)templateCellNib{
  
  return [[CETableViewBindingHelper alloc] initWithTableView:tableView
                                                sourceSignal:source
                                            selectionCommand:selection
                                                templateCell:templateCellNib];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  id<CEReactiveView> cell = [tableView dequeueReusableCellWithIdentifier:self.templateCell.reuseIdentifier];
  [cell bindViewModel:self.data[indexPath.row]];
  return (UITableViewCell *)cell;
}

#pragma mark = UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self.selection execute:self.data[indexPath.row]];
}

@end
