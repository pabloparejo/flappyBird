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
static UInt32 gapGroup = 1 << 2; // 0010

@interface GameScene() <SKPhysicsContactDelegate>

@property (strong, nonatomic) SKSpriteNode *bird;
@property (strong, nonatomic) SKNode *movingObjects;
@property (strong, nonatomic) SKLabelNode *gameOver;
@property (strong, nonatomic) SKLabelNode *scoreLabel;

@property (nonatomic) BOOL isAlive;
@property (nonatomic) int score;

@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    
    self.physicsWorld.gravity = CGVectorMake(0, -14);
    self.physicsWorld.contactDelegate = self;
    
    self.movingObjects = [[SKNode alloc] init];
    
    [self initGame];
}

-(void) initGame{
    self.isAlive = YES;
    self.score = 0;
    [self removeAllChildren];
    [self.movingObjects removeAllChildren];
    [self addChild:self.movingObjects];
    [self createBg];
    [self createFloor];
    [self createScore];
    self.movingObjects.speed = 1;
    
    // Start game after 3 seconds
    [self performSelector:@selector(createBird) withObject:nil afterDelay:0.5];
    [self performSelector:@selector(createPipes) withObject:nil afterDelay:2];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.isAlive) {
        [super touchesBegan:touches withEvent:event];
        [self.bird.physicsBody applyImpulse:CGVectorMake(0, 200)];
    }else{
        //reset game
        [self initGame];
    }
    
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

-(void) createBird{
    self.bird = [SKSpriteNode spriteNodeWithImageNamed:@"flappy2"];
    self.bird.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-100);
    self.bird.zPosition = 10;
    
    self.bird.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.bird.size.width / 2];
    self.bird.physicsBody.dynamic = YES;
    self.bird.physicsBody.categoryBitMask = birdGroup;
    self.bird.physicsBody.collisionBitMask = objectGroup;
    self.bird.physicsBody.contactTestBitMask = objectGroup | gapGroup;
    
    self.bird.physicsBody.allowsRotation = NO;
    
    
    SKTexture *birdTextureUp = [SKTexture textureWithImageNamed:@"flappy1"];
    SKTexture *birdTextureDown = [SKTexture textureWithImageNamed:@"flappy2"];
    SKAction *fly = [SKAction repeatActionForever:[SKAction animateWithTextures:@[birdTextureUp, birdTextureDown] timePerFrame:0.4f]];
    
    SKAction *floatUp = [SKAction moveByX:0 y:2 duration:.4];
    SKAction *floatDown = [SKAction moveByX:0 y:-2 duration:.4];
    
    SKAction *birdActions = [SKAction repeatActionForever:[SKAction sequence:@[floatDown, floatUp]]];
    
    [self.bird runAction:fly];
    [self.bird runAction:birdActions];
    
    [self.movingObjects addChild:self.bird];
    [self.bird.physicsBody applyImpulse:CGVectorMake(0, 300)];
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
    
    
    [self.movingObjects addChild:bg1];
    [self.movingObjects addChild:bg2];
}

-(void) createFloor{
    SKNode *floor = [[SKNode alloc] init];
    floor.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width, 1) center:CGPointMake(CGRectGetMidX(self.frame), 0)];
    floor.physicsBody.dynamic = NO;
    floor.physicsBody.categoryBitMask = objectGroup;
    
    [self addChild:floor];
}

-(void) createPipes{
    if (self.isAlive) {
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
        
        SKSpriteNode *gapNode = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(pipeUp.size.width, gap)];
        gapNode.anchorPoint = CGPointMake(0,1);
        gapNode.position = pipeUp.position;
        gapNode.zPosition = 100;
        
        gapNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:gapNode.size center:CGPointMake(gapNode.size.width / 2, -gapNode.size.height/2)];
        gapNode.physicsBody.dynamic = NO;
        gapNode.physicsBody.categoryBitMask = gapGroup;
        
        SKAction *roll = [SKAction moveToX:-pipeUp.size.width duration:3];
        SKAction *remove = [SKAction removeFromParent];
        
        SKAction *pipeActions = [SKAction sequence:@[roll, remove]];
        
        [pipeUp runAction:pipeActions];
        [pipeDown runAction:pipeActions];
        [gapNode runAction:pipeActions];
        
        
        [self.movingObjects addChild:pipeUp];
        [self.movingObjects addChild:pipeDown];
        [self.movingObjects addChild:gapNode];
        
        [self performSelector:@selector(createPipes) withObject:nil afterDelay:pipeDistance];
    }
}

-(void) createScore{
    self.scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    self.scoreLabel.zPosition = 100;
    self.scoreLabel.fontColor = [UIColor whiteColor];
    self.scoreLabel.fontSize = 60.0f;
    self.scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) - 60);
    self.scoreLabel.text = @"0";
    [self addChild:self.scoreLabel];
}

#pragma mark - SKPhysicsContactDelegate

-(void) didBeginContact:(SKPhysicsContact *)contact{
    if ((contact.bodyA.categoryBitMask == gapGroup || contact.bodyB.categoryBitMask == gapGroup) && self.isAlive) {
        self.score += 1;
        self.scoreLabel.text = [NSString stringWithFormat:@"%d", self.score];
    }else{
        self.isAlive = NO;
        self.movingObjects.speed = 0;
        self.gameOver = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        self.gameOver.zPosition = 100;
        self.gameOver.fontColor = [UIColor whiteColor];
        self.gameOver.fontSize = 40.0f;
        self.gameOver.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        self.gameOver.text = @"Game Over";
        [self addChild:self.gameOver];
    }
}

@end


















