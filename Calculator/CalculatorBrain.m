//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Dave Hanson on 2012-10-08.
//  Copyright (c) 2012 DaveHanson. All rights reserved.
//

#import "CalculatorBrain.h"
#import "math.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray * operandStack;
@end

@implementation CalculatorBrain

@synthesize operandStack = _operandStack;

- (NSMutableArray *) operandStack
{
    if(!_operandStack) _operandStack = [[NSMutableArray alloc] init];
    
    return _operandStack;
}

- (void)pushOperand:(double)operand
{
    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double)popOperand
{
    NSNumber *operandObject = [self.operandStack lastObject];
    
    if(operandObject) [self.operandStack removeLastObject];
    
    return  [operandObject doubleValue];
}

- (double)performOperation:(NSString *)operation
{
    double result = 0;
    //calculate result
    
    if([operation isEqualToString:@"+"])
    {
        result = [self popOperand] + [self popOperand];
        
    }
    else if([operation isEqualToString:@"-"])
    {
        double subtrahend = [self popOperand];
        result = [self popOperand] - subtrahend;
        
    }
    else if([operation isEqualToString:@"*"])
    {
        result = [self popOperand] * [self popOperand];
        
    }
    else if([operation isEqualToString:@"/"])
    {
        double divisor = [self popOperand];
        if(divisor)
        {
            result = [self popOperand] / divisor;
        }
        
    }
    else if([operation isEqualToString:@"π"])
    {
        result = M_PI;
    }
    else if([operation isEqualToString:@"√"])
    {
        double operand = [self popOperand];
        result = sqrt(operand);
    }
    else if([operation isEqualToString:@"sin"])
    {
        double operand = [self popOperand];
        result = sin(operand);
    }
    else if([operation isEqualToString:@"cos"])
    {
        double operand = [self popOperand];
        result = cos(operand);
    }
    
    
    [self pushOperand:result];
    return result;
}

- (void) reset
{
    [self.operandStack removeAllObjects];
}

-(NSString *) description
{
    return [NSString stringWithFormat:@"Stack = %@", self.operandStack];
}

@end
