//
//  pqueue.h
//  pqueue
//
//  Created by Mariusz on 8/24/12.
//  Copyright (c) 2012 Mariusz Śpiewak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSPriorityQueue : NSObject
{
    @private
    NSMutableArray *_queueArray;
}

@property(nonatomic, copy) NSComparisonResult (^comparator)(id obj1, id obj2);

- (id)init;
- (id)initWithComparator:(NSComparisonResult (^)(id obj1, id obj2))comparator;

- (void)addObject:(id)object;
- (id)peek;
- (id)dequeue;
- (NSInteger)count;
- (void)removeAllObjects;

@end
