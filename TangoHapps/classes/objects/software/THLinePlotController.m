//
//  THLinePlotController.m
//  TangoHapps
//
//  Created by Guven Candogan on 31/01/15.
//  Copyright (c) 2015 Technische Universität München. All rights reserved.
//

#import "THLinePlotController.h"
#import "THRecorder.h"

@interface THLinePlotController ()
@property (nonatomic, readonly) NSMutableArray *annotations;
@property (nonatomic, readwrite, strong) NSArray *plotData;
@end

@implementation THLinePlotController

@synthesize plotData;
@synthesize annotations;

#pragma mark - Initializing

-(id)init
{
    if ( (self = [super init]) ) {
        [self generateData];
        
        [self draw];
    }
    
    return self;
}

-(id)initWithView:(UIView *)view withData:(NSMutableArray *) data{

    _inView = view;
    
    if ( data != nil ) {
        [plotData copy:data];
    }

    return [self init];
}


-(void)createHostingView{

    /*CGRect imageFrame = CGRectMake(0, 0, 400, 300);
    UIView *inView = [[UIView alloc] initWithFrame:imageFrame];
    [inView setOpaque:YES];
    [inView setUserInteractionEnabled:NO];
    */
    CGRect bounds = _inView.bounds;
    bounds.size.height = bounds.size.height-50;
    bounds.origin.x = bounds.origin.x ;
    bounds.origin.y = bounds.origin.y +50;
    _hostingView = [[CPTGraphHostingView alloc] initWithFrame:bounds];
    NSLog(@"hostingView.frame.size.height %f",_hostingView.frame.size.height);
  //  hostingView.frame.size.height = hostingView.frame.size.height-10;

    [_inView addSubview:_hostingView];
    
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
    _hostingView.translatesAutoresizingMaskIntoConstraints = YES;
    /*hostingView.translatesAutoresizingMaskIntoConstraints = NO;
    [inView addConstraint:[NSLayoutConstraint constraintWithItem:hostingView
                                                       attribute:NSLayoutAttributeLeft
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:inView
                                                       attribute:NSLayoutAttributeLeading
                                                      multiplier:1.0
                                                        constant:0.0]];
    [inView addConstraint:[NSLayoutConstraint constraintWithItem:hostingView
                                                       attribute:NSLayoutAttributeTop
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:inView
                                                       attribute:NSLayoutAttributeTop
                                                      multiplier:1.0
                                                        constant:0.0]];
    [inView addConstraint:[NSLayoutConstraint constraintWithItem:hostingView
                                                       attribute:NSLayoutAttributeRight
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:inView
                                                       attribute:NSLayoutAttributeTrailing
                                                      multiplier:1.0
                                                        constant:0.0]];
    [inView addConstraint:[NSLayoutConstraint constraintWithItem:hostingView
                                                       attribute:NSLayoutAttributeBottom
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:inView
                                                       attribute:NSLayoutAttributeBottom
                                                      multiplier:1.0
                                                        constant:0.0]];*/
#else
    [hostingView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    [hostingView setAutoresizesSubviews:YES];
#endif
    
    return ;
}

#pragma mark - Methods

- (void)draw {
    // Do any additional setup after loading the view from its nib.
    
    [self createHostingView];
    _graph = [[CPTXYGraph alloc] initWithFrame: _hostingView.bounds];
    //CPTGraphHostingView *hostingView = (CPTGraphHostingView *)self.view;
    _hostingView.hostedGraph = _graph;
    _graph.paddingLeft = 20.0;
    _graph.paddingTop = 20.0;
    _graph.paddingRight = 20.0;
    _graph.paddingBottom = 20.0;
    
    // Plot area delegate
    _graph.plotAreaFrame.plotArea.delegate = self;
    
    // Setup scatter plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)_graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
    plotSpace.delegate              = self;
    
    // Grid line styles
    CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorGridLineStyle.lineWidth = 0.75;
    majorGridLineStyle.lineColor = [[CPTColor colorWithGenericGray:CPTFloat(0.2)] colorWithAlphaComponent:CPTFloat(0.75)];
    
    CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
    minorGridLineStyle.lineWidth = 0.25;
    minorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:CPTFloat(0.1)];
    
    CPTMutableLineStyle *redLineStyle = [CPTMutableLineStyle lineStyle];
    redLineStyle.lineWidth = 10.0;
    redLineStyle.lineColor = [[CPTColor redColor] colorWithAlphaComponent:0.5];
    
    // Axes
    // Label x axis with a fixed interval policy
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)_graph.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    x.majorIntervalLength         = CPTDecimalFromDouble(0.5);
    x.orthogonalCoordinateDecimal = CPTDecimalFromDouble(1.0);
    x.minorTicksPerInterval       = 2;
    x.majorGridLineStyle          = majorGridLineStyle;
    x.minorGridLineStyle          = minorGridLineStyle;
    
    x.title         = @"X Axis";
    x.titleOffset   = 30.0;
    x.titleLocation = CPTDecimalFromDouble(1.25);
    
    // Label y with an automatic label policy.
    CPTXYAxis *y = axisSet.yAxis;
    y.labelingPolicy              = CPTAxisLabelingPolicyAutomatic;
    y.orthogonalCoordinateDecimal = CPTDecimalFromDouble(1.0);
    y.minorTicksPerInterval       = 2;
    y.preferredNumberOfMajorTicks = 8;
    y.majorGridLineStyle          = majorGridLineStyle;
    y.minorGridLineStyle          = minorGridLineStyle;
    y.labelOffset                 = 10.0;
    
    y.title         = @"Y Axis";
    y.titleOffset   = 30.0;
    y.titleLocation = CPTDecimalFromDouble(1.0);
    
    // Set axes
    _graph.axisSet.axes = @[x, y];
    
    // Create a plot that uses the data source method
    CPTScatterPlot *dataSourceLinePlot = [[CPTScatterPlot alloc] init];
    dataSourceLinePlot.identifier = @"Data Source Plot";
    
    CPTMutableLineStyle *lineStyle = [dataSourceLinePlot.dataLineStyle mutableCopy];
    lineStyle.lineWidth              = 3.0;
    lineStyle.lineColor              = [CPTColor greenColor];
    dataSourceLinePlot.dataLineStyle = lineStyle;
    
    dataSourceLinePlot.dataSource = self;
    [_graph addPlot:dataSourceLinePlot];
    
    // Auto scale the plot space to fit the plot data
    // Extend the ranges by 30% for neatness
    [plotSpace scaleToFitPlots:@[dataSourceLinePlot]];
    CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
    CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
    [xRange expandRangeByFactor:CPTDecimalFromDouble(1.3)];
    [yRange expandRangeByFactor:CPTDecimalFromDouble(1.3)];
    plotSpace.xRange = xRange;
    plotSpace.yRange = yRange;
    
    // Restrict y range to a global range
    CPTPlotRange *globalYRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f)
                                                              length:CPTDecimalFromFloat(2.0f)];
    plotSpace.globalYRange = globalYRange;
    
    // Add plot symbols
    CPTMutableLineStyle *symbolLineStyle = [CPTMutableLineStyle lineStyle];
    symbolLineStyle.lineColor = [CPTColor blackColor];
    CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill               = [CPTFill fillWithColor:[CPTColor blueColor]];
    plotSymbol.lineStyle          = symbolLineStyle;
    plotSymbol.size               = CGSizeMake(10.0, 10.0);
    dataSourceLinePlot.plotSymbol = plotSymbol;
    
    // Set plot delegate, to know when symbols have been touched
    // We will display an annotation when a symbol is touched
    dataSourceLinePlot.delegate                        = self;
    dataSourceLinePlot.plotSymbolMarginForHitDetection = 5.0;
    
}

