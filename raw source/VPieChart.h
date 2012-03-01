#import <UIKit/UIKit.h>

/*!
 Ultra-simple pie-chart class
 
 License: Creative Commons (do anything you like - use it commercially, etc)
 
 Instructions:
 
 1. Add a UIView in Interface Builder, and set its class to "VPieChart" (or create a VPieChart programmatically, just like a normal UIView)
 2. At runtime, call at least one call to [VPieChart addSegment:] - e.g. "VPieChart* myChart; ... [myChart addSegment:[PieSegment segmentWithLabel:@"Pies" value:5.0]];"
 */

@interface PieSegment : NSObject
@property(nonatomic,retain) NSString* label;
@property(nonatomic) float value;

+(PieSegment*) pieSegmentWithLabel:(NSString*) l value:(float) v;
@end

@interface VPieChart : UIView

@property(nonatomic,retain) NSMutableArray* segments;
@property(nonatomic,retain) NSString* fontFamilyName;

-(void) addSegment:(PieSegment*) seg;

@end
