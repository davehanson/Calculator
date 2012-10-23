//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Dave Hanson on 2012-10-08.
//  Copyright (c) 2012 DaveHanson. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL digitIsFloatingPoint;
@property (nonatomic, strong) CalculatorBrain *brain;
-(void)cleanEqualsSignFromDisplayTape;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize displayTape = _displayTape;
@synthesize displayVariables = _displayVariables;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize digitIsFloatingPoint = _digitIsFloatingPoint;
@synthesize brain = _brain;

- (CalculatorBrain *) brain
{
    if(!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = [sender currentTitle];
    
    if([digit isEqual:@"←"])
    {
        self.display.text = [self.display.text substringToIndex:self.display.text.length-1];
        
        if(self.display.text.length == 0)
        {
            self.display.text = @"0";
            self.userIsInTheMiddleOfEnteringANumber = NO;
        }
        
    }else if(self.userIsInTheMiddleOfEnteringANumber){
        if( [digit isEqual:@"."])
        {
            if(!self.digitIsFloatingPoint)
            {
                self.display.text = [self.display.text stringByAppendingString:digit];
            }
            self.digitIsFloatingPoint = YES;
        }else{
            self.display.text = [self.display.text stringByAppendingString:digit];
        }
    }else{
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
        if( [digit isEqual:@"."])
        {
            self.digitIsFloatingPoint = YES;
        }
    }
}
- (IBAction)variablePressed:(UIButton *)sender
{
    NSString *digit = [sender currentTitle];
    
    if(self.userIsInTheMiddleOfEnteringANumber){
        [self enterPressed];
        self.display.text = digit;
        [self enterPressed];
    }else{
        self.display.text = digit;
        [self enterPressed];   
    }
}

- (IBAction)setTestVariableValuesSet:(UIButton *)sender
{
    NSRange range1 = [sender.currentTitle rangeOfString:@"1"];
    NSRange range2 = [sender.currentTitle rangeOfString:@"2"];
    NSRange range3 = [sender.currentTitle rangeOfString:@"3"];
    
    
    NSDictionary *variableDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        [NSNumber numberWithDouble:1.0], @"1",
                                        [NSNumber numberWithDouble:2.0], @"2",
                                        [NSNumber numberWithDouble:3.0], @"3", nil];
    
    if(!(range1.location == NSNotFound))
    {
        variableDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [NSNumber numberWithDouble:5.0], @"1",
                              [NSNumber numberWithDouble:2.5], @"2",
                              [NSNumber numberWithDouble:12.25], @"3", nil];
    }
    else if(!(range2.location == NSNotFound))
    {
        variableDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [NSNumber numberWithDouble:11.0], @"1",
                              [NSNumber numberWithDouble:23.25], @"2",
                              [NSNumber numberWithDouble:3.0], @"3", nil];
        
    }
    else if(!(range3.location == NSNotFound))
    {
        variableDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [NSNumber numberWithDouble:2.0], @"1",
                              [NSNumber numberWithDouble:6.0], @"2",
                              [NSNumber numberWithDouble:8.0], @"3", nil];
    }
    

    self.displayVariables.text = [variableDictionary description];
}

- (IBAction)enterPressed
{
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.digitIsFloatingPoint = NO;
    
    [self cleanEqualsSignFromDisplayTape];
    self.displayTape.text = [self.displayTape.text stringByAppendingString:self.display.text];
    self.displayTape.text = [self.displayTape.text stringByAppendingString:@" "];

}

-(void)cleanEqualsSignFromDisplayTape
{
    NSRange range = [self.displayTape.text rangeOfString:@"="];
    if(!(range.location == NSNotFound))
    {
        self.displayTape.text = [self.displayTape.text stringByReplacingCharactersInRange:range withString:@""];
        
    }
    
}

- (IBAction)operationPressed:(UIButton *)sender
{
    if(self.userIsInTheMiddleOfEnteringANumber) [self enterPressed];
    [self cleanEqualsSignFromDisplayTape];
    double result = [self.brain performOperation:sender.currentTitle];
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
    
    
    self.displayTape.text = [self.displayTape.text stringByAppendingString:sender.currentTitle];
    self.displayTape.text = [self.displayTape.text stringByAppendingString:@" = "];

}

- (IBAction)clearDisplays {
    self.displayTape.text = @"";
    self.display.text = @"0";
    [self.brain reset];
}

- (IBAction)switchSign {
    NSRange range = [self.display.text rangeOfString:@"-"];
    if(range.location == NSNotFound)
    {
        if(![self.display.text isEqualToString:@"0"])
        {
            self.display.text = [@"-" stringByAppendingString:self.display.text];
        }
    }
    else
    {
        self.display.text = [self.display.text stringByReplacingCharactersInRange:range withString:@""];
        
    }
}


@end