-(NSMutableArray*) getMarkedPoints{
    NSMutableArray* result = [NSMutableArray array];
    
    for (CPTPlotSpaceAnnotation * annotation in self.annotations) {
        NSArray *anchorPoint = annotation.anchorPlotPoint;
        [result addObject:anchorPoint[1]];
    }
    
    
    return result;
}

#pragma mark - Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return self.plotData.count;
}

-(id)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSString *key = (fieldEnum == CPTScatterPlotFieldX ? @"x" : @"y");
    NSNumber *num = self.plotData[index][key];
    
    return num;
}

#pragma mark -
#pragma mark Plot Space Delegate Methods

-(CPTPlotRange *)plotSpace:(CPTPlotSpace *)space willChangePlotRangeTo:(CPTPlotRange *)newRange forCoordinate:(CPTCoordinate)coordinate
{
    // Impose a limit on how far user can scroll in x
    if ( coordinate == CPTCoordinateX ) {
        CPTPlotRange *maxRange            = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-1.0f) length:CPTDecimalFromFloat(6.0f)];
        CPTMutablePlotRange *changedRange = [newRange mutableCopy];
        [changedRange shiftEndToFitInRange:maxRange];
        [changedRange shiftLocationToFitInRange:maxRange];
        newRange = changedRange;
    }
    
    return newRange;
}

#pragma mark -
#pragma mark CPTScatterPlot delegate methods

