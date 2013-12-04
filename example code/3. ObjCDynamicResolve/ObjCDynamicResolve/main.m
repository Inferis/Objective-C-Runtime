//
//  main.c
//  ObjCSimple
//

#include <Foundation/Foundation.h>
#include <objc/runtime.h>

@interface A : NSObject

- (id)initWithDictionary:(NSDictionary*)dictionary;


@end

@interface A (Beu)

@property (nonatomic, strong) id cocoaheadsbe;

@end

@implementation A {
    NSMutableDictionary* _dictionary;
}

- (id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [self init];
    if (self) {
        _dictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    }
    return self;
}

id getterImplementation(A* self, SEL _cmd)
{
    NSString* selName = NSStringFromSelector(_cmd);
    return self->_dictionary[[selName lowercaseString]];
}


//+ (BOOL)resolveInstanceMethod:(SEL)sel {
//    class_addMethod([self class], sel, (IMP)getterImplementation, "@@:");
//    return YES;
//}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSString* selName = NSStringFromSelector(sel);

    if ([selName rangeOfString:@"set"].location == 0) {
        // starts with set
        IMP imp = imp_implementationWithBlock(^(A* self, id value) {
            NSString* key = [[selName substringWithRange:NSMakeRange(3, selName.length-4)] lowercaseString];
            self->_dictionary[key] = value;
        });
        class_addMethod([self class], sel, imp, "v@:@");
        NSLog(@"adding setter method %@ to %@ with a block IMP", selName, self);
    }
    else {
        NSLog(@"adding getter method %@ to %@ with a function IMP", selName, self);
        class_addMethod(self, sel, (IMP)getterImplementation, "@@:");
    }

    return YES;
}

@end


int main(int argc, char **argv)
{
    A* obj = [[A alloc] initWithDictionary:@{@"cocoaheadsbe": @"represent"}];

    NSLog(@"cocoaheads value = %@", [obj cocoaheadsbe]);
    [obj setCocoaheadsbe:@"where are those little hands"];
    NSLog(@"cocoaheads value = %@", [obj cocoaheadsbe]);

    return 0;
}