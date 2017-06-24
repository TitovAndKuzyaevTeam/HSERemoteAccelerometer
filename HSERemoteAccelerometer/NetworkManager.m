//
//  NetworkManager.m
//  Clustering
//
//  Created by Александр Кузяев 2 on 15/06/2017.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

#import "NetworkManager.h"

const NSString *server = @"http://35.161.181.63:8086";
const NSString *pretty = @"true";
const NSString *db = @"gendata";
const NSString *user = @"mobile";
const NSString *password = @"CdiCzZtXW";

@implementation NetworkManager

- (void)getDataWithName:(NSString *)name {
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@", name];
    
    NSString *urlString = [NSString stringWithFormat:@"@%/query?pretty=@%&u=@%&p=@%&db=@%q=%@", server, pretty, user, password, db, query];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(conn) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }
    
}

- (void)sendDataWithName:(NSString *)name tag:(NSString *)tag value:(NSString *)value {
    
    NSString *urlString = [NSString stringWithFormat:@"@%/write?pretty=@%&u=@%&p=@%&db=@%", server, pretty, user, password, db];
    NSString *body = [self generateBodyForName:name tag:tag value:value];
    
    NSData *bodyData = [body dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:bodyData];

    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(conn) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }
}

- (NSString *)generateBodyForName:(NSString *)name tag:(NSString *)tag value:(NSString *)value {
    return [NSString stringWithFormat:@"%@,tag=%@ value=%@", name, tag, value];
}

// This method is used to receive the data which we get using post method.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data {
    NSLog(@"%@", data);
}

// This method receives the error report in case of connection is not made to server.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"%@", error.localizedDescription);
}

// This method is used to process the data after connection has made successfully.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {

}

@end
