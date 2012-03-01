#import "VPieChart.h"

@implementation PieSegment
@synthesize label;
@synthesize value;

+(PieSegment*) pieSegmentWithLabel:(NSString*) l value:(float) v
{
	PieSegment* p = [[[PieSegment alloc] init] autorelease];
	
	p.label = l;
	p.value = v;
	
	return p;
}
@end

#define IS_IPAD 1 // You should change this to be a runtime check for whether you're running on iPad or on iPhone. It's needed to correctly pick an automatically-correct font size

@implementation VPieChart

@synthesize fontFamilyName;
@synthesize segments;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		self.segments = [NSMutableArray array];
		self.fontFamilyName = @"AmericanTypewriter-Bold";
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
		self.segments = [NSMutableArray array];
		self.fontFamilyName = @"AmericanTypewriter-Bold";
    }
    return self;
}

-(void) drawString:(NSString*) text atPoint:(CGPoint) point color:(UIColor*) color maxWidth:(CGFloat) maxWidth
{
#if IS_IPAD
	float ptsPerPixel = 526.32 / 768.0; // Apple uses points not pixels. Ipad is 72 pts/inch * 7.3 inches short side
#else
	float ptsPerPixel = 136.8 / 320.0; // Apple uses points not pixels. IPhone (even with Retina!) is 72 pts/inch * 1.9 inches short side
#endif
	float letterWidthPerHeight = 2.0; // in most fonts, the letters are approx twice as wide as they are tall. POINTS are letter heights, and we need to calc WIDTHS
	
	UIFont* font = [UIFont fontWithName:self.fontFamilyName size: ptsPerPixel * (maxWidth * letterWidthPerHeight / (float)[text length]) ];
	
	CGContextSaveGState( UIGraphicsGetCurrentContext() );
	CGContextTranslateCTM( UIGraphicsGetCurrentContext(), point.x, point.y ); // Apple's "drawAtPoint:withFont:" has some bugs - they recommend always drawing at zero, and instead shifting the context
	
	CGContextSetFillColorWithColor( UIGraphicsGetCurrentContext(), color.CGColor );
	[text drawAtPoint:CGPointZero withFont:font];
	CGContextRestoreGState( UIGraphicsGetCurrentContext() );
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 */
- (void)drawRect:(CGRect)rect
{
	// Drawing code
	CGRect f = self.bounds;
	CGPoint o = CGPointMake( f.size.width/2.0, f.size.height/2.0);
	CGFloat minDimension = MIN( f.size.width, f.size.height );
	CGContextRef c = UIGraphicsGetCurrentContext();
	
	if( [self.segments count] < 1 )
	{
		[self drawString:@"No segments" atPoint:CGPointMake(0, o.y) color:[UIColor redColor] maxWidth:f.size.width];
		return;
	}
	
	NSMutableArray* segAngles = [NSMutableArray array];
	float totalValue = 0.0;
	for( PieSegment* seg in self.segments )
	{
		totalValue += seg.value;
	}
	for( PieSegment* seg in self.segments )
	{
		[segAngles addObject:[NSNumber numberWithFloat:(seg.value / totalValue) * 2.0 * M_PI]];
	}
	
	
	float sAngle = 0.0;
	float radius = minDimension/2.0;
	for( int i=0; i<[segAngles count]; i++ )
	{
		float eAngle = sAngle + [[segAngles objectAtIndex:i] floatValue];
		
		/** Draw the pie-segment */
		CGContextBeginPath(c);
		CGContextMoveToPoint(c, o.x, o.y);
		CGContextAddArc(c, o.x, o.y, radius, sAngle, eAngle, 0);
		CGContextSetFillColorWithColor(c, [UIColor colorWithHue:(i / (float)[segAngles count]) saturation:1.0 brightness:1.0 alpha:1.0].CGColor );
		CGContextFillPath(c);
		
		/** Draw the label */
		PieSegment* segment = [self.segments objectAtIndex:i];
		CGPoint midPoint = CGPointMake( o.x + radius * cosf(sAngle + (eAngle-sAngle)/2.0) / 2.0, o.y + radius * sinf(sAngle + (eAngle-sAngle)/2.0) / 2.0 );
		CGFloat textWidth = (eAngle-sAngle)/M_PI_2 * radius/2.0;
		[self drawString:segment.label atPoint:CGPointMake( midPoint.x - textWidth/3.0, midPoint.y) color:[UIColor blackColor] maxWidth:textWidth];
		
		sAngle = eAngle;
	}
}

-(void)addSegment:(PieSegment *)seg
{
	[self.segments addObject:seg];
}

@end
