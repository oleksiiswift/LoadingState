#import "BeyondTheThread.h"

@interface BeyondTheThread() {
	NSThread* beyondTheThread;
	NSRunLoop* beyondThreadRunLoop;
	NSConditionLock* beyondhreadLock;
}
@end

@implementation BeyondTheThread

- (instancetype)init {
	[self createThread];
	return self;
}

- (void)getThread: (void (^) (void))block {
	NSRunLoop* runLoop = beyondThreadRunLoop;
	if (runLoop) {
		CFRunLoopPerformBlock([runLoop getCFRunLoop], NSRunLoopCommonModes, block);
		CFRunLoopWakeUp ([runLoop getCFRunLoop]);
	} else {
		NSLog(@"Shit");
	}
}

-(void) createThread {
	beyondTheThread = [[NSThread alloc] initWithTarget:self selector:@selector(startInternal) object:nil];
	[beyondTheThread start];
	[beyondhreadLock lockWhenCondition:1];
	[beyondhreadLock unlockWithCondition:0];
}

-(void) startInternal {
	@autoreleasepool {
		beyondThreadRunLoop = [NSRunLoop currentRunLoop];
		[beyondhreadLock lockWhenCondition:0];
		[beyondhreadLock unlockWithCondition:1];
		NSThread.currentThread.threadPriority = 1;
		[beyondThreadRunLoop addPort: [NSPort port] forMode:NSDefaultRunLoopMode];
		
		while (true) {
			@autoreleasepool {
				if (![self processRunLoopForStart]) { break;}
			}
			
			NSDate* date = [[NSDate alloc] initWithTimeIntervalSinceNow: 16];
			[beyondThreadRunLoop runMode: NSDefaultRunLoopMode beforeDate:date];
		}
	}
}

-(BOOL) processRunLoopForStart {
	return  YES;
}

@end




