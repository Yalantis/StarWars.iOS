//
//  Created by Artem Sidorenko on 10/9/15.
//  Copyright © 2015 Yalantis. All rights reserved.
//
//  Licensed under the MIT license: http://opensource.org/licenses/MIT
//  Latest version can be found at https://github.com/Yalantis/StarWars.iOS
//

import UIKit

struct Vector2 {
    
    var x : Float32 = 0.0
    var y : Float32 = 0.0
    
    init() {
        
        x = 0.0
        y = 0.0
    }
    
    init(value: Float32) {
    
        x = value
        y = value
    }
    
    init(x: Float32 ,y: Float32) {
        
        self.x = x
        self.y = y
    }
    
    init(x: CGFloat, y: CGFloat) {
        self.init(x: Float32(x), y: Float32(y))
    }
    
    init(x: Int, y: Int) {
        self.init(x: Float32(x), y: Float32(y))
    }
    
    init(other: Vector2) {
    
        x = other.x
        y = other.y
    }
    
    init(_ other: CGPoint) {
        x = Float32(other.x)
        y = Float32(other.y)
    }
}

extension Vector2: CustomStringConvertible {
    
    var description: String { return "[\(x),\(y)]" }
}

extension Vector2 : Equatable {
    
    func isFinite() -> Bool {
    
        return x.isFinite && y.isFinite
    }

    func distance(other: Vector2) -> Float32 {
        
        let result = self - other;
        return sqrt( result.dot(result) )
    }
    
    mutating func normalize() {
        
        let m = magnitude()
        
        if m > 0 {
            
            let il:Float32 = 1.0 / m
            
            x *= il
            y *= il
        }
    }
    
    func magnitude() -> Float32 {
        
        return sqrtf( x*x + y*y )
    }
    
    func dot( v: Vector2 ) -> Float32 {
        
        return x * v.x + y * v.y
    }
    
    mutating func lerp( a: Vector2, b: Vector2, coef : Float32) {
        
        let result = a + ( b - a) * coef
        
        x = result.x
        y = result.y
    }
}

func ==(lhs: Vector2, rhs: Vector2) -> Bool {

    return (lhs.x == rhs.x) && (lhs.y == rhs.y)
}

func * (left: Vector2, right : Float32) -> Vector2 {
    
    return Vector2(x:left.x * right, y:left.y * right)
}

func * (left: Vector2, right : Vector2) -> Vector2 {
    
    return Vector2(x:left.x * right.x, y:left.y * right.y)
}

func / (left: Vector2, right : Float32) -> Vector2 {
    
    return Vector2(x:left.x / right, y:left.y / right)
}

func / (left: Vector2, right : Vector2) -> Vector2 {
    
    return Vector2(x:left.x / right.x, y:left.y / right.y)
}

func + (left: Vector2, right: Vector2) -> Vector2 {
    
    return Vector2(x:left.x + right.x, y:left.y + right.y)
}

func - (left: Vector2, right: Vector2) -> Vector2 {
    
    return Vector2(x:left.x - right.x, y:left.y - right.y)
}

func + (left: Vector2, right: Float32) -> Vector2 {
    
    return Vector2(x:left.x + right, y:left.y + right)
}

func - (left: Vector2, right: Float32) -> Vector2 {
    
    return Vector2(x:left.x - right, y:left.y - right)
}

func += (inout left: Vector2, right: Vector2) {
    
    left = left + right
}

func -= (inout left: Vector2, right: Vector2) {
    
    left = left - right
}

func *= (inout left: Vector2, right: Vector2) {
    
    left = left * right
}

func /= (inout left: Vector2, right: Vector2) {
    
    left = left / right
}

