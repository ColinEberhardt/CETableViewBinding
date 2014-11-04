//
//  CEObservableMutableArray.h
//  CETableViewBinding
//
//  Created by Colin Eberhardt on 29/10/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CEObservableMutableArray;

/// a protocol that is used by observers of the CEObservableMutableArray to determine
/// when the array is mutated
@protocol CEObservableMutableArrayDelegate <NSObject>

@optional

/// invoked when an item is added to the array
- (void)array:(CEObservableMutableArray *)array didAddItemAtIndex:(NSUInteger) index;

/// invoked when an item is removed from the aray
- (void)array:(CEObservableMutableArray *)array didRemoveItemAtIndex:(NSUInteger) index;

/// invoked when an item is replaced
- (void)array:(CEObservableMutableArray *)array didReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;

@end

/// a mutable array that informs the delegate of mutations
@interface CEObservableMutableArray : NSMutableArray

- (instancetype) initWithArray:(NSArray *)array;

@property (nonatomic, assign) id<CEObservableMutableArrayDelegate> delegate;

@end


