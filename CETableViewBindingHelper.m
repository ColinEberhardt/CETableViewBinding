//
//  RWTableViewBindingHelper.m
//  RWTwitterSearch
//
//  Created by Colin Eberhardt on 24/04/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import "CETableViewBindingHelper.h"
#import "CEReactiveView.h"
#import <ReactiveCocoa/RACEXTScope.h>
#import "CEObservableMutableArray.h"

@interface CETableViewBindingHelper () <UITableViewDataSource, UITableViewDelegate, CEObservableMutableArrayDelegate>

@end

@implementation CETableViewBindingHelper {
  UITableView *_tableView;
  NSArray *_data;
  UITableViewCell *_templateCell;
  RACCommand *_selection;
}

#pragma  mark - initialization

- (instancetype)initWithTableView:(UITableView *)tableView
                     sourceSignal:(RACSignal *)source
                 selectionCommand:(RACCommand *)selection
                     templateCell:(UINib *)templateCellNib {
  
  if (self = [super init]) {
    _tableView = tableView;
    _data = [NSArray array];
    _selection = selection;
    
    // each time the view model updates the array property, store the latest
    // value and reload the table view
    [source subscribeNext:^(id x) {
      if ([x isKindOfClass:[CEObservableMutableArray class]]) {
        ((CEObservableMutableArray *)x).delegate = self;
      }
      if (self->_data != nil && [self->_data isKindOfClass:[CEObservableMutableArray class]]) {
        ((CEObservableMutableArray *)self->_data).delegate = nil;
      }
      self->_data = x;
      [self->_tableView reloadData];
    }];
    
    // create an instance of the template cell and register with the table view
    _templateCell = [[templateCellNib instantiateWithOwner:nil options:nil] firstObject];
    [_tableView registerNib:templateCellNib forCellReuseIdentifier:_templateCell.reuseIdentifier];
    
    // use the template cell to set the row height
    _tableView.rowHeight = _templateCell.bounds.size.height;
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
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
  return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  id<CEReactiveView> cell = [tableView dequeueReusableCellWithIdentifier:_templateCell.reuseIdentifier];
  if ([cell respondsToSelector:@selector(bindViewModel:)]) {
    [cell bindViewModel:_data[indexPath.row]];
  } else {
    NSLog(@"The cells supplied to the CETableViewBindingHelper must implement the CEReactiveView protocol");
  }
  return (UITableViewCell *)cell;
}

#pragma mark = UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  // execute the command
  [_selection execute:_data[indexPath.row]];
  
  // forward the delegate method
  if ([self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
    [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
  }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    if ([_data isKindOfClass:[CEObservableMutableArray class]]) {
      [((CEObservableMutableArray *)_data) removeObjectAtIndex:indexPath.row];
    } else {
      NSLog(@"The array bound to the table view must be a CEObservableMutableArray");
    }
  }
}

#pragma mark = UITableViewDelegate forwarding

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if ([self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
    [self.delegate scrollViewDidScroll:scrollView];
  }
}

- (BOOL)respondsToSelector:(SEL)aSelector {
  if ([self.delegate respondsToSelector:aSelector]) {
    return YES;
  }
  return [super respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
  if ([self.delegate respondsToSelector:aSelector]) {
    return self.delegate;
  }
  return [super forwardingTargetForSelector:aSelector];
}

#pragma mark = CEObservableMutableArrayDelegate methods

- (void)array:(CEObservableMutableArray *)array didAddItemAtIndex:(NSUInteger)index {
  [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
}

- (void)array:(CEObservableMutableArray *)array didRemoveItemAtIndex:(NSUInteger)index {
  [_tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
}

@end
