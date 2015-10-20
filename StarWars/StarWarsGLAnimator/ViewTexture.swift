//
//  Created by Artem Sidorenko on 10/9/15.
//  Copyright © 2015 Yalantis. All rights reserved.
//
//  Licensed under the MIT license: http://opensource.org/licenses/MIT
//  Latest version can be found at https://github.com/Yalantis/StarWars.iOS
//

import UIKit

class ViewTexture {
    var name: GLuint = 0
    var width: GLsizei = 0
    var height: GLsizei = 0
    
    func setupOpenGL() {
        glGenTextures(1, &name)
        glBindTexture(GLenum(GL_TEXTURE_2D), name)
        
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GLint(GL_LINEAR))
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GLint(GL_LINEAR))
        
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_S), GLint(GL_CLAMP_TO_EDGE))
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_T), GLint(GL_CLAMP_TO_EDGE))
        glBindTexture(GLenum(GL_TEXTURE_2D), 0);
    }
    
    deinit {
        if name != 0 {
            glDeleteTextures(1, &name)
        }
    }
    
    func renderView(view: UIView) {
        let scale = UIScreen.mainScreen().scale
        width = GLsizei(view.layer.bounds.size.width * scale)
        height = GLsizei(view.layer.bounds.size.height * scale)
        
        var texturePixelBuffer = [GLubyte](count: Int(height * width * 4), repeatedValue: 0)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        withUnsafeMutablePointer(&texturePixelBuffer[0]) { texturePixelBuffer in
            let context = CGBitmapContextCreate(texturePixelBuffer,
                Int(width), Int(height), 8, Int(width * 4), colorSpace,
                CGImageAlphaInfo.PremultipliedLast.rawValue | CGBitmapInfo.ByteOrder32Big.rawValue)!
            CGContextScaleCTM(context, scale, scale)
            
            UIGraphicsPushContext(context)
            view.drawViewHierarchyInRect(view.layer.bounds, afterScreenUpdates: false)
            UIGraphicsPopContext()
            
            glBindTexture(GLenum(GL_TEXTURE_2D), name);
            
            glTexImage2D(GLenum(GL_TEXTURE_2D), 0, GLint(GL_RGBA), width, height, 0, GLenum(GL_RGBA), GLenum(GL_UNSIGNED_BYTE), texturePixelBuffer)
            glBindTexture(GLenum(GL_TEXTURE_2D), 0);
        }
    }
}
