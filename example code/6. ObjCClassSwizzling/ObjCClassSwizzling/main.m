//
//  main.c
//  ObjCSimple
//

#include <Foundation/Foundation.h>
#include <objc/runtime.h>

@interface Person : NSObject

- (NSString*)ohai;
- (void)becomeFrenchie;

@end

@interface FrenchPerson : Person

- (NSString*)ohai;

@end

@implementation Person

- (NSString *)ohai {
    return @"ohai";
}

- (void)becomeFrenchie {
    object_setClass(self, [FrenchPerson class]);
}

- (void)becomePolyglot:(NSString*)language {
    NSString* subclassName = [NSString stringWithFormat:@"%@_%@", [self class], language];
    Class subclass = NSClassFromString(subclassName);
    if (subclass != nil) {
        NSLog(@"Already speaks fluently %@", language);
        return;
    }

    subclass = objc_allocateClassPair([self class], [subclassName UTF8String], 0);
    if (subclass == nil) {
        NSLog(@"Objective c doesn't want me to speak %@", language);
        return;
    }
    objc_registerClassPair(subclass);

    // now add the custom ohai selector
    IMP polyOhai = imp_implementationWithBlock(^(id self) {
        return [NSString stringWithFormat:@"%@ %@", language, [self superOhai]];
    });
    class_addMethod(subclass, @selector(ohai), polyOhai, "@@:");

    // since we want to call the super ohai, we define a new method that will
    // call the implementation of the superclass (the class we're in now, effectively)
    Method superOhaiMethod = class_getInstanceMethod([self class], @selector(ohai));
    IMP superOhaiImp = method_getImplementation(superOhaiMethod);
    class_addMethod(subclass, @selector(superOhai), superOhaiImp, "@@:");

    object_setClass(self, subclass);
}

@end

@implementation FrenchPerson

- (NSString *)ohai {
    return @"le ohai";
}

@end


int main(int argc, char **argv)
{
    Person* obj = [Person new];
    NSLog(@"not swizzled -> %@ (am %@)", [obj ohai], obj);
    [obj becomeFrenchie];
    NSLog(@"swizzled -> %@ (am %@)", [obj ohai], obj);
    [obj becomeFrenchie];
    NSLog(@"still swizzled -> %@ (am %@)", [obj ohai], obj);
    [obj becomePolyglot:@"nou moe"];
    NSLog(@"still swizzled -> %@ (am %@)", [obj ohai], obj);

    Person* greek = [Person new];
    [greek becomePolyglot:@"calimera"];
    NSLog(@"greek -> %@ (am %@)", [greek ohai], greek);
}