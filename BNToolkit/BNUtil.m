//
//  BNUtil.m
//  Common Generic Utility Functions
//
//  Created by Scott Talbot on 24/11/11.
//  Copyright (c) 2011 Wunderman Pty Ltd. All rights reserved.
//

#import "BNUtil.h"

#pragma mark - Class Operations
id BNEnsureKindOfClass(Class klass, id obj) {
    if ([obj isKindOfClass:klass])
        return obj;
    return nil;
}

#define DEFINE_BNEnsure(klass) klass *BNEnsure##klass(id obj) {\
    return BNEnsureKindOfClass([klass class], obj);\
}

DEFINE_BNEnsure(NSArray);
DEFINE_BNEnsure(NSDictionary);
DEFINE_BNEnsure(NSNumber);
DEFINE_BNEnsure(NSSet);
DEFINE_BNEnsure(NSString);

#undef DEFINE_BNEnsure

#pragma mark - Random Operations
int BNRandomNumberDifferentFromNumber(int maxValue, int existingValue) {
    if (maxValue < 1) {
        return maxValue;
    }
    if (maxValue == 1) {
        return (existingValue == 0) ? 1 : 0;
    }

    int nAttempt = 0;
    while (nAttempt++ < 100) {
        int n = BNRandInt(maxValue + 1);
        if (n != existingValue) {
            return n;
        }
    }
    return (existingValue < maxValue) ? (existingValue + 1) : (existingValue - 1);
}

int BNRandInt(int x) {
    return  (arc4random() % (u_int32_t)(x));
}

double BNRandDouble(double x) {
    return ((double)arc4random() / (double)MAX_ARC4_RANDOM * (x));
}




#pragma mark - Array Operations
NSArray *BNArrayArrayByRemovingLastObject(NSArray *array_) {
    NSMutableArray *array = [NSMutableArray arrayWithArray:array_];
    [array removeLastObject];
    return array;
}

id BNArrayFirstObjectOrNil(NSArray *array) {
    if ([array count] > 0)
        return [array objectAtIndex:0];
    return nil;
}


NSUInteger BNArrayIndexOfBestObjectUsingComparator(NSArray *array, NSComparator comparator) {
    NSArray *sortedArray = [array sortedArrayUsingComparator:comparator];
    if ([sortedArray count] > 0)
        return [array indexOfObject:[sortedArray lastObject]];
    return 0;
}

#pragma mark - String Operations
NSString *BNStringStringByRemovingCharactersInSet(NSString *string, NSCharacterSet *characterSet) {
    NSUInteger stringLength = string.length;

    unichar *outBuffer = calloc(stringLength + 1, sizeof(unichar));
    NSUInteger outBufferIndex = 0;

    for (NSUInteger i = 0; i < [string length]; ++i) {
        unichar c = [string characterAtIndex:i];
        if (![characterSet characterIsMember:c]) {
            outBuffer[outBufferIndex++] = c;
        }
    }

    NSMutableString *outString = [NSMutableString stringWithCharacters:outBuffer length:outBufferIndex];
    free(outBuffer), outBuffer = NULL;
    return outString;
}

BOOL BNStringIsStringByRemovingLeadingAndTrailingSpacesEmpty(NSString *string) {
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    return ([string length] == 0);
}

NSString *BNStringByRemovingSuffix(NSString *string, NSString *suffix) {
    if ([string hasSuffix:suffix])
        string = [string substringToIndex:[string length] - [suffix length]];
    return string;
}

BOOL BNStringIsValidEmail(NSString* string) {
    NSError* error = NULL;
    NSRegularExpression* regex = [NSRegularExpression
            regularExpressionWithPattern:@"^.+@.+\\..+$"
                                 options:NSRegularExpressionCaseInsensitive
                                   error:&error];
    BOOL emailValid = string && ([regex numberOfMatchesInString:string options:0 range:NSMakeRange(0, [string length])] == 1);
    return emailValid;
}

inline NSString *BNUUID(void) {
    return [[NSUUID UUID] UUIDString];
}

inline NSString * BNBoolToString(BOOL aBool){
    return (aBool ? @"true" : @"false");
}

#pragma mark Rect Operations

void BNRectDivide(CGRect rect, CGRect *slice, CGRect *remainder, CGFloat amount, CGRectEdge edge) {
    CGRect tmp;

    if (!slice)
        slice = &tmp;

    if (!remainder)
        remainder = &tmp;

    CGRectDivide(rect, slice, remainder, amount, edge);
}

