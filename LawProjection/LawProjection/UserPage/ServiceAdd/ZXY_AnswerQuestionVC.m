//
//  ZXY_AnswerQuestionVC.m
//  LawProjection
//
//  Created by 宇周 on 14/11/2.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_AnswerQuestionVC.h"
#import "ZXY_LawCircleView.h"
#import <SSCheckBoxView/SSCheckBoxView.h>
#import "ZXY_ContractReviewVCViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
typedef enum
{
    TextType    = 1,
    ComboType   = 2,
    MultiType   = 3,
    DateType    = 4,
}QuestionType;
@interface ZXY_AnswerQuestionVC ()<UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate,UITextViewDelegate>
{
    NSDictionary *questionInfo;
    __weak IBOutlet UIScrollView *questionScroll;
    NSArray      *questionArr;
    __weak IBOutlet UIView *headerView;
    
    __weak IBOutlet UIButton *nextBtn;
    __weak IBOutlet UIButton *beforeBtn;
    NSInteger     currentQuestionNum;
    NSDictionary *currentQuestion;
    UIView *currentView;
    NSMutableDictionary *answerDic;
    UITextView *textViewForType;
    UILabel    *labelForType;
    IBOutlet UIView *datePickerView;
    __weak IBOutlet UIDatePicker *datePickerC;
    IBOutlet UIView *pickerViewT;
    __weak IBOutlet UIPickerView *pickerViewC;
    IBOutlet UIView *checkBoxView;
    __weak IBOutlet UIImageView  *chooseImage;
    __weak IBOutlet UILabel *chooseLbl;
    NSMutableArray *selectArrCom;
    NSMutableArray *checkBoxes;
    NSString *_contractID;
    NSDictionary *forNextInfo;
    BOOL isFinish;
}
@end

@implementation ZXY_AnswerQuestionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavi];
    [self initViews];
    [self initScrollView];
    [self drawCircle];
    [self initData];
    // Do any additional setup after loading the view.
}

- (void)initData
{
    if(answerDic == nil)
    {
        answerDic = [[NSMutableDictionary alloc] init];
    }
    
    if(selectArrCom == nil)
    {
        selectArrCom = [[NSMutableArray alloc] init];
    }
    
    if(checkBoxes == nil)
    {
        checkBoxes   = [[NSMutableArray alloc] init];
    }
    currentQuestionNum = 0;
}

- (void)initViews
{
    [beforeBtn setEnabled:NO];
    if(questionArr.count == 1)
    {
        [nextBtn setTitle:@"预览" forState:UIControlStateNormal];
    }
}

- (void)initNavi
{
    [self setNaviBarImage:@"home_navi"];
    [self setLeftNaviItem:@"back_arrow"];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    [self setNaviTitle:@"合同起草" withPositon:1 ];
}

- (void)initScrollView
{
    currentQuestion = [questionArr objectAtIndex:currentQuestionNum];
    NSString     *answerType  = [currentQuestion objectForKey:@"type"];
    QuestionType iniType      = [self typeWithString:answerType];
    UIView *subView           = [self viewFromType:iniType andQuestion:currentQuestion];
    [questionScroll addSubview:subView];
}

