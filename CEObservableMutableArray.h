//
//  CEObservableMutableArray.h
//  CETableViewBinding
//
//  Created by Colin Eberhardt on 29/10/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CEObservableMutableArray;

@protocol CEObservableMutableArrayDelegate <NSObject>

@optional

- (void)array:(CEObservableMutableArray *)array didAddItemAtIndex:(NSUInteger) index;

- (void)array:(CEObservableMutableArray *)array didRemoveItemAtIndex:(NSUInteger) index;

@end


@interface CEObservableMutableArray : NSMutableArray

- (instancetype) initWithArray:(NSArray *)array;

@property (nonatomic, assign) id<CEObservableMutableArrayDelegate> delegate;

@end


