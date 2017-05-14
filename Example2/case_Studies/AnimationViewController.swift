//
//  AnimationViewController.swift
//  case_Studies
//
//  Created by Isabel  Lee on 02/05/2017.
//  Copyright © 2017 isabeljlee. All rights reserved.
//

import UIKit
import StarWars

class AnimationViewController: UIViewController {

    @IBOutlet weak var circularRevealButton: UIButton!
    @IBOutlet weak var circularReverseButton: UIButton!
    @IBOutlet weak var colorChangeButton: UIButton!
    @IBOutlet weak var viewRevealButton: UIButton!
    @IBOutlet weak var viewRevertButton: UIButton!
    @IBOutlet weak var theEndButton: UIButton!
    
    @IBAction func circularReveal(_ sender: UIButton) {
        sender.layer.masksToBounds = true

        let fillLayer = CALayer()
        fillLayer.backgroundColor = UIColor.white.cgColor
        fillLayer.frame = sender.layer.bounds
        sender.layer.insertSublayer(fillLayer, at: 0)

        let center = CGPoint(x: fillLayer.bounds.midX, y: fillLayer.bounds.midY)
        let radius: CGFloat = max(sender.frame.width / 2 , sender.frame.height / 2)

        let circularAnimation = CircularRevealAnimator(layer: fillLayer, center: center, startRadius: 0, endRadius: radius)
        circularAnimation.duration = 0.2
        circularAnimation.completion = {
            fillLayer.opacity = 0
            let opacityAnimation = CABasicAnimation(keyPath: "opacity")
            opacityAnimation.fromValue = 1
            opacityAnimation.toValue = 0
            opacityAnimation.duration = 0.2
            opacityAnimation.delegate = AnimationDelegate {
                fillLayer.removeFromSuperlayer()
            }
            fillLayer.add(opacityAnimation, forKey: "opacity")
        }
        circularAnimation.start()
    }
    
    @IBAction func CircularRevert(_ sender: UIButton) {
        sender.layer.masksToBounds = true
        
        let fillLayer = CALayer()
        fillLayer.backgroundColor = UIColor.white.cgColor
        fillLayer.frame = sender.layer.bounds
        sender.layer.insertSublayer(fillLayer, at: 0)
        
        let center = CGPoint(x: fillLayer.bounds.midX, y: fillLayer.bounds.midY)
        let radius: CGFloat = max(sender.frame.width / 2 , sender.frame.height / 2)
        
        let circularAnimation = CircularRevealAnimator(layer: fillLayer, center: center, startRadius: radius, endRadius: 0)
        circularAnimation.duration = 0.2
        circularAnimation.completion = {
            fillLayer.opacity = 0
            let opacityAnimation = CABasicAnimation(keyPath: "opacity")
            opacityAnimation.fromValue = 1
            opacityAnimation.toValue = 0
            opacityAnimation.duration = 0.2
            opacityAnimation.delegate = AnimationDelegate {
                fillLayer.removeFromSuperlayer()
            }
            fillLayer.add(opacityAnimation, forKey: "opacity")
        }
        circularAnimation.start()
    }
    
    @IBAction func colorChange(_ sender: UIButton) {
        sender.layer.masksToBounds = true
        
        let fillLayer = CALayer()
        fillLayer.backgroundColor = UIColor.white.cgColor
        fillLayer.frame = sender.layer.bounds
        sender.layer.insertSublayer(fillLayer, at: 0)
        
        let center = CGPoint(x: fillLayer.bounds.midX, y: fillLayer.bounds.midY)
        let radius: CGFloat = max(sender.frame.width / 2 , sender.frame.height / 2)
        
        let circularAnimation = CircularRevealAnimator(layer: fillLayer, center: center, startRadius: 0, endRadius: radius)
        circularAnimation.duration = 0.2
        circularAnimation.completion = {
            fillLayer.removeFromSuperlayer()
            sender.backgroundColor = UIColor.white
        }
        circularAnimation.start()
    }
    
    @IBAction func viewReveal(_ sender: UIButton) {
        self.view.animateCircular(withDuration: 0.5, center: sender.center, revert: false, animations: {
            self.backgroundImageView.image = UIImage(named: "background")
            self.circularRevealButton.backgroundColor = UIColor.white
            self.circularReverseButton.backgroundColor = UIColor.black
            self.colorChangeButton.backgroundColor = UIColor.white
            self.viewRevealButton.backgroundColor = UIColor.black
            self.viewRevertButton.backgroundColor = UIColor.white
            self.theEndButton.backgroundColor = UIColor.black
        })
    }
    
    @IBAction func viewRevert(_ sender: UIButton) {
        self.view.animateCircular(withDuration: 0.5, center: sender.center, revert: true, animations: {
            self.backgroundImageView.image = UIImage(named: "background2")
            self.circularRevealButton.backgroundColor = UIColor.black
            self.circularReverseButton.backgroundColor = UIColor.white
            self.colorChangeButton.backgroundColor = UIColor.black
            self.viewRevealButton.backgroundColor = UIColor.white
            self.viewRevertButton.backgroundColor = UIColor.black
            self.theEndButton.backgroundColor = UIColor.white
        })
    }
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