- (void)setQuestionInfo:(NSDictionary *)allQuestion andAnswer:(NSDictionary *)allAnswerD
{
    isFinish = YES;
    questionInfo = allQuestion;
    NSDictionary *dataDic = [questionInfo objectForKey:@"data"];
    NSArray *answerARR = [allAnswerD objectForKey:@"answer"];
    answerARR          = [answerARR sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDictionary *dic = obj1;
        NSDictionary *dic2 = obj2;
        NSNumber     *oneNum = [dic objectForKey:@"number"];
        NSNumber     *twoNum = [dic2 objectForKey:@"number"];
        if(oneNum.integerValue>twoNum.integerValue)
        {
            return 1;
        }
        else
        {
            return -1;
        }

    }];
    questionArr           = [dataDic objectForKey:@"questions"];
    if(questionArr == nil)
    {
        NSArray *itemsArr = [dataDic objectForKey:@"items"];
        NSDictionary *itemsDic         = [itemsArr objectAtIndex:0];
        questionArr       =  [itemsDic objectForKey:@"questions"];
    }
    questionArr = [questionArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDictionary *dic = obj1;
        NSDictionary *dic2 = obj2;
        NSNumber     *oneNum = [dic objectForKey:@"number"];
        NSNumber     *twoNum = [dic2 objectForKey:@"number"];
        if(oneNum.integerValue>twoNum.integerValue)
        {
            return 1;
        }
        else
        {
            return -1;
        }
    }];
    
    for(NSDictionary *oneQuestion in questionArr)
    {
        NSString *typeString = [oneQuestion objectForKey:@"type"];
        NSInteger indexs = [questionArr indexOfObject:oneQuestion];
        NSDictionary *oneAnswer = [answerARR objectAtIndex:indexs];
        NSNumber *num = oneQuestion[@"number"];
        
        if(answerDic == nil)
        {
            answerDic = [[NSMutableDictionary alloc] init];
        }
        if([typeString isEqualToString:@"text"])
        {
            NSString *valueString = [oneAnswer objectForKey:@"value"];
            [answerDic setObject:valueString forKey:num];
        }
        else if ([typeString isEqualToString:@"date"])
        {
            NSString *valueString = [oneAnswer objectForKey:@"value"];
            [answerDic setObject:valueString forKey:num];
        }
        else if ([typeString isEqualToString:@"multi"])
        {
            NSArray *valueArr  = [oneAnswer objectForKey:@"value"];
            NSMutableArray *suchMoreArr = [[NSMutableArray alloc] init];
            for(int i = 0;i<valueArr.count;i++)
            {
                NSString *oneArrValue = [valueArr objectAtIndex:i];
                NSArray  *optionsArr  = [oneQuestion objectForKey:@"options"];
                
                for(int j = 0;j<optionsArr.count;j++)
                {
                    NSArray *lastArr = [optionsArr objectAtIndex:j];
                    if([[lastArr objectAtIndex:1] isEqualToString:oneArrValue])
                    {
                        [suchMoreArr addObject:lastArr];
                    }
                }
            }
            [answerDic setObject:suchMoreArr forKey:num];
        }
        else
        {
            NSString *valueString = [oneAnswer objectForKey:@"value"];
            NSArray  *optionsArr  = [oneQuestion objectForKey:@"options"];
           // NSMutableArray *suchMoreArr = [[NSMutableArray alloc] init];
            for(int j = 0;j<optionsArr.count;j++)
            {
                NSArray *lastArr = [optionsArr objectAtIndex:j];
                if([[lastArr objectAtIndex:0] isEqualToString:valueString])
                {
                    [answerDic setObject:lastArr forKey:num];
                    break;
                }
            }
            
        }
    }

}

- (QuestionType)typeWithString:(NSString *)stringType
{
    if([stringType isEqualToString:@"text"])
    {
        return TextType;
    }
    else if ([stringType isEqualToString:@"combo"])
    {
        return ComboType;
    }
    else if ([stringType isEqualToString:@"multi"])
    {
        return MultiType;
    }
    else
    {
        return DateType;
    }
}

- (void)showHelp
{
    NSString *helpInfo = [currentQuestion objectForKeyedSubscript:@"help"];
    [self showAlertWarnningView:@"" andContent:helpInfo];
}

