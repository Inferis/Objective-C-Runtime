//
//  main.c
//  ObjCSimple
//

#include <Foundation/Foundation.h>
#include <malloc/malloc.h>
#include <objc/runtime.h>

@protocol Ohai

- (NSString*)ohai;
- (void)kthxbye;

@end

@interface A : NSObject {
    @public NSUInteger a;
}
@end
@implementation A
@end

@interface B : A<Ohai> {
    @public NSUInteger b;
}
@end
@implementation B

- (NSString*)ohai {
    return @"OHAI";
}

@end

@interface C : B {
    @public NSUInteger c;
} @end
@implementation C


@end


int main(int argc, char **argv)
{
    C *cobj = [[C alloc] init];
    cobj->a = 0xaaaaaaaa;
    cobj->b = 0xbbbbbbbb;
    cobj->c = 0xcccccccc;

    B *bobj = [[B alloc] init];

    NSData *objData = [NSData dataWithBytes:(__bridge void*)cobj length:malloc_size((__bridge void*)cobj)];
    NSLog(@"cobj contains %@", objData);
    [objData release];

    // class, superclass
    NSLog(@"%@ isa %@ isa %@ isa %@",
          [C class],
          [C superclass],
          [[C superclass] superclass],
          [[[C superclass] superclass] superclass]);
    NSLog(@"%@ is subclass of %@ -> %@", [C class], [A class], [[C class] isSubclassOfClass:[A class]] ? @"YES" : @"NO");
    NSLog(@"%@ is subclass of %@ -> %@", [A class], [C class], [[A class] isSubclassOfClass:[C class]] ? @"YES" : @"NO");

    // isKindOfClass
    NSLog(@"cobj isKindOfClass:A -> %@", [cobj isKindOfClass:[A class]] ? @"YES" : @"NO");
    NSLog(@"cobj isMemberOfClass:A -> %@", [cobj isMemberOfClass:[A class]] ? @"YES" : @"NO");
    NSLog(@"cobj isKindOfClass:C -> %@", [cobj isKindOfClass:[C class]] ? @"YES" : @"NO");
    NSLog(@"cobj isMemberOfClass:C -> %@", [cobj isMemberOfClass:[C class]] ? @"YES" : @"NO");

    // protocols/selectors
    NSLog(@"cobj conformsTo:Greeting -> %@", [cobj conformsToProtocol:@protocol(Ohai)] ? @"YES" : @"NO");
    NSLog(@"cobj respondsToSelector:ohai -> %@", [cobj respondsToSelector:@selector(ohai)] ? @"YES" : @"NO");
    NSLog(@"cobj respondsToSelector:kthxbye -> %@", [cobj respondsToSelector:@selector(kthxbye)] ? @"YES" : @"NO");
    NSLog(@"A instances respondToSelector:ohai -> %@", [[A class] instancesRespondToSelector:@selector(ohai)] ? @"YES" : @"NO");
    NSLog(@"B instances respondToSelector:ohai -> %@", [[B class] instancesRespondToSelector:@selector(ohai)] ? @"YES" : @"NO");
    NSLog(@"B instances respondToSelector:kthxbye -> %@", [[B class] instancesRespondToSelector:@selector(kthxbye)] ? @"YES" : @"NO");
    NSLog(@"cobj performSelector:ohai -> %@", [cobj performSelector:@selector(ohai)]);

    [cobj release];

    return 0;
}