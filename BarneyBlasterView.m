//
//  BarneyBlasterView.m
//  BarneyBlaster
//
//  Created by Uli Kusterer on 10.12.08.
//  Copyright (c) 2008, The Void Software. All rights reserved.
//

// -----------------------------------------------------------------------------
//	Headers:
// -----------------------------------------------------------------------------

#import "BarneyBlasterView.h"
#import "UKHelperMacros.h"


@interface BBBarney() <NSSoundDelegate>

@end


@implementation BBBarney

@synthesize position;

-(id)	init
{
	if(( self = [super init] ))
	{
		
	}
	
	return self;
}

-(void)		draw
{
	if( images )
	{
		NSImage	*	img = [images objectAtIndex: imageIndex];
		imageIndex++;
		[img drawAtPoint: position fromRect: NSZeroRect operation: NSCompositeSourceAtop fraction: 1.0];
	}
}


-(void)		animate: (id)sender
{
	NSBundle	*	bundle = [NSBundle bundleForClass: [self class]];

	if( [images count] <= imageIndex )
	{
		switch( state )
		{
			case kBBNewBarneyState:
			{
				NSLog( @"NewBarney" );
				NSImage	*	i1 = [bundle imageForResource: @"barney_jump1"];
				NSImage	*	i2 = [bundle imageForResource: @"barney_jump2"];
				NSImage	*	i3 = [bundle imageForResource: @"barney_jump3"];
				NSImage	*	i4 = [bundle imageForResource: @"barney_jump4"];
				NSImage	*	i5 = [bundle imageForResource: @"barney_jump5"];
				NSArray	*	imgs = [NSArray arrayWithObjects: i1, i2, i3, i4, i5, nil];
				NSLog( @"%@ %@ %@ %@ %@ %@", i1, i2, i3, i4, i5, imgs );
				ASSIGN(images, imgs);
				imageIndex = 0;
				state = kBBJumpingBarneyState;
				break;
			}
			
			case kBBJumpingBarneyState:
				NSLog( @"JumpingBarney" );
				switch( rand() % 3 )
				{
					case 0:
					{
						NSLog( @"Switch to Explode" );
						NSImage	*	i1 = [bundle imageForResource: @"barney_jump1"];
						NSImage	*	i2 = [bundle imageForResource: @"barney_jump2"];
						NSImage	*	i3 = [bundle imageForResource: @"barney_jump3"];
						NSImage	*	i4 = [bundle imageForResource: @"barney_jump4"];
						NSArray	*	imgs = [NSArray arrayWithObjects: i1, i2, i3, i4, nil];
						NSLog( @"%@ %@ %@ %@ %@", i1, i2, i3, i4, imgs );
						ASSIGN(images, imgs);
						imageIndex = 0;
						state = kBBExplodingBarneyState;
						break;
					}
					case 1:
					{
						NSLog( @"Switch to Burn" );
						DESTROY(images);
						imageIndex = -1;
						state = kBBBurningBarneyState;
						break;
					}
					case 2:
					{
						NSLog( @"Switch to Shot" );
						DESTROY(images);
						imageIndex = -1;
						state = kBBShotBarneyState;
						break;
					}
				}
				break;
			
			default:
				NSLog( @"End of other state, REWIND" );
				state = kBBNewBarneyState;
				DESTROY(images);
				break;
		}
	}
	else if( images )
	{
		switch( state )
		{
			case kBBJumpingBarneyState:
				if( imageIndex == 0 )
				{
					soundFinished = NO;
					DESTROY(currentSound);
					currentSound = [[NSSound alloc] initWithContentsOfFile: [bundle pathForSoundResource: @"chuckle_start"] byReference: YES];
					[currentSound setDelegate: self];
					[currentSound play];
					imageIndex++;
				}
				else if( imageIndex == 2 )
				{
					if( soundFinished )
					{
						soundFinished = NO;
						DESTROY(currentSound);
						currentSound = [[NSSound alloc] initWithContentsOfFile: [bundle pathForSoundResource: @"chuckle_end"] byReference: YES];
						[currentSound setDelegate: self];
						[currentSound play];
						imageIndex++;
					}
				}
				else
					imageIndex++;
				break;
				
			default:
				imageIndex++;
		}
	}
	else if( state == kBBBurningBarneyState )
	{
		NSLog( @"Complex state" );
		imageIndex++;
	}
}


-(void)	sound: (NSSound *)sound didFinishPlaying: (BOOL)aBool
{
	soundFinished = YES;
}

@end


@implementation BBBarneyBlasterView

-(id)	initWithFrame: (NSRect)frame isPreview: (BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self)
	{		
		[self setAnimationTimeInterval: 0.1];
		barneys = [[NSMutableArray alloc] init];
	}
    return self;
}


-(void)	dealloc
{
 	DESTROY(barneys);
	
	[super dealloc];
}


- (void)startAnimation
{
    [super startAnimation];
	
	BBBarney	*	barney = [[BBBarney alloc] init];
	NSRect			bounds = [self bounds];
	barney.position = NSMakePoint( rand() % (int)bounds.size.width, rand() % (int)bounds.size.height );
	[barneys addObject: barney];
	DESTROY(barney);
}

- (void)stopAnimation
{
    [super stopAnimation];
}

-(void)	drawRect: (NSRect)rect
{
    [super drawRect:rect];
	
	NSRectFillUsingOperation( [self bounds], NSCompositeClear );
	
	for( BBBarney* currBarney in barneys )
	{
		[currBarney draw];
	}
}

-(void)	animateOneFrame
{
	[super animateOneFrame];
	
	for( BBBarney* currBarney in barneys )
	{
		[currBarney animate: self];
	}
	[self setNeedsDisplay: YES];
}

- (BOOL)hasConfigureSheet
{
    return NO;
}

- (NSWindow*)configureSheet
{
    return nil;
}

@end
