#import "RCTMathFunc.h"
#import "HWMathFunc.h"

@implementation RCTMathFunc{
  HWMathFunc *_cppApi;
}
- (RCTMathFunc *)init
{
  self = [super init];
  _cppApi = [HWMathFunc create];
  return self;
}
+ (BOOL)requiresMainQueueSetup
{
  return NO;
}

RCT_EXPORT_MODULE();
RCT_REMAP_METHOD(add, numberA:(nonnull NSNumber *)numberA numberB:(nonnull NSNumber *)numberB
                 add_resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
  double response = [_cppApi add:[numberA doubleValue] b:[numberB doubleValue] ];
  NSString *number = [NSString stringWithFormat:@"%.20lf", response];
  resolve(number);
}
RCT_REMAP_METHOD(subtract, numberA:(nonnull NSNumber *)numberA numberB:(nonnull NSNumber *)numberB
                 subtract_resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
  double response = [_cppApi subtract:[numberA doubleValue] b:[numberB doubleValue] ];
  NSString *number = [NSString stringWithFormat:@"%.20lf", response];
  resolve(number);
}
RCT_REMAP_METHOD(multiply, numberA:(nonnull NSNumber *)numberA numberB:(nonnull NSNumber *)numberB
                 multiply_resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
  double response = [_cppApi multiply:[numberA doubleValue] b:[numberB doubleValue] ];
  NSString *number = [NSString stringWithFormat:@"%.20lf", response];
  resolve(number);
}
RCT_REMAP_METHOD(divide, numberA:(nonnull NSNumber *)numberA numberB:(nonnull NSNumber *)numberB
                 divide_resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
  double response = [_cppApi divide:[numberA doubleValue] b:[numberB doubleValue] ];
  NSString *number = [NSString stringWithFormat:@"%.20lf", response];
  resolve(number);
}
@end
