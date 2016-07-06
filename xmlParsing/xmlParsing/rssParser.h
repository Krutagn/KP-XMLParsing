//
//  rssParser.h
//  xmlParsing
//
//  Created by krutagn on 04/07/16.
//  Copyright © 2016 com.zaptechsolution. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "rssItem.h"

@interface rssParser : NSObject<NSXMLParserDelegate> {
    //This variable will eventually (once the asynchronous event has completed) hold all the RSSItems in the feed
    NSMutableArray *allItems;
    
    //This variable will be used to map properties in the XML to properties in the RSSItem object
    NSMutableArray *propertyMap;
    
    //This variable will be used to build up the data coming back from NSURLConnection
    NSMutableData *receivedData;
    
    //This item will be declared and created each time a new RSS item is encountered in the XML
    rssItem *currentItem;
    
    //This stores the value of the XML element that is currently being processed
    NSMutableString *currentValue;
    
    //This allows the creating object to know when parsing has completed
    BOOL parsing;
    
    //This internal variable allows the object to know if the current property is inside an item element
    BOOL inItemElement;
}

@property (nonatomic, readonly) NSMutableArray *allItems;
@property (nonatomic, retain) NSMutableArray *propertyMap;
@property (nonatomic, retain) NSData *receivedData;
@property (nonatomic, retain) rssItem *currentItem;
@property (nonatomic, retain) NSMutableString *currentValue;
@property BOOL parsing;

//This method kicks off a parse of a URL at a specified string
- (void)startParse:(NSString*)url;
@end
