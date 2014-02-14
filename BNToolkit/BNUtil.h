//
//  BNUtil.h
//  Common Generic Utility Functions
//
//  Created by Scott Talbot on 24/11/11.
//  Copyright (c) 2011 Wunderman Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#pragma mark Macros
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

#define IS_OBJECT_EQUAL_TO_OBJECT(s1, s2) ( ((s1) == (s2)) || ([(s1) isEqual:(s2)]) )


#pragma mark - Random Operations

static const unsigned long MAX_ARC4_RANDOM = 4294967295UL;

double BNRandDouble(double x);
int BNRandInt(int x);
int BNRandomNumberDifferentFromNumber(int maxValue, int existingValue);


#pragma mark - Class Operations
id BNEnsureKindOfClass(Class, id);

#define DECLARE_BNEnsure(klass) klass *BNEnsure##klass(id)

DECLARE_BNEnsure(NSArray);
DECLARE_BNEnsure(NSDictionary);
DECLARE_BNEnsure(NSNumber);
DECLARE_BNEnsure(NSSet);
DECLARE_BNEnsure(NSString);

#undef DECLARE_BNEnsure

#pragma mark - Array Operations
NSArray *BNArrayArrayByRemovingLastObject(NSArray *array);

id BNArrayFirstObjectOrNil(NSArray *array);

NSUInteger BNArrayIndexOfBestObjectUsingComparator(NSArray *array, NSComparator comparator);

#pragma mark - String Operations
NSString *BNStringStringByRemovingCharactersInSet(NSString *string, NSCharacterSet *characterSet);

BOOL BNStringIsStringByRemovingLeadingAndTrailingSpacesEmpty(NSString *string);

NSString *BNStringByRemovingSuffix(NSString *string, NSString *suffix);

BOOL BNStringIsValidEmail(NSString* string);

NSString *BNUUID(void);

inline NSString * BNBoolToString(BOOL aBool);

#pragma mark Rect Operations
typedef enum BNRectAxis {
    BNRectAxisBoth = 3,
    BNRectAxisX = 1,
    BNRectAxisY = 2,
} BNRectAxis;

void BNRectDivide(CGRect rect, CGRect *slice, CGRect *remainder, CGFloat amount, CGRectEdge edge);
CGPoint BNRectGetCenterPoint(CGRect rect);
CGRect BNRectScaleAspectFit(CGRect containingRect, CGRect rect);
CGRect BNRectCenterRect(CGRect containingRect, CGRect rect);
CGRect BNRectCenterRectOnAxis(CGRect containingRect, CGRect rect, BNRectAxis axis);

CGPathRef BNRoundedRectPathCreate(CGRect rect, CGFloat cornerRadius);


#pragma mark - UIView and Derivatives

UIView *BNFindFirstSuperviewOfClass(UIView *, Class);
UIView *BNFindFirstSubviewOfClass(UIView *, Class);

UIView *BNFindFirstResponder(UIView *);

CGFloat BNLabelWidthForHeight(UILabel *label, CGFloat height);

CGPoint BNScrollViewContentOffsetToCenterRect(UIScrollView *scrollView, CGRect rect);

#pragma mark Location Services and Helpers
BOOL BNLocationCoordinate2DEqualToCooordinate2D(CLLocationCoordinate2D a, CLLocationCoordinate2D b);
double BNLocationCoordinate2DDistanceToCoordinate2D(CLLocationCoordinate2D a, CLLocationCoordinate2D b);

static const inline double deg2rad(double);

inline void BNOffsetView(UIView *view, CGFloat x, CGFloat y);




