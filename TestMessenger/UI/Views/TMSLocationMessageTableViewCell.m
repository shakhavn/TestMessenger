//
//  TMSLocationMessageTableViewCell.m
//  TestMessenger
//
//  Created by Yulia Shakhavnina on 11/07/2017.
//  Copyright © 2017 yuliashakhavnina. All rights reserved.
//

#import "TMSLocationMessageTableViewCell.h"
#import <MapKit/MapKit.h>

@interface TMSLocationMessageTableViewCell ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation TMSLocationMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setPinLocation:(CLLocation *)pinLocation {
    [self.mapView removeAnnotations:self.mapView.annotations];
    _pinLocation = pinLocation;
    if (pinLocation != nil) {
        // Place a single pin
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [annotation setCoordinate:pinLocation.coordinate];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy.MM.dd hh:mm:ss";
        formatter.locale = [NSLocale currentLocale];
        annotation.title = [formatter stringFromDate:pinLocation.timestamp];
        [self.mapView addAnnotation:annotation];
        MKCoordinateRegion region = MKCoordinateRegionMake(pinLocation.coordinate, MKCoordinateSpanMake(0.01, 0.01));
        [self.mapView setRegion:region animated:YES];
    }
    
}

@end
