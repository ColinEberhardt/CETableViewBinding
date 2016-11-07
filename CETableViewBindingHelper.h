//
//  RWTableViewBindingHelper.h
//  RWTwitterSearch
//
//  Created by Colin Eberhardt on 24/04/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

/// A helper class for binding view models with NSArray properties to a UITableView.
@interface CETableViewBindingHelper : NSObject

// forwards the UITableViewDelegate methods
@property (weak, nonatomic) id<UITableViewDelegate> delegate;

- (instancetype)initWithTableView:(UITableView *)tableView
                     sourceSignal:(RACSignal *)source
                 selectionCommand:(RACCommand *)selection
                templateCellClass:(Class)templateCellClass
                  reuseIdentifier:(NSString *)identifier NS_DESIGNATED_INITIALIZER;

- (instancetype) initWithTableView:(UITableView *)tableView
                      sourceSignal:(RACSignal *)source
                  selectionCommand:(RACCommand *)selection
                      templateCell:(UINib *)templateCellNib NS_DESIGNATED_INITIALIZER;

+ (instancetype) bindingHelperForTableView:(UITableView *)tableView
                              sourceSignal:(RACSignal *)source
                          selectionCommand:(RACCommand *)selection
                              templateCell:(UINib *)templateCellNib;

+ (instancetype) bindingHelperForTableView:(UITableView *)tableView
                              sourceSignal:(RACSignal *)source
                          selectionCommand:(RACCommand *)selection
                         templateCellClass:(Class)templateCellClass
                           reuseIdentifier:(NSString *)identifier;


@end