-(void)scatterPlot:(CPTScatterPlot *)plot plotSymbolWasSelectedAtRecordIndex:(NSUInteger)index
{
 
    /*
     CPTPlotSpaceAnnotation *annotation = self.symbolTextAnnotation;
     
     if ( annotation ) {
     [graph.plotAreaFrame.plotArea removeAnnotation:annotation];
     annotation = nil;
     }
     */
    // Setup a style for the annotation
    CPTMutableTextStyle *hitAnnotationTextStyle = [CPTMutableTextStyle textStyle];
    hitAnnotationTextStyle.color    = [CPTColor whiteColor];
    hitAnnotationTextStyle.fontSize = 16.0;
    hitAnnotationTextStyle.fontName = @"Helvetica-Bold";
    
    // Determine point of symbol in plot coordinates
    NSDictionary *dataPoint = self.plotData[index];
    
    NSNumber *x = dataPoint[@"x"];
    NSNumber *y = dataPoint[@"y"];
    CPTPlotSpaceAnnotation *annotation;
    
    int objectIndex = [self didPointAnnotated:x yAxis:y];
    if(objectIndex > -1){
        annotation=  [self.annotations objectAtIndex: (NSUInteger)objectIndex];
        [_graph.plotAreaFrame.plotArea removeAnnotation:annotation];
        [self.annotations removeObject:annotation];
        return;
    }
    
    NSArray *anchorPoint = @[x, y];
    
    // Add annotation
    // First make a string for the y value
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:2];
    NSString *yString = [formatter stringFromNumber:y];
    
    // Now add the annotation to the plot area
    CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithText:yString style:hitAnnotationTextStyle];
    annotation = [[CPTPlotSpaceAnnotation alloc] initWithPlotSpace:_graph.defaultPlotSpace anchorPlotPoint:anchorPoint];
    annotation.contentLayer   = textLayer;
    annotation.displacement   = CGPointMake(0.0, 20.0);
    
    [self.annotations addObject:annotation];
    [_graph.plotAreaFrame.plotArea addAnnotation:annotation];
    
}

-(int) didPointAnnotated:(NSNumber*) x yAxis:(NSNumber*) y{
    
    int i = 0;
    for (CPTPlotSpaceAnnotation * annotation in self.annotations) {
        NSArray *anchorPoint = annotation.anchorPlotPoint;
        if(anchorPoint[0] ==x && anchorPoint[1]==y)
            return i;
        else
            i++;
    }
    
    return (-1);
}

-(NSMutableArray *) annotations{
    if(annotations==nil)
        annotations = [[NSMutableArray alloc] init];
    return annotations;
}

-(void)scatterPlotDataLineWasSelected:(CPTScatterPlot *)plot
{
    NSLog(@"scatterPlotDataLineWasSelected: %@", plot);
}

-(void)scatterPlotDataLineTouchDown:(CPTScatterPlot *)plot
{
    NSLog(@"scatterPlotDataLineTouchDown: %@ Market Points: %@", plot,[self getMarkedPoints]);
}

-(void)scatterPlotDataLineTouchUp:(CPTScatterPlot *)plot
{
    NSLog(@"scatterPlotDataLineTouchUp: %@", plot);
}

#pragma mark -
#pragma mark Plot area delegate method
/*
 -(void)plotAreaWasSelected:(CPTPlotArea *)plotArea
 {
 // Remove the annotation
 CPTPlotSpaceAnnotation *annotation = self.symbolTextAnnotation;
 
 if ( annotation ) {
 CPTXYGraph *graph = [self.graphs objectAtIndex:0];
 
 [graph.plotAreaFrame.plotArea removeAnnotation:annotation];
 self.symbolTextAnnotation = nil;
 }
 
 }
 */


#pragma mark - Helper

-(UIButton*) buttonWithFrame:(CGRect) frame imageName:(NSString*) name{
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = frame;
    UIImage * playImage = [UIImage imageNamed:name];
    [button setBackgroundImage:playImage forState:UIControlStateNormal];
    button.enabled = NO;
    
    return button;
}

-(void) loadAnnotations{
    if(self.annotations.count){
        for (CPTPlotSpaceAnnotation *annotation in self.annotations) {
            [_graph.plotAreaFrame.plotArea  addAnnotation:annotation];
        }
    }
}

-(void)killGraph
{
    {
        [[CPTAnimation sharedInstance] removeAllAnimationOperations];
        
        // Remove the CPTLayerHostingView
        if ( _hostingView ) {
            [_hostingView removeFromSuperview];
            
            _hostingView.hostedGraph      = nil;
        }
        
        if(_graph!=nil){
            if(self.annotations.count){
                for (CPTPlotSpaceAnnotation *annotation in self.annotations) {
                    [_graph.plotAreaFrame.plotArea removeAnnotation:annotation];
                }
            }
        }
        _graph = nil;
        _inView = nil;
        _backButton = nil;
    }
}

-(void)dealloc
{
    [self killGraph];
}

-(void)generateData
{
    if ( self.plotData == nil ) {
        NSMutableArray *contentArray = [NSMutableArray array];
        for ( NSUInteger i = 0; i < 10; i++ ) {
            NSNumber *x = @(1.0 + i * 0.05);
            NSNumber *y = @(1.2 * arc4random() / (double)UINT32_MAX + 0.5);
            [contentArray addObject:@{ @"x": x, @"y": y }
             ];
        }
        self.plotData = contentArray;
    }
}

#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