- (UIView *)viewFromType:(QuestionType)currentType andQuestion:(NSDictionary *)question
{
    UIView *returnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, questionScroll.frame.size.height)];
    UIImageView *aaaImage = [[UIImageView alloc] initWithFrame:CGRectMake(260, 5, 25, 25)];
    aaaImage.image        = [UIImage imageNamed:@"aaaaaa"];
    aaaImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHelp)];
    [aaaImage addGestureRecognizer:tap];
    
    UITextView *titleTextView  = [[UITextView alloc] initWithFrame:CGRectMake(15, 0, 240, 46)];
    NSInteger row = [questionArr indexOfObject:question]+1;
    titleTextView.text = [NSString stringWithFormat:@"问题%d：%@",row,[question objectForKey:@"body"]];
    titleTextView.editable = NO;
    [returnView addSubview:titleTextView];
   // NSString *bodyString = [question objectForKey:@"body"];
    NSString *helpString = [question objectForKey:@"help"];
    if(helpString==nil||[helpString isEqualToString:@""])
    {
    
    }
    else
    {
        [returnView addSubview:aaaImage];
    }
    if(currentType == TextType)
    {
        UITextView *answerView = [[UITextView alloc]initWithFrame:CGRectMake(40, 54, 240, 80)];
        answerView.layer.cornerRadius = 4;
        answerView.layer.borderColor  = [UIColor grayColor].CGColor;
        answerView.layer.borderWidth  = 1;
        answerView.layer.masksToBounds = YES;
        answerView.center      = CGPointMake(questionScroll.center.x, answerView.center.y);
        //[answerView addTarget:self action:@selector(hideKey) forControlEvents:UIControlEventEditingDidEndOnExit];
        UIToolbar *topBar = [self toolBarWithRight:@"完成" andLeft:nil withRightBtnSel:@selector(hideKey) andLeftBtnSel:nil];
        [answerView setInputAccessoryView:topBar];
        //answerView.returnKeyType = UIReturnKeyDone;
        textViewForType = answerView;
        textViewForType.delegate = self;
        if([answerDic.allKeys containsObject:[question objectForKey:@"number"]])
        {
           NSString *currentText = [answerDic objectForKey:[question objectForKey:@"number"]];
           answerView.text    = currentText;
        }
        else
        {
            answerView.text = @"";
        }
        if(isFinish)
        {
            answerView.userInteractionEnabled =NO;
        }
        [returnView addSubview:answerView];
    }
    else if (currentType == ComboType)
    {
        UILabel *currentLbl = [[UILabel alloc] initWithFrame:CGRectMake(40, 54, 260, 40)];
        currentLbl.layer.cornerRadius = 4;
        currentLbl.layer.borderColor  = [UIColor grayColor].CGColor;
        currentLbl.layer.borderWidth  = 1;
        currentLbl.layer.masksToBounds = YES;
        labelForType = currentLbl;
        currentLbl.center = CGPointMake(questionScroll.center.x, currentLbl.center.y);
         currentLbl.textAlignment  = NSTextAlignmentCenter;
        currentLbl.font = [UIFont systemFontOfSize:15];
        if([answerDic.allKeys containsObject:[question objectForKey:@"number"]])
        {
            NSArray *answerArr = [answerDic objectForKey:[question objectForKey:@"number"]];
            currentLbl.text    = [answerArr objectAtIndex:0];
        }
        else
        {
            currentLbl.text = @"点击选择";
        }
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPickerView)];
        currentLbl.userInteractionEnabled = YES;
        [currentLbl addGestureRecognizer:tapGes];
        UIImageView *downImage = [[UIImageView alloc] initWithFrame:CGRectMake(40, 54, 11, 7)];
        [downImage setImage:[UIImage imageNamed:@"upDown_arrow"]];
        [downImage setContentMode:UIViewContentModeScaleAspectFit];
        downImage.center = CGPointMake(downImage.center.x, currentLbl.center.y);
        if(isFinish)
        {
            currentLbl.userInteractionEnabled =NO;
        }
        [returnView addSubview:currentLbl];
        [returnView addSubview:downImage];
        
    }
    else if (currentType == DateType)
    {
        UILabel *currentLbl = [[UILabel alloc] initWithFrame:CGRectMake(40, 54, 260, 40)];
        currentLbl.layer.cornerRadius = 4;
        currentLbl.layer.borderColor  = [UIColor grayColor].CGColor;
        currentLbl.layer.borderWidth  = 1;
        currentLbl.layer.masksToBounds = YES;
        currentLbl.font = [UIFont systemFontOfSize:15];
        currentLbl.center = CGPointMake(questionScroll.center.x, currentLbl.center.y);
        labelForType = currentLbl;
        currentLbl.font     = [UIFont systemFontOfSize:15];
        currentLbl.textAlignment  = NSTextAlignmentCenter;
        if([answerDic.allKeys containsObject:[question objectForKey:@"number"]])
        {
            NSString *answerArr = [answerDic objectForKey:[question objectForKey:@"number"]];
            currentLbl.text    = answerArr;
        }
        else
        {
            currentLbl.text = @"点击选择";
        }
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPickDateV)];
        currentLbl.userInteractionEnabled = YES;
        [currentLbl addGestureRecognizer:tapGes];
        UIImageView *downImage = [[UIImageView alloc] initWithFrame:CGRectMake(40, 54, 11, 7)];
        [downImage setImage:[UIImage imageNamed:@"upDown_arrow"]];
        [downImage setContentMode:UIViewContentModeScaleAspectFit];
        downImage.center = CGPointMake(downImage.center.x, currentLbl.center.y);
        if(isFinish)
        {
            currentLbl.userInteractionEnabled =NO;
        }

        [returnView addSubview:currentLbl];
        [returnView addSubview:downImage];
    }
    else
    {
        NSArray *allAnswer = [question objectForKey:@"options"];
        [checkBoxes removeAllObjects];
        [selectArrCom removeAllObjects];
        NSNumber *num = [question objectForKey:@"number"];
        for(int i= 0 ;i<allAnswer.count;i++)
        {
            NSMutableArray *arr = [answerDic objectForKey:num];
            
            CGRect frame = CGRectMake(15, 45+i*30, questionScroll.frame.size.width, 30);
            SSCheckBoxView *checkView ;
            if([arr containsObject:[allAnswer objectAtIndex:i]])
            {
                [selectArrCom addObject:[allAnswer objectAtIndex:i]];
                checkView = [[SSCheckBoxView alloc] initWithFrame:frame style:kSSCheckBoxViewStyleBox checked:YES];
            }
            else
            {
                checkView = [[SSCheckBoxView alloc] initWithFrame:frame style:kSSCheckBoxViewStyleBox checked:NO];

            }
            [checkView setText:[[allAnswer objectAtIndex:i] objectAtIndex:0]];
            [checkBoxes addObject:checkView];
            [checkView setStateChangedTarget:self selector:@selector(stateChangeNow:)];
            if(isFinish)
            {
                checkView.userInteractionEnabled =NO;
            }

            [returnView addSubview:checkView];
        }
    }
    return returnView;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-80, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+80, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

