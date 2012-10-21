//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Dave Hanson on 2012-10-08.
//  Copyright (c) 2012 DaveHanson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (double)performOperation:(NSString *)operation;
- (void) reset;

//Assignment2 Lecture4
@property (readonly) id program;
+ (double)runProgram:(id)program;
+ (NSString *)descriptionOfProgram:(id)program;

//Assignment2
+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;
+ (NSSet *)variablesUsedInProgram:(id)program;

@end
