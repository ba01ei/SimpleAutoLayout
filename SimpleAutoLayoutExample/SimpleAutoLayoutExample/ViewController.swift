//
//  ViewController.swift
//  SimpleAutoLayoutExample
//
//  Created by Bao Lei on 4/10/16.
//  Copyright © 2016 Bao Lei. All rights reserved.
//

import SimpleAutoLayout

class ViewController: UIViewController {

    let flag = UIView()
    let red = Helper.viewWithColor(UIColor.red)
    let white = Helper.viewWithColor(UIColor.white)
    let blue = Helper.viewWithColor(UIColor.blue)
    
    let bearCanvas = Helper.viewWithColor(UIColor.white)
    let bearHead = Helper.viewWithColor(UIColor.brown)
    let leftEar = Helper.viewWithColor(UIColor.brown)
    let rightEar = Helper.viewWithColor(UIColor.brown)
    let leftEye = Helper.viewWithColor(UIColor.black)
    let rightEye = Helper.viewWithColor(UIColor.black)
    let nose = Helper.viewWithColor(UIColor.black)
    
    let line = Helper.viewWithColor(UIColor.lightGray)
    let label1 = Helper.label("Simple")
    let label2 = Helper.label("Auto")
    let label3 = Helper.label("Layout")
    let label4 = Helper.label("🐼")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        layoutFlag()
        layoutBear()
    }
    
    fileprivate func layoutFlag() {
        SimpleAutoLayout(on: self.view)
            .place(flag, from: [.left: 20, .right: 20, .top: 40], size: [.aspectRatio: 2], safeAreaEdges: [.top])
            .place(blue, alignToLast: [.left: 1, .top: 1, .bottom: 1])
            .addConstraint(blue, a1: .width, item2: flag, a2: .width, multiplier: 1/3)
            .goRight(white, alignToLast: [.top: 0, .bottom: 0, .width: 0])
            .goRight(red, alignToLast: [.top: 0, .bottom: 0, .width: 0])
    }
    
    fileprivate func layoutBear() {
        let bearEarRadius: CGFloat = 40
        let bearEyeRadius: CGFloat = 15
        let bearNoseRadius: CGFloat = 30
        let bearHeadRadius: CGFloat = 100
        let noseEyeHorizontalDistance: CGFloat = 20
        
        Helper.makeCircleWithRadius(bearHeadRadius, forView: bearHead)
        Helper.makeCircleWithRadius(bearEarRadius, forView: leftEar)
        Helper.makeCircleWithRadius(bearEarRadius, forView: rightEar)
        Helper.makeCircleWithRadius(bearEyeRadius, forView: leftEye)
        Helper.makeCircleWithRadius(bearEyeRadius, forView: rightEye)
        Helper.makeCircleWithRadius(bearNoseRadius, forView: nose)
        
        Helper.addBorder(UIColor.white, width: 5, forView: leftEye)
        Helper.addBorder(UIColor.white, width: 5, forView: rightEye)
        
        label4.textAlignment = .right
        
        SimpleAutoLayout(on: self.view)
            .from(flag)
            .goDown(bearCanvas, distance: 20, size: [.aspectRatio: 1], alignToLast: [.width: 0, .centerX: 0])
        SimpleAutoLayout(on: bearCanvas)
            .place(bearHead, from: [.centerX: 0, .centerY: 0], size: [.w: bearHeadRadius*2, .aspectRatio: 1])
            .place(leftEar, size: [.w: bearEarRadius*2, .aspectRatio: 1], alignToLast: [.left: 0, .top: -20])
            .from(bearHead)
            .place(rightEar, size: [.w: bearEarRadius*2, .aspectRatio: 1], alignToLast: [.right: 0, .top: -20])
            .from(bearHead)
            .place(nose, size: [.w: bearNoseRadius*2, .aspectRatio: 1], alignToLast: [.centerX: 0, .centerY: 30])
            .goLeft(leftEye, distance: noseEyeHorizontalDistance - bearNoseRadius, size: [.w: bearEyeRadius*2, .aspectRatio: 1], alignToLast: [.centerY: -60])
            .goRight(rightEye, distance: noseEyeHorizontalDistance*2, alignToLast: [.centerY: 0, .width: 0, .height: 0])
        
            .from(bearHead)
            .goDown(line, distance: 20, size: [.h: 1])
            .place(line, from: [.left: 10, .right: 10])
            .goDown(label1, distance: 5, alignToLast: [.left: 0])
            .goRight(label2, distance: 5, alignToLast: [.centerY: 0])
            .goRight(label3, distance: 5, alignToLast: [.centerY: 0])
            .place(label4, from: [.right: 10], alignToLast: [.centerY: 0])
    }
}