- (void)hideKey
{
    [textViewForType resignFirstResponder];
}

- (void)stateChangeNow:(SSCheckBoxView *)sch
{
    NSInteger index        = [checkBoxes indexOfObject:sch];
    NSArray *allAnswer     = [currentQuestion objectForKey:@"options"];
    NSArray *selectAnswer  = [allAnswer objectAtIndex:index];
    if([selectArrCom containsObject:selectAnswer])
    {
        [selectArrCom removeObject:selectAnswer];
    }
    else
    {
        [selectArrCom addObject:selectAnswer];
    }
    NSArray *resultArr = [NSArray arrayWithArray:selectArrCom];
    NSNumber *num = [currentQuestion objectForKey:@"number"];
    [answerDic setObject:resultArr forKey:num];
}

- (void)drawCircle
{
    ZXY_LawCircleView *lawCircle = [[ZXY_LawCircleView alloc] initWithPositionY:10];
    [lawCircle setNumOfCircle:2];
    if(isFinish)
    {
        [lawCircle setSelectIndex:1];
        [lawCircle setSelectBackColor:[UIColor colorWithRed:59.0/255.0 green:148.0/255.0 blue:223.0/255.0 alpha:1]];
    }
    else
    {
        [lawCircle setSelectIndex:0];
        [lawCircle setSelectBackColor:[UIColor colorWithRed:23.0/255.0 green:192.0/255.0 blue:255.0/255.0 alpha:1]];

    }
    [lawCircle setCircleInfo:[NSArray arrayWithObjects:@"起草",@"完成", nil]];
    //[lawCircle setSelectIndex:0];
    [headerView addSubview:lawCircle];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setQuestionInfo:(NSDictionary *)allQuestion andAnswerD:(NSDictionary *)answerD andID:(NSString *)contractID;
{
    @try {
        questionInfo = allQuestion;
        _contractID   = contractID;
        NSDictionary *dataDic = [questionInfo objectForKey:@"data"];
        questionArr           = [dataDic objectForKey:@"questions"];
        if(questionArr == nil)
        {
            NSArray *itemsArr = [dataDic objectForKey:@"items"];
            NSDictionary *itemsDic         = [itemsArr objectAtIndex:0];
            questionArr       =  [itemsDic objectForKey:@"questions"];
        }
        questionArr = [questionArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSDictionary *dic = obj1;
            NSDictionary *dic2 = obj2;
            NSNumber     *oneNum = [dic objectForKey:@"number"];
            NSNumber     *twoNum = [dic2 objectForKey:@"number"];
            if(oneNum.integerValue>twoNum.integerValue)
            {
                return 1;
            }
            else
            {
                return -1;
            }
        }];
        
        if([answerD.allKeys containsObject:@"answer"])
        {
            NSArray *answerARR = [answerD objectForKey:@"answer"];
            answerARR          = [answerARR sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                NSDictionary *dic = obj1;
                NSDictionary *dic2 = obj2;
                NSNumber     *oneNum = [dic objectForKey:@"number"];
                NSNumber     *twoNum = [dic2 objectForKey:@"number"];
                if(oneNum.integerValue>twoNum.integerValue)
                {
                    return 1;
                }
                else
                {
                    return -1;
                }
                
            }];
            
            for(NSDictionary *oneQuestion in questionArr)
            {
                NSString *typeString = [oneQuestion objectForKey:@"type"];
                NSInteger indexs = [questionArr indexOfObject:oneQuestion];
                NSDictionary *oneAnswer = [answerARR objectAtIndex:indexs];
                NSNumber *num = oneQuestion[@"number"];
                
                if(answerDic == nil)
                {
                    answerDic = [[NSMutableDictionary alloc] init];
                }
                if([typeString isEqualToString:@"text"])
                {
                    NSString *valueString = [oneAnswer objectForKey:@"value"];
                    [answerDic setObject:valueString forKey:num];
                }
                else if ([typeString isEqualToString:@"date"])
                {
                    NSString *valueString = [oneAnswer objectForKey:@"value"];
                    [answerDic setObject:valueString forKey:num];
                }
                else if ([typeString isEqualToString:@"multi"])
                {
                    NSArray *valueArr  = [[NSArray alloc] init];
                    if([[oneAnswer objectForKey:@"value"] isKindOfClass:[NSArray class]])
                    {
                        valueArr  = [oneAnswer objectForKey:@"value"];
                    }
                    NSMutableArray *suchMoreArr = [[NSMutableArray alloc] init];
                    for(int i = 0;i<valueArr.count;i++)
                    {
                        NSString *oneArrValue = [valueArr objectAtIndex:i];
                        NSArray  *optionsArr  = [oneQuestion objectForKey:@"options"];
                        
                        for(int j = 0;j<optionsArr.count;j++)
                        {
                            NSArray *lastArr = [optionsArr objectAtIndex:j];
                            if([[lastArr objectAtIndex:1] isEqualToString:oneArrValue])
                            {
                                [suchMoreArr addObject:lastArr];
                            }
                        }
                    }
                    [answerDic setObject:suchMoreArr forKey:num];
                }
                else
                {
                    NSString *valueString = [oneAnswer objectForKey:@"value"];
                    NSArray  *optionsArr  = [oneQuestion objectForKey:@"options"];
                    // NSMutableArray *suchMoreArr = [[NSMutableArray alloc] init];
                    for(int j = 0;j<optionsArr.count;j++)
                    {
                        NSArray *lastArr = [optionsArr objectAtIndex:j];
                        if([[lastArr objectAtIndex:0] isEqualToString:valueString])
                        {
                            [answerDic setObject:lastArr forKey:num];
                            break;
                        }
                    }
                    
                }
            }
            
        }

    }
    @catch (NSException *exception) {
        [self showAlertWarnningView:@"提示" andContent:@"出现错误，请联系客服人员"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    @finally {
        ;
    }
    

    
}

- (IBAction)beforeBtnAction:(id)sender
{
    if([[currentQuestion objectForKey:@"type"] isEqualToString:@"text"])
    {
        if(textViewForType.text)
        {
            [answerDic setObject:textViewForType.text forKey:[currentQuestion objectForKey:@"number"]];
        }
        else
        {
            [answerDic setObject:@"" forKey:[currentQuestion objectForKey:@"number"]];
        }
    }
    currentQuestionNum --;
    if(currentQuestionNum == 0)
    {
        [beforeBtn setEnabled:NO];
    }
    if(currentQuestionNum < questionArr.count-1)
    {
        [nextBtn setTitle:@"下一题" forState:UIControlStateNormal];
        [nextBtn setTitle:@"下一题" forState:UIControlStateHighlighted];
        [nextBtn setEnabled:YES];
    }
    [self changePage];
    [self initScrollView];

}
- (IBAction)chooseDateAction:(id)sender
{
    UIDatePicker *datePicker = (UIDatePicker *)sender;
    NSDate *selectDate = datePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    labelForType.text  =  [formatter stringFromDate:selectDate];
    NSNumber *currentNum  = [currentQuestion objectForKey:@"number"];
    [answerDic setObject:[formatter stringFromDate:selectDate] forKey:currentNum];
}

- (void)changePage
{
    for(UIView *subView in questionScroll.subviews)
    {
        [subView removeFromSuperview];
    }
}

- (void)showPickDateV
{
    CGSize pickerProfessionS = datePickerView.frame.size;
    datePickerC.date = [NSDate date];
    NSDate *selectDate = datePickerC.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    labelForType.text  =  [formatter stringFromDate:selectDate];
    NSNumber *currentNum  = [currentQuestion objectForKey:@"number"];
    [answerDic setObject:[formatter stringFromDate:selectDate] forKey:currentNum];

    if(![self.view.subviews containsObject:datePickerView])
    {
        datePickerView.frame = CGRectMake(0, self.view.frame.size.height, pickerProfessionS.width, pickerProfessionS.height);
        [self.view addSubview:datePickerView];
    }
    else
    {
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        datePickerView.frame = CGRectMake(0, self.view.frame.size.height-pickerProfessionS.height, pickerProfessionS.width, pickerProfessionS.height);
    }];

}

