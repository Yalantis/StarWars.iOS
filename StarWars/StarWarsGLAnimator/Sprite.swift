//
//  Created by Artem Sidorenko on 10/8/15.
//  Copyright © 2015 Yalantis. All rights reserved.
//
//  Licensed under the MIT license: http://opensource.org/licenses/MIT
//  Latest version can be found at https://github.com/Yalantis/StarWars.iOS
//

import GLKit

struct TexturedVertex {
    var geometryVertex = Vector2()
    var textureVertex = Vector2()
}

struct TexturedQuad {
    var bl = TexturedVertex()
    var br = TexturedVertex() { didSet { _br = br } }
    var tl = TexturedVertex() { didSet { _tl = tl } }
    var tr = TexturedVertex()
    
    // openGL optimization. it uses triangles to draw.
    // so we duplicate 2 vertex, so it have 6 vertex to draw two triangles
    fileprivate var _br = TexturedVertex()
    fileprivate var _tl = TexturedVertex()
}

struct Sprite {
    var quad = TexturedQuad()
    var moveVelocity = Vector2()
    
    mutating func slice(_ rect: CGRect, textureSize: CGSize) {
        quad.bl.geometryVertex = Vector2(x: 0, y: 0)
        quad.br.geometryVertex = Vector2(x: rect.size.width, y: 0)
        quad.tl.geometryVertex = Vector2(x: 0, y: rect.size.height)
        quad.tr.geometryVertex = Vector2(x: rect.size.width, y: rect.size.height)
        
        quad.bl.textureVertex = Vector2(x: rect.origin.x / textureSize.width, y: rect.origin.y / textureSize.height)
        quad.br.textureVertex = Vector2(x: (rect.origin.x + rect.size.width) / textureSize.width, y: rect.origin.y / textureSize.height)
        quad.tl.textureVertex = Vector2(x: rect.origin.x / textureSize.width, y: (rect.origin.y + rect.size.height) / textureSize.height)
        quad.tr.textureVertex = Vector2(x: (rect.origin.x + rect.size.width) / textureSize.width, y: (rect.origin.y + rect.size.height) / textureSize.height)
        
        position += Vector2(rect.origin)
    }
    
    var position = Vector2() {
        didSet {
            let diff = position - oldValue
            quad.bl.geometryVertex += diff
            quad.br.geometryVertex += diff
            quad.tl.geometryVertex += diff
            quad.tr.geometryVertex += diff
        }
    }
    
    mutating func update(_ tick: TimeInterval) {
        position += moveVelocity * Float32(tick)
    }

}