CGPoint BNRectGetCenterPoint(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

CGRect BNRectScaleAspectFit(CGRect containingRect, CGRect rect) {
    CGFloat scaleX = CGRectGetWidth(containingRect) / CGRectGetWidth(rect);
    CGFloat scaleY = CGRectGetHeight(containingRect) / CGRectGetHeight(rect);
    CGFloat scale = MIN(scaleX, scaleY);

    rect.size.width *= scale;
    rect.size.height *= scale;

    return rect;
}

CGRect BNRectCenterRect(CGRect containingRect, CGRect rect) {
    return BNRectCenterRectOnAxis(containingRect, rect, BNRectAxisBoth);
}

CGRect BNRectCenterRectOnAxis(CGRect containingRect, CGRect rect, BNRectAxis axis) {
    if (axis & BNRectAxisX) {
        rect.origin.x = containingRect.origin.x;
        rect.origin.x += CGRectGetWidth(containingRect)/2. - CGRectGetWidth(rect)/2.;
    }

    if (axis & BNRectAxisY) {
        rect.origin.y = containingRect.origin.y;
        rect.origin.y += CGRectGetHeight(containingRect)/2. - CGRectGetHeight(rect)/2.;
    }

    return rect;
}


CGPathRef BNRoundedRectPathCreate(CGRect rect, CGFloat cornerRadius) {
    CGPoint min = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGPoint mid = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGPoint max = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));

    CGMutablePathRef path = CGPathCreateMutable();

    CGPathMoveToPoint(path, NULL, min.x, mid.y);
    CGPathAddArcToPoint(path, NULL, min.x, min.y, mid.x, min.y, cornerRadius);
    CGPathAddArcToPoint(path, NULL, max.x, min.y, max.x, mid.y, cornerRadius);
    CGPathAddArcToPoint(path, NULL, max.x, max.y, mid.x, max.y, cornerRadius);
    CGPathAddArcToPoint(path, NULL, min.x, max.y, min.x, mid.y, cornerRadius);

    CGPathCloseSubpath(path);

    return path;
}


#pragma mark - UIView and Derivatives
UIView *BNFindFirstSuperviewOfClass(UIView *view, Class klass) {
    if (!view)
        return nil;

    if ([view.superview isKindOfClass:klass])
        return view.superview;

    return BNFindFirstSuperviewOfClass(view.superview, klass);
}

UIView *BNFindFirstSubviewOfClass(UIView *view, Class klass) {
    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:klass])
            return subview;

        if ((subview == BNFindFirstSubviewOfClass(subview, klass)))
            return subview;
    }

    return nil;
}

UIView *BNFindFirstResponder(UIView *view) {
    if (view.isFirstResponder)
        return view;
    
    for (UIView *subview in view.subviews) {
        UIView *firstResponder = BNFindFirstResponder(subview);
        if (firstResponder)
            return firstResponder;
    }
    return nil;
}

CGFloat BNLabelWidthForHeight(UILabel *label, CGFloat height) {
    return [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(CGFLOAT_MAX, height) lineBreakMode:label.lineBreakMode].width;
}

CGPoint BNScrollViewContentOffsetToCenterRect(UIScrollView *scrollView, CGRect rect) {

    CGRectOffset(scrollView.bounds, -scrollView.contentOffset.x, -scrollView.contentOffset.y);
    CGRect scrollViewContentRect = UIEdgeInsetsInsetRect(scrollView.bounds, scrollView.contentInset);

    CGPoint centerOfRectToCenter = BNRectGetCenterPoint(rect);
    CGPoint centerOfScrollViewContentRect = BNRectGetCenterPoint(scrollViewContentRect);
    CGPoint contentOffset = CGPointZero;
    contentOffset.x = centerOfRectToCenter.x - centerOfScrollViewContentRect.x;
    contentOffset.y = centerOfRectToCenter.y - centerOfScrollViewContentRect.y;
    return contentOffset;
}

#pragma mark Location Services and Helpers
BOOL BNLocationCoordinate2DEqualToCoordinate2D(CLLocationCoordinate2D a, CLLocationCoordinate2D b) {
    if (a.longitude != b.longitude)
        return NO;
    if (a.latitude != b.latitude)
        return NO;
    return YES;
}

static const inline double deg2rad(double degrees) {
    return degrees * M_PI / 180;
}

double BNLocationCoordinate2DDistanceToCoordinate2D(CLLocationCoordinate2D a, CLLocationCoordinate2D b) {
     double earthRadius = 6372795.;

    double lat1 = deg2rad(a.latitude);
    double lon1 = deg2rad(a.longitude);
    double lat2 = deg2rad(b.latitude);
    double lon2 = deg2rad(b.longitude);

    double dLon = lon2 - lon1;
        return
          atan2(
                sqrt(
                     pow(cos(lat2) * sin(dLon), 2) +
                     pow(cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon), 2)
                ),
                sin(lat1) * sin(lat2) +
                cos(lat1) * cos(lat2) * cos(dLon)
          ) * earthRadius;
}

inline void BNOffsetView(UIView *view, CGFloat x, CGFloat y) {
    view.frame = CGRectOffset(view.frame, x, y);
}