- (IBAction)hideDatePickerV:(id)sender
{
    CGSize pickerProfessionS = datePickerView.frame.size;
    [UIView animateWithDuration:0.3 animations:^{
        datePickerView.frame = CGRectMake(0, self.view.frame.size.height, pickerProfessionS.width, pickerProfessionS.height);
    }completion:^(BOOL finished) {
        [datePickerView removeFromSuperview];
    }];}

- (IBAction)nextBtnAction:(id)sender
{
    currentQuestionNum ++;
    if(currentQuestionNum == questionArr.count-1)
    {
        //[nextBtn setEnabled:NO];
        if(isFinish)
        {
            [nextBtn setTitle:@"下一题" forState:UIControlStateNormal];
            [nextBtn setTitle:@"下一题" forState:UIControlStateHighlighted];
            [nextBtn setEnabled:NO];
        }
        else
        {
            [nextBtn setTitle:@"预览" forState:UIControlStateNormal];
            [nextBtn setTitle:@"预览" forState:UIControlStateHighlighted];
        }
        
    }
    if(currentQuestionNum == questionArr.count )
    {
        if(isFinish)
        {
        
        }
        else
        {
            [self startSubmitAnswer];
            currentQuestionNum--;
            return;
        }
    }

    if([[currentQuestion objectForKey:@"type"] isEqualToString:@"text"])
    {
        if(textViewForType.text)
        {
            [answerDic setObject:textViewForType.text forKey:[currentQuestion objectForKey:@"number"]];
        }
        else
        {
            [answerDic setObject:@"" forKey:[currentQuestion objectForKey:@"number"]];
        }
    }
    if(currentQuestionNum == 1)
    {
        [beforeBtn setEnabled:YES];
    }
    [self changePage];
    [self initScrollView];
    
    
}

