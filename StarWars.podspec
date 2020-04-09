Pod::Spec.new do |s|

  s.name         = "StarWars"
  s.version      = "4.0"
  s.summary      = "This component implements transition animation to crumble view-controller into tiny pieces"

  s.homepage     = "https://yalantis.com/blog/uidynamics-uikit-or-opengl-3-types-of-ios-animations-for-the-star-wars/"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = "Yalantis"
  s.social_media_url   = "https://twitter.com/yalantis"

  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "8.0"


  s.source       = { :git => "https://github.com/Yalantis/StarWars.iOS.git", :tag => s.version }
  s.source_files = "StarWars/StarWarsGLAnimator/*.swift"
  s.module_name  = "StarWars"
  s.requires_arc = true

end
