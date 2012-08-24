//
//  pqueueTests.m
//  pqueueTests
//
//  Created by Mariusz on 8/24/12.
//  Copyright (c) 2012 Mariusz Śpiewak. All rights reserved.
//

#import "pqueueTests.h"

@implementation pqueueTests

- (void)setUp
{
    [super setUp];
    
    queue = [[MSPriorityQueue alloc] init];
}

- (void)tearDown
{
    // Tear-down code here.
    [queue release];
    [super tearDown];
}

- (void)testInsert
{
    NSNumber *num1 = [NSNumber numberWithInt:10];
    NSNumber *num2 = [NSNumber numberWithInt:20];
    NSNumber *num3 = [NSNumber numberWithInt:30];
    
    [queue addObject:num2];
    STAssertEquals([queue count], 1, @"Count should be 1");
    [queue addObject:num3];
    STAssertEquals([queue count], 2, @"Count should be 2");
    [queue addObject:num1];
    STAssertEquals([queue count], 3, @"Count should be 3");
    
    [queue removeAllObjects];
}

- (void)testPeek
{
    NSNumber *num1 = [NSNumber numberWithInt:10];
    NSNumber *num2 = [NSNumber numberWithInt:20];
    NSNumber *num3 = [NSNumber numberWithInt:30];
    
    STAssertNil([queue peek], @"Peeking an empty queue - should be nil");
    
    [queue addObject:num1];
    int count = [queue count];
    STAssertEqualObjects([queue peek], num1, @"Peeking first object - should equal num1");
    STAssertEquals([queue count], count, @"Count after peek should be same");
    
    [queue addObject:num3];
    count = [queue count];
    STAssertEqualObjects(num3, [queue peek], @"Peeking second object (larger than first inserted)");
    STAssertEquals([queue count], count, @"Count after peek should be same");
    
    [queue addObject:num2];
    count = [queue count];
    STAssertEqualObjects(num3, [queue peek], @"Peeking third object (smaller than first inserted, should still be second)");
    STAssertEquals([queue count], count, @"Count after peek should be same");
}

- (void)testDequeue
{
    NSNumber *num1 = [NSNumber numberWithInt:10];
    NSNumber *num2 = [NSNumber numberWithInt:20];
    NSNumber *num3 = [NSNumber numberWithInt:30];
    
    [queue addObject:num2];
    [queue addObject:num3];
    [queue addObject:num1];
    
    id dequeued = [queue dequeue];
    STAssertEqualObjects(dequeued, num3, @"Dequeued object should be the largest");
    dequeued = [queue dequeue];
    STAssertEqualObjects(dequeued, num2, @"Dequeued object should be the largest");
    dequeued = [queue dequeue];
    STAssertEqualObjects(dequeued, num1, @"Dequeued object should be the largest");
}

- (void)testSpeed
{
    size_t objectsToInsert = 200000;
    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
    
    for (int i = 0; i < objectsToInsert; i++) {
        NSNumber *object = [NSNumber numberWithInt:arc4random()];
        [queue addObject:object];
    }
    NSTimeInterval stop = [NSDate timeIntervalSinceReferenceDate];
    NSLog(@"****   SPEED   ****");
    NSLog(@"Inserted %ld in %lf [s]", objectsToInsert, stop - start);
    
    start = [NSDate timeIntervalSinceReferenceDate];
    for (int i = 0; i < objectsToInsert; i++) {
        [queue dequeue];
    }
    stop = [NSDate timeIntervalSinceReferenceDate];
    NSLog(@"Dequeued %ld in %lf [s]", objectsToInsert, stop - start);
    
    start = [NSDate timeIntervalSinceReferenceDate];
    for (int i = 0; i < objectsToInsert; i++) {
        [queue peek];
    }
    stop = [NSDate timeIntervalSinceReferenceDate];
    NSLog(@"Peeked %ld elements in %lf [s]", objectsToInsert, stop - start);
    
    NSLog(@"**** END SPEED ****");
}

@end
