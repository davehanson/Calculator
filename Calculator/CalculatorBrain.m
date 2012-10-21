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
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

- (NSMutableArray *) programStack
{
    if(!_programStack) _programStack = [[NSMutableArray alloc] init];
    
    return _programStack;
}

- (void)pushOperand:(double)operand
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}


- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program];
}


- (id) program
{
    return [self.programStack copy];
}

+ (NSString *)descriptionOfProgram:(id)program
{
    return @"Implement in this assignment (2)";
}

+ (double) popOperandOffStack:(NSMutableArray *)stack
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if(topOfStack) [stack removeLastObject];
    
    if([topOfStack isKindOfClass:[NSNumber class]]){
        result = [topOfStack doubleValue];
    }
    else if([topOfStack isKindOfClass:[NSString class]]){
        NSString *operation = topOfStack;
        
        if([operation isEqualToString:@"+"]){
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        }else if([operation isEqualToString:@"-"]){
            double subtrahend = [self popOperandOffStack:stack];
            result = [self popOperandOffStack:stack] - subtrahend;
        }else if([operation isEqualToString:@"*"]){
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        }else if([operation isEqualToString:@"/"]){
            double divisor = [self popOperandOffStack:stack];
            if(divisor){
                result = [self popOperandOffStack:stack] / divisor;
            }
        }else if([operation isEqualToString:@"π"]){
            result = M_PI;
        }else if([operation isEqualToString:@"√"]){
            double operand = [self popOperandOffStack:stack];
            result = sqrt(operand);
        }else if([operation isEqualToString:@"sin"]){
            double operand = [self popOperandOffStack:stack];
            result = sin(operand);
        }else if([operation isEqualToString:@"cos"]){
            double operand = [self popOperandOffStack:stack];
            result = cos(operand);
        }
        
    }
    
    return result;
}

+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    if( [program isKindOfClass:[NSArray class]]){
        stack = [program mutableCopy];
    }
    return [self popOperandOffStack:stack];
}

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues
{
    return 0;
}

+ (NSSet *)variablesUsedInProgram:(id)program
{
    return [[NSSet alloc] init];
}


- (void) reset
{
    [self.programStack removeAllObjects];
}

-(NSString *) description
{
    return [NSString stringWithFormat:@"Program Stack = %@", self.programStack];
}

@end
