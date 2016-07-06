//
//  rssItem.h
//  xmlParsing
//
//  Created by krutagn on 04/07/16.
//  Copyright © 2016 com.zaptechsolution. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface rssItem : NSObject
{
    NSString *title;
    NSString *description;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *description;

@end
