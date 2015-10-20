//
//  Created by Artem Sidorenko on 10/8/15.
//  Copyright © 2015 Yalantis. All rights reserved.
//
//  Licensed under the MIT license: http://opensource.org/licenses/MIT
//  Latest version can be found at https://github.com/Yalantis/StarWars.iOS
//

import GLKit

class BlowSpriteRender {
    
    private let texture: ViewTexture
    private let effect: GLKBaseEffect
    
    init(texture: ViewTexture, effect: GLKBaseEffect) {
        self.texture = texture
        self.effect = effect
    }
    
    func render(sprites: [BlowSprite]) {
        effect.texture2d0.name = self.texture.name
        effect.texture2d0.enabled = 1
        
        effect.prepareToDraw()
        
        var vertex = sprites.map { $0.quad }
        
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.Position.rawValue))
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.TexCoord0.rawValue))
        
        withUnsafePointer(&vertex[0].bl.geometryVertex) { offset in
            glVertexAttribPointer(GLuint(GLKVertexAttrib.Position.rawValue), 2, GLenum(GL_FLOAT), GLboolean(UInt8(GL_FALSE)), GLsizei(sizeof(TexturedVertex)), offset)
        }
        withUnsafePointer(&vertex[0].bl.textureVertex) { offset in
            glVertexAttribPointer(GLuint(GLKVertexAttrib.TexCoord0.rawValue), 2, GLenum(GL_FLOAT), GLboolean(UInt8(GL_FALSE)), GLsizei(sizeof(TexturedVertex)), offset)
        }

        glDrawArrays(GLenum(GL_TRIANGLES), 0, GLsizei(vertex.count * 6))
    }
    
}
