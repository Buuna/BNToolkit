//
//  BNUtil.h
//  bluh
//
//  Created by Scott Talbot on 24/11/11.
//  Copyright (c) 2011 Wunderman Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#define COPY_STRING_IF_DIFFERENT(obj, x) do {\
        if (((obj.x != nil) && ![_##x isEqualToString:obj.x]) || ((obj.x == nil) && (_##x != nil))) {\
            [self willChangeValueForKey:@#x];\
            _##x = [obj.x copy];\
            [self didChangeValueForKey:@#x];\
        }\
    } while (0)

#define COPY_IVAR_IF_DIFFERENT(obj, x) do {\
        if (_##x != obj.x) {\
            [self willChangeValueForKey:@#x];\
            _##x = obj.x;\
            [self didChangeValueForKey:@#x];\
        }\
    } while (0)

#define EXTRACT_STRING_IVAR(dict, key, ivar) do {\
        NSString *tmp##ivar = [dict objectForKey:key];\
        if ([tmp##ivar isKindOfClass:[NSString class]]) {\
            ivar = [[NSString alloc] initWithString:tmp##ivar];\
        }\
    } while (0)

#define WRITE_STRING_IVAR_TO_DICT(dict, key, ivar) do {\
        if (ivar != nil) [dict setObject:ivar forKey:key]; \
    } while (0)

/*#define WRITE_STRING_IVAR_TO_DICT(dict, key, ivar) do {\
        [dict setObject:((ivar) ? (ivar) : [NSNull null]) forKey:(key)]; \
    } while (0)*/

#define IS_OBJECT_EQUAL_TO_OBJECT(s1, s2) ( ((s1) == (s2)) || ([(s1) isEqual:(s2)]) )

#define MAX_ARC4_RANDOM 4294967295UL
#define RND(x) ((double)arc4random() / (double)MAX_ARC4_RANDOM * (x))
#define RND_INT(x) (arc4random() % (u_int32_t)(x))

#define BOOL_TO_STRING(bool) (bool ? @"true" : @"false")

NSString *BNUUID(void);


id BNEnsureKindOfClass(Class, id);

#define DECLARE_BNEnsure(klass) klass *BNEnsure##klass(id)

DECLARE_BNEnsure(NSArray);
DECLARE_BNEnsure(NSDictionary);
DECLARE_BNEnsure(NSNumber);
DECLARE_BNEnsure(NSSet);
DECLARE_BNEnsure(NSString);

#undef DECLARE_BNEnsure


NSArray *BNArrayArrayByRemovingLastObject(NSArray *array);

id BNArrayFirstObjectOrNil(NSArray *array);

NSUInteger BNArrayIndexOfBestObjectUsingComparator(NSArray *array, NSComparator comparator);


NSString *BNStringStringByRemovingCharactersInSet(NSString *string, NSCharacterSet *characterSet);

BOOL BNStringIsStringByRemovingLeadingAndTrailingSpacesEmpty(NSString *string);

void BNRectDivide(CGRect rect, CGRect *slice, CGRect *remainder, CGFloat amount, CGRectEdge edge);

CGPoint BNRectGetCenter(CGRect rect);

CGRect BNRectScaleAspectFit(CGRect containingRect, CGRect rect);

typedef enum BNRectAxis {
    BNRectAxisBoth = 3,
    BNRectAxisX = 1,
    BNRectAxisY = 2,
} BNRectAxis;

CGRect BNRectCenter(CGRect containingRect, CGRect rect);
CGRect BNRectCenterOnAxis(CGRect containingRect, CGRect rect, BNRectAxis axis);


NSString *BNStringByRemovingSuffix(NSString *string, NSString *suffix);

UIImage *BNImageNamed(NSString *name);

UIView *BNFindFirstSuperviewOfClass(UIView *, Class);
UIView *BNFindFirstSubviewOfClass(UIView *, Class);

UIView *BNFindFirstResponder(UIView *);


CGPathRef BNRoundedRectPathCreate(CGRect rect, CGFloat cornerRadius);


BOOL BNLocationCoordinate2DEqualToCooordinate2D(CLLocationCoordinate2D a, CLLocationCoordinate2D b);
double BNLocationCoordinate2DDistanceToCoordinate2D(CLLocationCoordinate2D a, CLLocationCoordinate2D b);


CGFloat BNLabelWidthForHeight(UILabel *label, CGFloat height);

CGPoint BNScrollViewContentOffsetToCenterRect(UIScrollView *scrollView, CGRect rect);

///// XXX copied from AFHTTPClient::AFBase64EncodedStringFromString - it's private there
NSString * AFBase64EncodedStringFromData(NSData* data);

BOOL BNStringIsValidEmail(NSString* string);

int BNRandomNumberDifferentFromNumber(int maxValue, int existingValue);

void BNOffsetView(UIView *view, CGFloat x, CGFloat y);
