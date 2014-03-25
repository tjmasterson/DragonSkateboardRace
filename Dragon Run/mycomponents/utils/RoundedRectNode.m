/*
 *  RoundedRectNode.m
 *
*
 */



#import "RoundedRectNode.h"


@implementation RoundedRectNode

@synthesize size, radius, borderWidth, cornerSegments, borderColor, fillColor;

#define kappa 0.552228474

-(id) initWithRectSize:(CGSize)sz  {
    
    if((self=[super init]))
    {
        size = sz;
        radius = 10;
        borderWidth = 0;
        cornerSegments = 20;
        borderColor = ccc4(0,0,0,0);
        fillColor = ccc4(0,0,0,90);
        
    }
    return self;
}

void appendCubicBezier(int startPoint, CGPoint* vertices, CGPoint origin, CGPoint control1, CGPoint control2, CGPoint destination, NSUInteger segments)
{
	//ccVertex2F vertices[segments + 1];
	
	float t = 0;
	for(NSUInteger i = 0; i < segments; i++)
	{
		GLfloat x = powf(1 - t, 3) * origin.x + 3.0f * powf(1 - t, 2) * t * control1.x + 3.0f * (1 - t) * t * t * control2.x + t * t * t * destination.x;
		GLfloat y = powf(1 - t, 3) * origin.y + 3.0f * powf(1 - t, 2) * t * control1.y + 3.0f * (1 - t) * t * t * control2.y + t * t * t * destination.y;
        vertices[startPoint+i] = CGPointMake(x * CC_CONTENT_SCALE_FACTOR(), y * CC_CONTENT_SCALE_FACTOR() );
		//vertices[startPoint+i] = (ccVertex2F) {x * CC_CONTENT_SCALE_FACTOR(), y * CC_CONTENT_SCALE_FACTOR() };
		t += 1.0f / segments;
	}
	//vertices[segments] = (ccVertex2F) {destination.x * CC_CONTENT_SCALE_FACTOR(), destination.y * CC_CONTENT_SCALE_FACTOR() };
}

void ccFillPoly( CGPoint *poli, int points, BOOL closePolygon )
{
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states: GL_VERTEX_ARRAY,
	// Unneeded states: GL_TEXTURE_2D, GL_TEXTURE_COORD_ARRAY, GL_COLOR_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisableClientState(GL_COLOR_ARRAY);
	
	glVertexPointer(2, GL_FLOAT, 0, poli);
	if( closePolygon )
		//	 glDrawArrays(GL_LINE_LOOP, 0, points);
		glDrawArrays(GL_TRIANGLE_FAN, 0, points);
	else
		glDrawArrays(GL_LINE_STRIP, 0, points);
	
	// restore default state
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);
}

-(void) draw {
	CGPoint vertices[16];
    
    vertices[0] = ccp(0,radius);
    vertices[1] = ccp(0,radius*(1-kappa));
    vertices[2] = ccp(radius*(1-kappa),0);
    vertices[3] = ccp(radius,0);
    
    vertices[4] = ccp(size.width-radius,0);
    vertices[5] = ccp(size.width-radius*(1-kappa),0);
    vertices[6] = ccp(size.width,radius*(1-kappa));
    vertices[7] = ccp(size.width,radius);
    
    vertices[8] = ccp(size.width,size.height - radius);
    vertices[9] = ccp(size.width,size.height - radius*(1-kappa));
    vertices[10] = ccp(size.width-radius*(1-kappa),size.height);
    vertices[11] = ccp(size.width-radius,size.height);
    
    vertices[12] = ccp(radius,size.height);
    vertices[13] = ccp(radius*(1-kappa),size.height);                   
    vertices[14] = ccp(0,size.height-radius*(1-kappa));                   
    vertices[15] = ccp(0,size.height-radius);    
    
    
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    
    
    CGPoint polyVertices[4*cornerSegments+1];
    appendCubicBezier(0*cornerSegments,polyVertices,vertices[0], vertices[1], vertices[2], vertices[3], cornerSegments);
    appendCubicBezier(1*cornerSegments,polyVertices,vertices[4], vertices[5], vertices[6], vertices[7], cornerSegments);
    appendCubicBezier(2*cornerSegments,polyVertices,vertices[8], vertices[9], vertices[10], vertices[11], cornerSegments);
    appendCubicBezier(3*cornerSegments,polyVertices,vertices[12], vertices[13], vertices[14], vertices[15], cornerSegments);
    polyVertices[4*cornerSegments] = vertices[0];
    
    glColor4ub(fillColor.r, fillColor.g, fillColor.b, fillColor.a);
    ccFillPoly(polyVertices, 4*cornerSegments+1, YES);
	
    
//    glColor4ub(borderColor.r, borderColor.g, borderColor.b, borderColor.a);
//    glLineWidth(borderWidth);
//    glEnable(GL_LINE_SMOOTH);
//    ccDrawCubicBezier(vertices[0], vertices[1], vertices[2], vertices[3], cornerSegments);
//    ccDrawLine(vertices[3], vertices[4]);
//    ccDrawCubicBezier(vertices[4], vertices[5], vertices[6], vertices[7], cornerSegments);
//    ccDrawLine(vertices[7], vertices[8]);
//    ccDrawCubicBezier(vertices[8], vertices[9], vertices[10], vertices[11], cornerSegments);
//    ccDrawLine(vertices[11], vertices[12]);
//    ccDrawCubicBezier(vertices[12], vertices[13], vertices[14], vertices[15], cornerSegments);
//    ccDrawLine(vertices[15], vertices[0]);
//    glDisable(GL_LINE_SMOOTH);
	
    
}

@end