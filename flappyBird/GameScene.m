//
//  GameScene.m
//  flappyBird
//
//  Created by Pablo Parejo Camacho on 23/5/15.
//  Copyright (c) 2015 Pablo Parejo Camacho. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"bg"];
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    background.size = self.frame.size;
    [self addChild:background];
    
    SKSpriteNode *bird = [SKSpriteNode spriteNodeWithImageNamed:@"flappy2"];
    bird.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:bird];
    
    
    SKTexture *birdTextureUp = [SKTexture textureWithImageNamed:@"flappy1"];
    SKTexture *birdTextureDown = [SKTexture textureWithImageNamed:@"flappy2"];
    SKAction *fly = [SKAction repeatActionForever:[SKAction animateWithTextures:@[birdTextureUp, birdTextureDown] timePerFrame:0.2f]];
    
    [bird runAction:fly];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
