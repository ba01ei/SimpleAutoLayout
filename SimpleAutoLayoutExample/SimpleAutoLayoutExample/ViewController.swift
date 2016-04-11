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
    let red = Helper.viewWithColor(UIColor.redColor())
    let white = Helper.viewWithColor(UIColor.whiteColor())
    let blue = Helper.viewWithColor(UIColor.blueColor())
    
    let bearCanvas = Helper.viewWithColor(UIColor.whiteColor())
    let bearHead = Helper.viewWithColor(UIColor.brownColor())
    let leftEar = Helper.viewWithColor(UIColor.brownColor())
    let rightEar = Helper.viewWithColor(UIColor.brownColor())
    let leftEye = Helper.viewWithColor(UIColor.blackColor())
    let rightEye = Helper.viewWithColor(UIColor.blackColor())
    let nose = Helper.viewWithColor(UIColor.blackColor())
    
    let line = Helper.viewWithColor(UIColor.lightGrayColor())
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
    
    private func layoutFlag() {
        SimpleAutoLayout(on: self.view)
            .place(flag, fromLeft: 20, fromRight: 20, fromTop: 40, aspectRatio: 2)
            .place(blue, alignToLast: [.Left: 1, .Top: 1, .Bottom: 1])
            .addConstraint(blue, a1: .Width, item2: flag, a2: .Width, multiplier: 1/3)
            .goRight(white, alignToLast: [.Top: 0, .Bottom: 0, .Width: 0])
            .goRight(red, alignToLast: [.Top: 0, .Bottom: 0, .Width: 0])
    }
    
    private func layoutBear() {
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
        
        Helper.addBorder(UIColor.whiteColor(), width: 5, forView: leftEye)
        Helper.addBorder(UIColor.whiteColor(), width: 5, forView: rightEye)
        
        label4.textAlignment = .Right
        
        SimpleAutoLayout(on: self.view)
            .from(flag)
            .goDown(bearCanvas, 20, alignToLast: [.Width: 0, .CenterX: 0], aspectRatio: 1)
        SimpleAutoLayout(on: bearCanvas)
            .place(bearHead, fromCenterX: 0, fromCenterY: 0, w: bearHeadRadius*2, aspectRatio: 1)
            .place(leftEar, alignToLast: [.Left: 0, .Top: -20], w: bearEarRadius*2, aspectRatio: 1)
            .from(bearHead)
            .place(rightEar, alignToLast: [.Right: 0, .Top: -20], w: bearEarRadius*2, aspectRatio: 1)
            .from(bearHead)
            .place(nose, alignToLast: [.CenterX: 0, .CenterY: 30], w: bearNoseRadius*2, aspectRatio: 1)
            .goLeft(leftEye, noseEyeHorizontalDistance - bearNoseRadius, alignToLast: [.CenterY: -60], w: bearEyeRadius*2, aspectRatio: 1)
            .goRight(rightEye, noseEyeHorizontalDistance*2, alignToLast: [.CenterY: 0, .Width: 0, .Height: 0])
        
            .from(bearHead)
            .goDown(line, 20, h: 1)
            .place(line, fromLeft: 10, fromRight: 10)
            .goDown(label1, 5, alignToLast: [.Left: 0])
            .goRight(label2, 5, alignToLast: [.CenterY: 0])
            .goRight(label3, 5, alignToLast: [.CenterY: 0])
            .place(label4, fromRight: 10, alignToLast: [.CenterY: 0])
    }
}