- (void)freshNextBtn
{
    
}


- (void)showPickerView
{
    [pickerViewC reloadAllComponents];
    
    CGSize pickerProfessionS = pickerViewT.frame.size;
    if(![self.view.subviews containsObject:pickerViewT])
    {
        pickerViewT.frame = CGRectMake(0, self.view.frame.size.height, pickerProfessionS.width, pickerProfessionS.height);
        [self.view addSubview:pickerViewT];
    }
    else
    {
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        pickerViewT.frame = CGRectMake(0, self.view.frame.size.height-pickerProfessionS.height, pickerProfessionS.width, pickerProfessionS.height);
    }];

}

- (IBAction)hidePickerView:(id)sender
{
    CGSize pickerProfessionS = pickerViewT.frame.size;
    [UIView animateWithDuration:0.3 animations:^{
        pickerViewT.frame = CGRectMake(0, self.view.frame.size.height, pickerProfessionS.width, pickerProfessionS.height);
    }completion:^(BOOL finished) {
        [pickerViewT removeFromSuperview];
    }];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *allAnswer = [currentQuestion objectForKey:@"options"];
    return allAnswer.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray *allAnswer = [currentQuestion objectForKey:@"options"];
    NSArray *title     = [allAnswer objectAtIndex:row];
    return [title objectAtIndex:0];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSArray *allAnswer    = [currentQuestion objectForKey:@"options"];
    NSNumber *currentNum  = [currentQuestion objectForKey:@"number"];
    NSArray *currentAnswer= [allAnswer objectAtIndex:row];
    labelForType.text     = [currentAnswer objectAtIndex:0];
    [answerDic setObject:currentAnswer forKey:currentNum];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(textViewForType)
    {
        [textViewForType resignFirstResponder];
    }
}

