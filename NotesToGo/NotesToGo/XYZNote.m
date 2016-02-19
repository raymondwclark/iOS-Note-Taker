//
//  XYZNote.m
//  NotesToGo
//
//  Created by Raymond Clark on 6/19/14.
//  Copyright (c) 2014 Raymond Clark. All rights reserved.
//

#import "XYZNote.h"

@implementation XYZNote

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.noteName = [decoder decodeObjectForKey:@"noteName"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.noteName forKey:@"noteName"];

}

@end
