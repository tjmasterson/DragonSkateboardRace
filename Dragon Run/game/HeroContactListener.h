
#import "Box2D.h"

#define kMaxAngleDiff 2.4f // in radians

@class Hero;
@class GameLayer;

class HeroContactListener : public b2ContactListener {
public:
	Hero *_hero;
	GameLayer* _gameLayer;
	
	HeroContactListener(Hero* hero, GameLayer* gameLayer);
	~HeroContactListener();
	
	void BeginContact(b2Contact* contact);
	void EndContact(b2Contact* contact);
	void PreSolve(b2Contact* contact, const b2Manifold* oldManifold);
	void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse);
};