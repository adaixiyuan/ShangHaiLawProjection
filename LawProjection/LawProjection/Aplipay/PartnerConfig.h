//
//  PartnerConfig.h
//  AlipaySdkDemo
//
//  Created by ChaoGanYing on 13-5-3.
//  Copyright (c) 2013年 RenFei. All rights reserved.
//
//  提示：如何获取安全校验码和合作身份者id
//  1.用您的签约支付宝账号登录支付宝网站(www.alipay.com)
//  2.点击“商家服务”(https://b.alipay.com/order/myorder.htm)
//  3.点击“查询合作者身份(pid)”、“查询安全校验码(key)”
//

#ifndef MQPDemo_PartnerConfig_h
#define MQPDemo_PartnerConfig_h

//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088511781582767"
//收款支付宝账号
#define SellerID  @"fangming.gu@ilaw66.com"

//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define MD5_KEY @"jlep62qq3chs1lcxup0xk3vbq1qjqq0l"

//商户私钥，自助生成
#define PartnerPrivKey @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAMTQqcg9sTZ2Kc+LWFI2438UnUY4DW33XOINxEUqV2vja/C0+BMz54pUwjiQaIulPuoiZ+Zuk+CTGOHfrulq7dcEuYY0+708HziHOsVDlsZb/gyrZZ92Zgg7ogVLxGzujsZX11NHxlsiDUI8TYv757e6RinzbSxNJiIEm66EjWGpAgMBAAECgYBiZy2sR2QWJchL05DKMlVWUXk9BYN5ascO4vEx37Sr5Z4vUFwERdxLZotg+pq6z1kAeUlXhgv7qbA0JsFuRR86k50zupcI0UbyrElnEdKKpAWExRwTzhlypFksxPczs377/o1v4GLH8nOHWo3sGiZfcxQp6QQpWwwNEmaHgSfWsQJBAPkh2c1S4C8QPV9IT6IHTzoSOYsCMLOyKvp+zCeXEfS9yj8e4vBbrJIR0Sr2mz4PpxHlQaOafUD9LyLYqf4ZjoUCQQDKPZsD8I7L0vDJZZHRVJ2/GLvk80YOB/JttfANUzvwLYnWwQ+NA8kXuYzxZCOIGLH2vEsMPAMgZksfjExJpKnVAkEA2npOKBrS0VMbjzC57S0d1J5g6kAMd7n6qNyDqwB31bqO35X1jLXIe/y2A0hq0h0l9bKoQpJb359pM9TwFw9QhQJACasKRxTv7qSF6ErXvrcZ13HaQaazmaYdm8sPz8ND4UZ8CW0vTiF5Mo4nQ77yx+XOVCpKOCqCR8E8JCTz3K1nhQJBAOHTNr9YkPH2wiTsMaUN29fAbV/xnkX77e1cX5V995P+ovuPfhQS36B15AGH1TGWipF5+8AIcHjOVpw6IKzexcI="


//支付宝公钥
#define AlipayPubKey   @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"

#endif
