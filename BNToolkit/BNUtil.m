//
//  BNUtil.m
//  bluh
//
//  Created by Scott Talbot on 24/11/11.
//  Copyright (c) 2011 Wunderman Pty Ltd. All rights reserved.
//

#import "BNUtil.h"


NSString *BNUUID(void) {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef uuidString = CFUUIDCreateString(NULL, uuid);
    NSString *aNSString = (__bridge NSString *)uuidString;
    CFRelease(uuid), uuid = NULL;
    return aNSString;
}


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

void BNRectDivide(CGRect rect, CGRect *slice, CGRect *remainder, CGFloat amount, CGRectEdge edge) {
    CGRect tmp;

    if (!slice)
        slice = &tmp;

    if (!remainder)
        remainder = &tmp;

    CGRectDivide(rect, slice, remainder, amount, edge);
}

CGPoint BNRectGetCenter(CGRect rect) {
    return CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height / 2);
}

CGRect BNRectScaleAspectFit(CGRect containingRect, CGRect rect) {
    CGFloat scaleX = CGRectGetWidth(containingRect) / CGRectGetWidth(rect);
    CGFloat scaleY = CGRectGetHeight(containingRect) / CGRectGetHeight(rect);
    CGFloat scale = MIN(scaleX, scaleY);

    rect.size.width *= scale;
    rect.size.height *= scale;

    return rect;
}

CGRect BNRectCenter(CGRect containingRect, CGRect rect) {
    return BNRectCenterOnAxis(containingRect, rect, BNRectAxisBoth);
}

CGRect BNRectCenterOnAxis(CGRect containingRect, CGRect rect, BNRectAxis axis) {
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


NSString *BNStringByRemovingSuffix(NSString *string, NSString *suffix) {
    if ([string hasSuffix:suffix])
        string = [string substringToIndex:[string length] - [suffix length]];
    return string;
}


UIImage *BNImageNamed(NSString *name) {
    static NSString *mainBundleResourcePath;
    static CGFloat scale = 1;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mainBundleResourcePath = [[NSString alloc] initWithString:[[NSBundle mainBundle] resourcePath]];

        UIScreen *mainScreen = [UIScreen mainScreen];
        if ([mainScreen respondsToSelector:@selector(scale)])
            scale = [[UIScreen mainScreen] scale];
    });

    NSString *path = [mainBundleResourcePath stringByAppendingPathComponent:name];
    NSUInteger insertionPoint = [path length];
    {
        NSArray *deviceSpecifiers = [NSArray arrayWithObjects:@"~iphone", @"~ipad", nil];
        NSRange periodRange = [path rangeOfString:@"." options:NSBackwardsSearch];
        if (periodRange.length)
            insertionPoint = periodRange.location;
        for (NSString *deviceSpecifier in deviceSpecifiers) {
            if ([path hasSuffix:deviceSpecifier]) {
                insertionPoint -= [deviceSpecifier length];
                break;
            }
        }
    }

    UIImage *image = nil;
    if (scale == 2) {
        NSString *path2x = [NSString stringWithFormat:@"%@@2x%@", [path substringToIndex:insertionPoint], [path substringFromIndex:insertionPoint]];

        if ([[NSFileManager defaultManager] fileExistsAtPath:path2x]) {
            image = [[UIImage alloc] initWithCGImage:[[UIImage imageWithData:[NSData dataWithContentsOfFile:path2x]] CGImage] scale:2 orientation:UIImageOrientationUp];
        }
    }

    if (!image)
        image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:path]];

    return image;
}

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


CGPoint BNScrollViewContentOffsetToCenterRect(UIScrollView *scrollView, CGRect rect) {
    UIEdgeInsets scrollViewContentInset = scrollView.contentInset;
    CGPoint scrollViewContentOffset = scrollView.contentOffset;
    CGRect scrollViewBounds = scrollView.bounds;
    scrollViewBounds.origin.x -= scrollViewContentOffset.x;
    scrollViewBounds.origin.y -= scrollViewContentOffset.y;
    CGRect scrollViewContentRect = UIEdgeInsetsInsetRect(scrollViewBounds, scrollViewContentInset);
    
    CGPoint centerOfRectToCenter = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGPoint centerOfScrollViewContentRect = CGPointMake(CGRectGetMidX(scrollViewContentRect), CGRectGetMidY(scrollViewContentRect));
    CGPoint contentOffset = CGPointZero;
    contentOffset.x = centerOfRectToCenter.x - centerOfScrollViewContentRect.x;
    contentOffset.y = centerOfRectToCenter.y - centerOfScrollViewContentRect.y;
//    contentOffset.x = (CGRectGetWidth(rect) - scrollViewContentSize.width) / 2;
//    contentOffset.y = (scrollViewContentSize.height - CGRectGetHeight(rect)) / 4;
    return contentOffset;
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


BOOL BNLocationCoordinate2DEqualToCooordinate2D(CLLocationCoordinate2D a, CLLocationCoordinate2D b) {
    if (a.longitude != b.longitude)
        return NO;
    if (a.latitude != b.latitude)
        return NO;
    return YES;
}

static const double deg2rad(double degrees) {
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


CGFloat BNLabelWidthForHeight(UILabel *label, CGFloat height) {
    return [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(CGFLOAT_MAX, height) lineBreakMode:label.lineBreakMode].width;
}

///// XXX copied from AFHTTPClient::AFBase64EncodedStringFromString - it's private there
NSString * AFBase64EncodedStringFromData(NSData* data) {
    NSUInteger length = [data length];
    NSMutableData *mutableData = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    
    uint8_t *input = (uint8_t *)[data bytes];
    uint8_t *output = (uint8_t *)[mutableData mutableBytes];
    
    for (NSUInteger i = 0; i < length; i += 3) {
        NSUInteger value = 0;
        for (NSUInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        static uint8_t const kAFBase64EncodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        
        NSUInteger idx = (i / 3) * 4;
        output[idx + 0] = kAFBase64EncodingTable[(value >> 18) & 0x3F];
        output[idx + 1] = kAFBase64EncodingTable[(value >> 12) & 0x3F];
        output[idx + 2] = (i + 1) < length ? kAFBase64EncodingTable[(value >> 6)  & 0x3F] : '=';
        output[idx + 3] = (i + 2) < length ? kAFBase64EncodingTable[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:mutableData encoding:NSASCIIStringEncoding];
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

int BNRandomNumberDifferentFromNumber(int maxValue, int existingValue) {
    if (maxValue < 1) {
        return maxValue;
    }
    if (maxValue == 1) {
        return (existingValue == 0) ? 1 : 0;
    }

    int nAttempt = 0;
    while (nAttempt++ < 100) {
        int n = RND_INT(maxValue + 1);
        if (n != existingValue) {
            return n;
        }
    }
    return (existingValue < maxValue) ? (existingValue + 1) : (existingValue - 1);
}

void BNOffsetView(UIView *view, CGFloat x, CGFloat y) {
    CGRect f = view.frame;
    f.origin.x += x;
    f.origin.y += y;
    view.frame = f;
}
