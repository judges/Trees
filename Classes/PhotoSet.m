//
//  PhotoSet.m
//  landscapes
//
//  Created by Evan Cordell on 8/9/10.
//  Copyright 2010 NCPTT. All rights reserved.
//

#import "PhotoSet.h"
#import "DisplayPhoto.h"
#import "AppDelegate_Shared.h"

@implementation PhotoSet
@synthesize title = _title;
@synthesize photos = _photos;
@synthesize ids = _ids;

- (id) initWithTitle:(NSString *)title photos:(NSMutableArray *)photos ids:(NSMutableArray *)ids captions:(NSMutableArray *)captions{
    if ((self = [super init])) {
        [[TTURLCache sharedCache] setMaxPixelCount:0];
        self.title = title;
        self.photos = [[NSMutableArray alloc] init];
        self.ids = [[NSMutableArray alloc] init];
        for(int i = 0; i < photos.count; ++i) {
            NSString *path = [NSString stringWithFormat:@"images/%d.jpg",i];
            UIImage *img = [UIImage imageWithData:[photos objectAtIndex:i]];
            NSString *url = [NSString stringWithFormat:@"temp://%@", path];
            [[TTURLCache sharedCache] storeImage:img forURL:url];
            DisplayPhoto *photo = [[[DisplayPhoto alloc] initWithCaption:[captions objectAtIndex:i] urlLarge:url urlSmall:url urlThumb:url size:img.size] autorelease];
            photo.photoSource = self;
            photo.index = i;
            [self.photos addObject:photo];
            [self.ids addObject:[ids objectAtIndex:i]];
        }        
    }
    return self;
}

- (void) dealloc {
    self.title = nil;
    self.photos = nil; 
    self.ids = nil;
    [self.photos release];
    [self.ids release];
    [super dealloc];
}

#pragma mark TTModel

- (BOOL)isLoading { 
    return FALSE;
}

- (BOOL)isLoaded {
    return TRUE;
}

#pragma mark TTPhotoSource

- (NSInteger)numberOfPhotos {
    return _photos.count;
}

- (NSInteger)maxPhotoIndex {
    return _photos.count-1;
}

- (id<TTPhoto>)photoAtIndex:(NSInteger)photoIndex {
    if (photoIndex < _photos.count) {
        return [_photos objectAtIndex:photoIndex];
    } else {
        return nil;
    }
}
-(void)deletePhotoAtIndex:(NSInteger)index {
        if (index < _photos.count) {       
            NSManagedObjectContext *managedObjectContext = [(AppDelegate_Shared *)[[UIApplication sharedApplication] delegate] managedObjectContext];
            NSError *error;
            Image *img = (Image *)[managedObjectContext objectWithID:[self.ids objectAtIndex:index]];
            [managedObjectContext deleteObject:img];
            [managedObjectContext save:&error];
            [_photos removeObjectAtIndex:index];
        }
}
@end
