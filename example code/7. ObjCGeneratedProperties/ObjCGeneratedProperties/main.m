//
//  main.c
//  ObjCSimple
//

#include <Foundation/Foundation.h>
#include <objc/runtime.h>

@interface Dynamic : NSObject


@end

@implementation Dynamic

- (id)initWithProperties:(NSArray*)properties
{
    self = [super init];
    if (self) {
        for (NSString* property in properties) {
            [[self class] makeProperty:property];
        }
    }
    return self;
}

+ (void)makeProperties:(NSArray*)properties
{
    for (NSString* property in properties) {
        [self makeProperty:property];
    }
}

+ (void)makeProperty:(NSString*)property {
    // getter
    NSString* ivarName = [@"_" stringByAppendingString:property];
    const char* c_ivarName = [ivarName cStringUsingEncoding:NSUTF8StringEncoding];

    IMP getter = imp_implementationWithBlock(^(id obj) {
        return objc_getAssociatedObject(obj, c_ivarName);
    });
    class_addMethod(self, NSSelectorFromString(property), getter, "@@:");

    // setter
    IMP setter = imp_implementationWithBlock(^(id obj, id value) {
        objc_setAssociatedObject(obj, c_ivarName, value, OBJC_ASSOCIATION_RETAIN);
    });
    property = [NSString stringWithFormat:@"set%@:", [property capitalizedString]];
    class_addMethod(self, NSSelectorFromString(property), setter, "v@:@");
}

@end


int main(int argc, char **argv)
{
    [Dynamic makeProperties:@[@"foo", @"bar", @"baz"]];

    Dynamic* dyn = [Dynamic new];
    NSLog(@"dyn foo -> %@", [dyn foo]);
    [dyn setFoo:@"this is foo"];
    NSLog(@"dyn foo after setting -> %@", [dyn foo]);

    @try {
        NSLog(@"dyn beer -> %@", [dyn beer]);
    }
    @catch (NSException *exception) {
        NSLog(@"OH NOES DEAD %@", exception);
    }

    [Dynamic makeProperties:@[@"beer"]];

    @try {
        NSLog(@"dyn beer -> %@", [dyn beer]);
    }
    @catch (NSException *exception) {
        // shouldn't happen
        NSLog(@"OH NOES DEAD %@", exception);
    }
}