//
//  main.c
//  ObjCSimple
//

#include <Foundation/Foundation.h>
#include <objc/runtime.h>

@interface A : NSObject

- (NSString*)ohai;
- (NSString *)french_ohai;
- (void)becomeFrenchie;

@end

@implementation A

- (NSString *)ohai {
    return @"ohai";
}

- (NSString *)french_ohai {
    return @"le ohai";
}

- (void)becomeFrenchie {
    Method orig = class_getInstanceMethod([self class], @selector(ohai));
    Method french = class_getInstanceMethod([self class], @selector(french_ohai));
    method_exchangeImplementations(orig, french);
    NSLog(@"Feeling swizzly!");
}

@end

int main(int argc, char **argv)
{
    A* obj = [A new];
    NSLog(@"not swizzled: %@ (in french: %@)", [obj ohai], [obj french_ohai]);
    [obj becomeFrenchie];
    NSLog(@"swizzled: %@ (in french: %@)", [obj ohai], [obj french_ohai]);
    [obj becomeFrenchie];
    NSLog(@"unswizzled: %@ (in french: %@)", [obj ohai], [obj french_ohai]);
}