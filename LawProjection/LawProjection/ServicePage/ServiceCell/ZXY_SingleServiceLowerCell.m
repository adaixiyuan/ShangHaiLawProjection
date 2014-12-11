//
//  ZXY_SingleServiceLowerCell.m
//  LawProjection
//
//  Created by 周效宇 on 14-10-16.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_SingleServiceLowerCell.h"

NSString *const SingleServiceLowerCellID = @"zxysingleservicelowercellid";
@interface ZXY_SingleServiceLowerCell()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *numTitleLbl;

- (IBAction)substractionAction:(id)sender;
- (IBAction)addAction:(id)sender;
@end
@implementation ZXY_SingleServiceLowerCell

- (void)awakeFromNib {
    // Initialization code
    self.numTitleLbl.textColor = NAVIBARCOLOR;
    [self initSubView];
}

- (void)initSubView
{
    self.subtractionBtn.layer.cornerRadius  = 4;
    self.subtractionBtn.layer.masksToBounds = YES;
    self.subtractionBtn.backgroundColor = NAVIBARCOLOR;
    self.addBtn.backgroundColor         = NAVIBARCOLOR;
    self.buyBtn.backgroundColor         = NAVIBARCOLOR;
    [self forLayerCorner:self.addBtn withValue:4];
    [self forLayerCorner:self.buyBtn withValue:4];
    [self forLayerCorner:self.numLbl withValue:4];
    self.numLbl.layer.borderWidth = 1;
    self.numLbl.layer.borderColor = [UIColor blackColor].CGColor;
    self.singlePrice.textColor    = NAVIBARCOLOR;
    self.sumPrice.textColor       = NAVIBARCOLOR;
    self.numLbl.delegate = self;
    [self.numLbl addTarget:self action:@selector(changeSubPriceByInput) forControlEvents:UIControlEventEditingChanged];
    [self changeSumPrice:0];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@""])
    {
        return YES;
    }
    if(textField == self.numLbl)
    {
        if([self isUserInputANum:string])
        {
            if(self.numLbl.text.length >=2)
            {
                self.numLbl.text = @"99";
                [self changeSumPrice:self.numLbl.text.integerValue];
                return NO;
            }
            return YES;
         }
         else
         {
             return NO;
         }
    }
    else
    {
        return YES;
    }
}



- (BOOL)isUserInputANum:(NSString *)userInput
{
    BOOL isNum = YES;
    NSCharacterSet *allSet = [NSCharacterSet characterSetWithCharactersInString:ZXY_VALUES_NUMBER];
    NSInteger i = 0;
    while (i<userInput.length) {
        NSString *rangeString = [userInput substringWithRange:NSMakeRange(i,1)];
        i++;
        NSRange hasRange      = [rangeString rangeOfCharacterFromSet:allSet];
        if(hasRange.length == 0)
        {
            isNum = NO;
            break;
        }
    }
    return isNum;
}

- (void)changeSumPrice:(NSInteger)num
{
    if(num == 0)
    {
        [self.sumPrice setHidden:YES];
    }
    else
    {
        [self.sumPrice setHidden:NO];
        NSInteger singlePrice = [[self.dataDic valueForKey:@"price"] integerValue];
        self.sumPrice.text = [NSString stringWithFormat:@"总计:%ld元",num*singlePrice];
    }
}

- (void)changeSubPriceByInput
{
    if(self.numLbl.text.length == 0)
    {
        [self changeSumPrice:0];
        return;
    }
    NSInteger num = self.numLbl.text.integerValue;
    if(num == 0)
    {
        [self changeSumPrice:0];
    }
    else
    {
        [self changeSumPrice:num];
    }
}

- (void)forLayerCorner:(UIView *)sendView withValue:(NSInteger)valueCor
{
    sendView.layer.cornerRadius = valueCor;
    sendView.layer.masksToBounds= YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)buyAction:(id)sender {
    if([self.delegate respondsToSelector:@selector(buyServiceWithNum:)])
    {
        [self.delegate buyServiceWithNum:self.numLbl.text.integerValue];
    }
}
- (IBAction)substractionAction:(id)sender {
    if(self.numLbl.text.length == 0)
    {
        return;
    }
    NSInteger num = self.numLbl.text.integerValue;
    if(num == 0)
    {
        return;
    }
    else
    {
        self.numLbl.text = [NSString stringWithFormat:@"%ld",num-1];
        [self changeSumPrice:self.numLbl.text.integerValue];
    }
}

- (IBAction)addAction:(id)sender {
    NSInteger num = self.numLbl.text.integerValue;
    if(num >= 99)
    {
        return;
    }
    else
    {
        self.numLbl.text = [NSString stringWithFormat:@"%ld",num+1];
        [self changeSumPrice:self.numLbl.text.integerValue];
    }
}
@end
