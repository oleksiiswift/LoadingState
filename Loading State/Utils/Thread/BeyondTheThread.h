#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BeyondTheThread: NSObject

-(instancetype) init;
-(void) getThread: (void (^) (void) )block;

@end

NS_ASSUME_NONNULL_END
