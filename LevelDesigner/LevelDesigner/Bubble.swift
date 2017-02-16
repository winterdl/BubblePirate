//
//  Bubble.swift
//  LevelDesigner
//
//  Created by limte on 1/2/17.
//  Copyright © 2017 nus.cs3217.a0101010. All rights reserved.
//

import Foundation
import UIKit

class Bubble: GameObject {
    enum MoveState {
        case idle
        case move
        case snap
    }

    public var velocity: CGVector
    private var snapToPos: CGVector = CGVector.init()
    public var moveState = MoveState.idle
    public var delegate: BubbleDelegate?
    
    init(_ position: CGVector) {
        velocity = CGVector(0, 0)
        super.init()
        self.position = position
    }
    
    public override func update(_ deltaTime: CGFloat) {
        switch moveState {
        case .idle:
            isStatic = true
            break
            
        case .move:
            position = position + (velocity * deltaTime)
            isStatic = false
            
        case .snap:
            position = snapToPos
            moveState = MoveState.idle
            delegate?.onBubbleDoneSnapping(self)
        }
    }
    
    public func setVelocity(_ velocity: CGVector) {
        if velocity == CGVector(0, 0) {
            self.velocity = velocity
            moveState = MoveState.idle
        } else {
            moveState = MoveState.move
            self.velocity = velocity
        }
    }

    public override func onCollide(_ other: GameObject) {
        guard other is Bubble else {
            return
        }
        if moveState == MoveState.move {
            delegate?.onBubbleCollidedWithBubble(self)
        }
    }
    
    public override func onCollideWithLeftWorldBound() {
        flipXVelocity()
    }
    
    public override func onCollideWithRightWorldBound() {
        flipXVelocity()
    }
    
    public override func onCollideWithTopWorldBound() {
        if moveState == MoveState.move {
            delegate?.onBubbleCollidedWithTopWall(self)
        }
    }

    private func flipXVelocity() {
        velocity = CGVector(velocity.x * -1, velocity.y)
    }
    
    public func snapTo(_ position: CGVector) {
        snapToPos = position
        moveState = MoveState.snap
    }
    
    public func isSameColor(_ other: Bubble) -> Bool {
        guard let sprite1 = spriteComponent else {
            return false
        }
        guard let sprite2 = other.spriteComponent else {
            return false
        }
        return sprite1.spriteName == sprite2.spriteName
    }
}