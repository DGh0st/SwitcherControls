#include "NSArray+CompareAddition.h"

@implementation NSArray (CompareAddition)
-(BOOL)isOrderEqual:(NSArray *)other {
	if (other == nil || [self count] != [other count])
		return NO;

	for (NSInteger i = 0; i < [self count]; i++) {
		NSString *one = (NSString *)[self objectAtIndex:i];
		NSString *two = (NSString *)[other objectAtIndex:i];
		if (one == nil && two == nil)
			break;
		if (![one isEqualToString:two])
			return NO;
	}

	return YES;
}
@end