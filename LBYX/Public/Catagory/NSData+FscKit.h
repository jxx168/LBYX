//
//  NSData+FscKit.h
//  BLEAssistant
//
//  Created by ericj on 2018/1/30.
//  Copyright © 2018年 feasycom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (FscKit)

+ (NSData *)convertHexStrToData:(NSString *)string;

@end
