//
//  BarneyBlasterView.h
//  BarneyBlaster
//
//  Created by Uli Kusterer on 10.12.08.
//  Copyright (c) 2011, The Void Software. All rights reserved.
//

// -----------------------------------------------------------------------------
//	Headers:
// -----------------------------------------------------------------------------

#import <ScreenSaver/ScreenSaver.h>


// -----------------------------------------------------------------------------
//	Constants:
// -----------------------------------------------------------------------------

typedef enum eBBBarneyState
{
	kBBNewBarneyState,
	kBBJumpingBarneyState,
	kBBExplodingBarneyState,
	kBBBurningBarneyState,
	kBBShotBarneyState
} BBBarneyState;


// -----------------------------------------------------------------------------
//	Classes:
// -----------------------------------------------------------------------------

@interface BBBarneyBlasterView : ScreenSaverView 
{
	NSMutableArray		*	barneys;
}

@end


@interface BBBarney : NSObject
{
	BBBarneyState		state;
	NSArray*			images;
	NSUInteger			imageIndex;
	NSSound*			currentSound;
	NSPoint				position;
	NSPoint				firePosition;
	BOOL				soundFinished;
}

@property (assign) 	NSPoint				position;

-(void)		draw;
-(void)		animate: (id)sender;

@end