- (void)startSubmitAnswer
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定保存并生成合同吗？" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",@"取消", nil];
    [alert show];
}

- (NSDictionary *)toSubmitAnswerParameter
{
    NSMutableArray *answerArrForSubmit = [[NSMutableArray alloc] init];
    for(int i = 0;i<questionArr.count;i++)
    {
        NSDictionary *currentNow      = [questionArr objectAtIndex:i];
        NSNumber     *questionIndex   = [currentNow objectForKey:@"number"];
        NSString     *typeString      = [currentNow objectForKey:@"type"];
        NSString     *stringValue     = @"";
        NSMutableArray *multiForSend      = nil;
        if([answerDic.allKeys containsObject:questionIndex])
        {
            if([typeString isEqualToString:@"text"])
            {
                stringValue = [answerDic objectForKey:questionIndex];
            }
            else if ([typeString isEqualToString:@"combo"])
            {
                stringValue = [[answerDic objectForKey:questionIndex] objectAtIndex:0];
            }
            else if ([typeString isEqualToString:@"date"])
            {
                stringValue = [answerDic objectForKey:questionIndex];
            }
            else
            {
                multiForSend = [[NSMutableArray alloc] init];
                NSArray  *multiArr = [answerDic objectForKey:questionIndex];
                if(multiArr.count>0)
                {
                    for(int i = 0;i<multiArr.count;i++)
                    {
                        NSArray  *multiAnswer = [multiArr objectAtIndex:i];
                        NSString *keyString   = [multiAnswer objectAtIndex:1];
                        //NSString *valueString = [multiAnswer objectAtIndex:0];
                        [multiForSend addObject:keyString];
                    }
                }
                
            }
        }
        else
        {
            if([typeString isEqualToString:@"multi"])
            {
               multiForSend = [[NSMutableArray alloc] init];
            }
        }
        NSDictionary *paramenters ;
        if([typeString isEqualToString:@"multi"])
        {
            paramenters = @{
                           @"number":questionIndex.stringValue,
                           @"value" :multiForSend,
                           @"type"  :typeString
                           };
        }
        else
        {
            paramenters = @{
                            @"number":questionIndex.stringValue,
                            @"value" :stringValue,
                            @"type"  :typeString
                            };
        }
        [answerArrForSubmit addObject:paramenters];
    }
    NSString *questionID    = _contractID;//[[questionInfo objectForKey:@"data"] objectForKey:@"_id"];
    if(questionID == nil)
    {
        questionID = _contractID ;//questionInfo[@"data"][@"items"][0][@"_id"];
    }
    NSDictionary *idDic     = @{
                                @"id":questionID
                                };
    
    NSDictionary *dataDic   = @{
                                @"answer":answerArrForSubmit,
                                
                               }
    ;
    NSDictionary *returnDic = @{
                                @"data":dataDic,
                                @"filter":idDic
                                };
    return returnDic;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString *urlString     = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_CONTRACTUPDATE_URL];
        NSDictionary *parameter = [self toSubmitAnswerParameter];
        [self startLoadDataPutCSRF:urlString withParameter:parameter successBlock:^(NSData *responseData) {
            ;
            
            NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
            if([infoDic.allKeys containsObject:@"error"])
            {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                NSDictionary *errorDic = [infoDic objectForKey:@"error"];
                NSString *message      = [errorDic objectForKey:@"message"];
                [self showAlertWarnningView:@"" andContent:message];
            }
            else
            {
                [self startPreView];
            }
        } errorBlock:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }
    
    else
    {
        
    }
}

- (void)startPreView
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_CONTRACTPREVIEW_URL];
    NSDictionary *parameter = @{
                                @"id":_contractID
                                };
    [self startLoadDataGETCSRF:urlString withPatameter:parameter successBlock:^(NSData *responseData) {
        NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
        if([infoDic.allKeys containsObject:@"error"])
        {
            NSDictionary *errorDic = [infoDic objectForKey:@"error"];
            NSString *message      = [errorDic objectForKey:@"message"];
            [self showAlertWarnningView:@"" andContent:message];
        }
        else
        {
            forNextInfo            = [infoDic objectForKey:@"data"];
            [self performSegueWithIdentifier:@"toReview" sender:self];
        }

    } errorBlock:^(NSError *error) {
        
    }];
}
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   if([segue.identifier isEqualToString:@"toReview"])
   {
       ZXY_ContractReviewVCViewController *fileView = [segue destinationViewController];
       [fileView setCurrentViewInfo:forNextInfo andContractID:_contractID];
       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
   }
}


@end
