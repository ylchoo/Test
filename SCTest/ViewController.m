//
//  ViewController.m
//  SCTest
//
//  Created by New User on 26/3/14.
//  Copyright (c) 2014 Espressoft. All rights reserved.
//

#import "ViewController.h"
#import <ShinobiCharts/ShinobiChart.h>

@interface ViewController () <SChartDatasource>
    
@end

@implementation ViewController{
    ShinobiChart* _chart;
    NSMutableArray *dataArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    dataArray = [[NSMutableArray alloc] init];
    NSDate *startTime = [NSDate dateWithTimeIntervalSince1970:1364130000]; //1362056435];
    //    NSDate *startTime = [NSDate dateWithTimeIntervalSince1970:1362056435];
    
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSUInteger preservedComponents = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit);
    NSDate *date = [calendar dateFromComponents:[calendar components:preservedComponents fromDate:startTime]];
    
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 2;
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    for (int i = 0; i < 30; i ++) {
        date = [theCalendar dateByAddingComponents:dayComponent toDate:date options:0];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:date, @"xValue", @"5", @"yValue", nil];
        [dataArray addObject:dict];
    }
    
    // Create the chart
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat margin = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 10.0 : 50.0;
    _chart = [[ShinobiChart alloc] initWithFrame:CGRectInset(self.view.bounds, margin, margin)];
    _chart.title = @"Trigonometric Functions";
    
    _chart.autoresizingMask =  ~UIViewAutoresizingNone;
    
    _chart.licenseKey = @""; // TODO: add your trial licence key here!
    
    // add a pair of axes
    SChartDateTimeAxis *xAxis = [[SChartDateTimeAxis alloc] init];
    xAxis.title = @"X Value";
    xAxis.style.interSeriesPadding = @0;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    SChartTickLabelFormatter *format = [[SChartTickLabelFormatter alloc] init];
    format.formatter = formatter;
    xAxis.labelFormatter = format;
    //allow zooming and panning
    xAxis.enableGesturePanning = YES;
    xAxis.enableGestureZooming = YES;
    xAxis.enableMomentumPanning = YES;
    xAxis.enableMomentumZooming = YES;
    _chart.xAxis = xAxis;
    
    SChartNumberAxis *yAxis = [[SChartNumberAxis alloc] init];
    yAxis.title = @"Y Value";
    yAxis.rangePaddingLow = @(0.1);
    yAxis.rangePaddingHigh = @(0.1);
    
    SChartMajorGridlineStyle *gridStyleX = [[SChartMajorGridlineStyle alloc] init];
    gridStyleX.showMajorGridLines=YES;
    gridStyleX.lineColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
    gridStyleX.lineWidth = [NSNumber numberWithFloat:0.5];
    xAxis.style.majorGridLineStyle=gridStyleX;
    
    _chart.yAxis = yAxis;
    
    // enable gestures
    yAxis.enableGesturePanning = YES;
    yAxis.enableGestureZooming = YES;
    xAxis.enableGesturePanning = YES;
    xAxis.enableGestureZooming = YES;
    
    
    // add to the view
    [self.view addSubview:_chart];
    
    _chart.datasource = self;
    
    _chart.legend.hidden = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
}

#pragma mark - SChartDatasource methods

- (NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart {
    return 1;
}

-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(NSInteger)index {
    
    SChartLineSeries *lineSeries = [[SChartLineSeries alloc] init];
    
    lineSeries.style.lineColor = [UIColor lightGrayColor];//[color colorWithAlphaComponent:0.8];
    lineSeries.crosshairEnabled=YES;
    lineSeries.style.lineWidth = @3;
    // Point (dot) style - solid dot
    lineSeries.style.pointStyle.showPoints = YES;
    lineSeries.style.pointStyle.color = [UIColor blackColor];//color;
    lineSeries.style.pointStyle.radius = @10;
    return lineSeries;
}

- (NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex {
    return [dataArray count];
}

- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex {
    NSDictionary *dict = [dataArray objectAtIndex:dataIndex];
    SChartDataPoint *datapoint = [[SChartDataPoint alloc] init];
    datapoint.xValue = [dict objectForKey:@"xValue"];
    datapoint.yValue = [dict objectForKey:@"yValue"];
    return datapoint;
}

@end
