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


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
