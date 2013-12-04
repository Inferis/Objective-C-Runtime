//
//  main.c
//  ObjCSimple
//

#include <Foundation/Foundation.h>

@class Curl;

@interface LocalCurl : NSObject @end
@interface RemoteCurl : NSObject @end

@interface Curl : NSObject

@property (nonatomic, assign) BOOL local;

- (NSString*)fetch:(NSString*)url;

@end

@implementation Curl

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.local ? (id)[LocalCurl new] : (id)[RemoteCurl new];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature* signature = [super methodSignatureForSelector:aSelector];

    if (!signature && aSelector == @selector(fetch:)) {
        return [NSMethodSignature signatureWithObjCTypes:"@@:@"];
    }

    return nil;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    id target = self.local ? (id)[LocalCurl new] : (id)[RemoteCurl new];
    [anInvocation invokeWithTarget:target];
}

@end

@implementation LocalCurl

- (NSString*)fetch:(NSString*)url
{
    // sanitize the filename
    url = [url stringByReplacingOccurrencesOfString:@":" withString:@"_"];
    url = [url stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    url = [url stringByReplacingOccurrencesOfString:@"." withString:@"_"];

    NSString* path = [url stringByAppendingString:@".html"];
    NSLog(@"fetching locally");
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}

@end

@implementation RemoteCurl

- (NSString*)fetch:(NSString*)url
{
    NSURL* realUrl = [NSURL URLWithString:url];
    NSLog(@"fetching remotely");
    return [NSString stringWithContentsOfURL:realUrl encoding:NSUTF8StringEncoding error:nil];
}

@end


int main(int argc, char **argv)
{
    Curl* curl = [Curl new];

    curl.local = YES;
    NSLog(@"local respondsToSelector:fetch -> %@", [curl respondsToSelector:@selector(fetch:)] ? @"YES" : @"NO");
    NSLog(@"local result = %@", [curl fetch:@"http://cocoaheads.be"]);

    curl.local = NO;
    NSLog(@"remote respondsToSelector:fetch -> %@", [curl respondsToSelector:@selector(fetch:)] ? @"YES" : @"NO");
    NSLog(@"remote result = %@", [curl fetch:@"http://cocoaheads.be"]);

    return 0;
}