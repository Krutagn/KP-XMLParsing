//
//  rssParser.m
//  xmlParsing
//
//  Created by krutagn on 04/07/16.
//  Copyright © 2016 com.zaptechsolution. All rights reserved.
//

#import "rssParser.h"

@implementation rssParser

- (void)startParse:(NSString *)url
{
    //Set the status to parsing
    parsing = true;
    
    //Initialise the receivedData object
    receivedData = [[NSMutableData alloc] init];
    
    //Create the connection with the string URL and kick it off
    NSURLConnection *urlConnection = [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] delegate:self];
    [urlConnection start];
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //Reset the data as this could be fired if a redirect or other response occurs
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //Append the received data each time this is called
    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //Start the XML parser with the delegate pointing at the current object
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:receivedData];
    [parser setDelegate:self];
    [parser parse];
    
    parsing = false;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    //Create the property map that will be used to check and populate from elements
    propertyMap = [[NSMutableArray alloc] initWithObjects:@"title", @"description", nil];
    //Clear allItems each time we kick off a new parse
    [allItems removeAllObjects];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    //If we find an item element, then ensure that the object knows we are inside it, and that the new item is allocated
    if ([elementName isEqualToString:@"item"])
    {
        currentItem = [[rssItem alloc] init];
        inItemElement = true;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    //When we reach the end of an item element, we should add the RSSItem to the allItems array
    if ([elementName isEqualToString:@"item"])
    {
        [allItems addObject:currentItem];
        currentItem = nil;
        inItemElement = false;
    }
    //If we are in element and we reach the end of an element in the propertyMap, we can trim its value and set it using the setValue method on RSSItem
    if (inItemElement)
    {
        if ([propertyMap containsObject:elementName])
        {
            [currentItem setValue:[currentValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:elementName];
        }
    }
    
    //If we've reached the end of an element then we should the scrap the value regardless of whether we've used it

    currentValue = nil;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //When we find characters inside an element, we can add it to the current value, which is created if it is not initialized at present
    if (!currentValue)
    {
        currentValue = [[NSMutableString alloc] init];
    }
    [currentValue appendString:string];
}
@end
