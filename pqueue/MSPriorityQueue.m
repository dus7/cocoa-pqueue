//
//  pqueue.m
//  pqueue
//
//  Created by Mariusz on 8/24/12.
//  Copyright (c) 2012 Mariusz Śpiewak. All rights reserved.
//

#import "MSPriorityQueue.h"

#define LEFT(x) (2*(x) + 1)
#define RIGHT(x) (2*(x) + 2)
#define PARENT(x) ((x) / 2)

@interface MSPriorityQueue (Private)
- (void)heapify:(NSInteger)index;
@end

@implementation MSPriorityQueue

@synthesize comparator=_comparator;

- (id)init
{
    self = [super init];
    if (self) {
        _queueArray = [[NSMutableArray alloc] init];
        self.comparator = ^NSComparisonResult(id obj1, id obj2) {
            if ([obj1 doubleValue] == [obj2 doubleValue]) {
                return NSOrderedSame;
            }
            if ([obj1 doubleValue] > [obj2 doubleValue]){
                return NSOrderedDescending;
            }
            return NSOrderedAscending;
        };
    }
    return self;
}

- (id)initWithComparator:(int (^)(id obj1, id obj2))comparator
{
    self = [self init];
    if (self) {
        self.comparator = comparator;
    }
    return self;
}

- (void)dealloc
{
    [_queueArray release];
    [super dealloc];
}


- (void)addObject:(id<NSObject>)object
{
    if (!object) {
        @throw [NSException exceptionWithName:@"NSArgumentException" reason:@"Passed object is nil" userInfo:nil];
    }
    
    NSInteger i = [_queueArray count];
    [_queueArray addObject:object];
    
    // Swap the new element with its parent while it's precedence has higher priority
    while (i > 0 && _comparator([_queueArray objectAtIndex:i], [_queueArray objectAtIndex:PARENT(i)]) > 0) {
        [_queueArray exchangeObjectAtIndex:i withObjectAtIndex:PARENT(i)];
        i = PARENT(i);
    }
}

- (id)peek
{
    if ([self count] > 0) {
        return [_queueArray objectAtIndex:0];
    } else {
        return nil;
    }
}

- (id)dequeue
{
    if ([_queueArray count] == 0) {
        NSLog(@"Warning: priority queue empty");
        return nil;
    }
    
    id first = [[_queueArray objectAtIndex:0] retain];
    [_queueArray exchangeObjectAtIndex:0 withObjectAtIndex:[self count]-1];
    [_queueArray removeLastObject];
    
    [self heapify:0];
    return [first autorelease];
}

- (void)removeAllObjects
{
    [_queueArray removeAllObjects];
    [_queueArray addObject:[NSNull null]];
}

- (NSInteger)count
{
    return [_queueArray count];
}

- (void)heapify:(NSInteger)index
{
    NSInteger lIdx,rIdx,size,largerIdx;
    
    size = [self count];
    lIdx = LEFT(index);
    rIdx = RIGHT(index);
    
    // There is left child
    if (lIdx < size && _comparator([_queueArray objectAtIndex:lIdx], [_queueArray objectAtIndex:index]) > 0) {
        largerIdx = lIdx;
    } else {
        largerIdx = index;
    }
    
    // There is right child
    if (rIdx < size && _comparator([_queueArray objectAtIndex:rIdx], [_queueArray objectAtIndex:largerIdx]) > 0) {
        largerIdx = rIdx;
    }
    
    if (largerIdx != index) {
        [_queueArray exchangeObjectAtIndex:index withObjectAtIndex:largerIdx];
        [self heapify:largerIdx];
    }
}

- (NSString *)description
{
    return [_queueArray description];
}

@end


