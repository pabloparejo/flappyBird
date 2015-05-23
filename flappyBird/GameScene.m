//
//  GameScene.m
//  flappyBird
//
//  Created by Pablo Parejo Camacho on 23/5/15.
//  Copyright (c) 2015 Pablo Parejo Camacho. All rights reserved.
//

#import "GameScene.h"

static UInt32 birdGroup = 1 << 0;   // 0001
static UInt32 objectGroup = 1 << 1; // 0010

@interface GameScene()
@property (strong, nonatomic) SKSpriteNode *bird;

@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    
    self.physicsWorld.gravity = CGVectorMake(0, -6);

    [self createBg];
    [self createBird];
    [self createFloor];
    [self createPipes];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.bird.physicsBody applyImpulse:CGVectorMake(0, 120)];
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

-(void) createBird{
    self.bird = [SKSpriteNode spriteNodeWithImageNamed:@"flappy2"];
    self.bird.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    self.bird.zPosition = 10;
    
    self.bird.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.bird.size.width / 2];
    self.bird.physicsBody.dynamic = YES;
    self.bird.physicsBody.categoryBitMask = birdGroup;
    self.bird.physicsBody.collisionBitMask = objectGroup;
    
    self.bird.physicsBody.velocity = CGVectorMake(-10, 0);
    
    
    SKTexture *birdTextureUp = [SKTexture textureWithImageNamed:@"flappy1"];
    SKTexture *birdTextureDown = [SKTexture textureWithImageNamed:@"flappy2"];
    SKAction *fly = [SKAction repeatActionForever:[SKAction animateWithTextures:@[birdTextureUp, birdTextureDown] timePerFrame:0.4f]];
    
    SKAction *floatUp = [SKAction moveByX:0 y:2 duration:.4];
    SKAction *floatDown = [SKAction moveByX:0 y:-2 duration:.4];
    
    SKAction *birdActions = [SKAction repeatActionForever:[SKAction sequence:@[floatDown, floatUp]]];
    
    [self.bird runAction:fly];
    [self.bird runAction:birdActions];
    
    [self addChild:self.bird];
}

-(void) createBg{
    CGPoint bgPosition = CGPointMake(0, CGRectGetMidY(self.frame));
    CGSize bgSize = self.frame.size;
    
    
    SKSpriteNode *bg1 = [SKSpriteNode spriteNodeWithImageNamed:@"bg"];
    bg1.anchorPoint = CGPointMake(0, 0.5);
    bg1.position = bgPosition;
    bg1.size = bgSize;
    
    SKSpriteNode *bg2 = [SKSpriteNode spriteNodeWithImageNamed:@"bg"];
    bg2.anchorPoint = CGPointMake(0, 0.5);
    bg2.position = CGPointMake(bgSize.width, bgPosition.y);
    bg2.size = bgSize;
    
    SKAction *roll = [SKAction moveByX:-bgSize.width y:0 duration:8];
    SKAction *respan = [SKAction moveByX:bgSize.width y:0 duration:0];
    SKAction *bgActions = [SKAction repeatActionForever:[SKAction sequence:@[roll, respan]]];
    
    [bg1 runAction:bgActions];
    [bg2 runAction:bgActions];
    
    
    [self addChild:bg1];
    [self addChild:bg2];
}

-(void) createFloor{
    SKNode *floor = [[SKNode alloc] init];
    floor.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width, 1) center:CGPointMake(CGRectGetMidX(self.frame), 0)];
    floor.physicsBody.dynamic = NO;
    floor.physicsBody.categoryBitMask = objectGroup;
    
    [self addChild:floor];
}

-(void) createPipes{
    
    static CGFloat gap = 200;
    int pipeOffset = arc4random_uniform(self.frame.size.height / 2) - self.frame.size.height / 4;
    
    int pipeDistance = arc4random_uniform(.5) + 2;
    
    SKSpriteNode *pipeUp = [SKSpriteNode spriteNodeWithImageNamed:@"pipe1"];
    pipeUp.anchorPoint = CGPointMake(0, 0);
    pipeUp.position = CGPointMake(self.frame.size.width, CGRectGetMidY(self.frame) + gap/2 + pipeOffset);
    
    pipeUp.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:pipeUp.size center:CGPointMake(pipeUp.size.width / 2,pipeUp.size.height / 2)];
    pipeUp.physicsBody.dynamic = NO;
    pipeUp.physicsBody.categoryBitMask = objectGroup;
    

    SKSpriteNode *pipeDown = [SKSpriteNode spriteNodeWithImageNamed:@"pipe2"];
    pipeDown.anchorPoint = CGPointMake(0, 1);
    pipeDown.position = CGPointMake(self.frame.size.width, CGRectGetMidY(self.frame) - gap/2 + pipeOffset);
    
    pipeDown.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:pipeDown.size center:CGPointMake(pipeDown.size.width / 2, -pipeDown.size.height / 2)];
    pipeDown.physicsBody.dynamic = NO;
    pipeDown.physicsBody.categoryBitMask = objectGroup;
    
    SKAction *roll = [SKAction moveToX:-pipeUp.size.width duration:3];
    SKAction *remove = [SKAction removeFromParent];
    
    SKAction *pipeActions = [SKAction sequence:@[roll, remove]];
    
    [pipeUp runAction:pipeActions];
    [pipeDown runAction:pipeActions];
    
    
    
    [self addChild:pipeUp];
    [self addChild:pipeDown];

    [self performSelector:@selector(createPipes) withObject:nil afterDelay:pipeDistance];
}

@end


















