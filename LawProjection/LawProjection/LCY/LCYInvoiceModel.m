//
//  LCYInvoiceModel.m
//  LawProjection
//
//  Created by eagle on 14/11/4.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "LCYInvoiceModel.h"

NSString *const customerTypeEnterprise = @"CT0001";
NSString *const customerTypePersonal = @"CT0002";


@implementation LCYInvoiceModel

- (instancetype)init {
    if (self = [super init]) {
        self.saveAsTemplate = NO;
        self.customerType = customerTypeEnterprise;
    }
    return self;
}

@end

@implementation LCYInvoiceInvoiceType


@end

@implementation LCYInvoiceLocation


@end