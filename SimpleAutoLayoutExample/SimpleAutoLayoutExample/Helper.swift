//
//  Helper.swift
//  SimpleAutoLayoutExample
//
//  Created by Bao Lei on 4/10/16.
//  Copyright © 2016 Bao Lei. All rights reserved.
//

import UIKit

class Helper: NSObject {
    class func viewWithColor(color: UIColor) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        return view
    }
    
    class func makeCircleWithRadius(radius: CGFloat, forView view: UIView) {
        view.clipsToBounds = true
        view.layer.cornerRadius = radius
    }
    
    class func addBorder(color: UIColor, width: CGFloat, forView view: UIView) {
        view.layer.borderColor = color.CGColor
        view.layer.borderWidth = width
    }
    
    class func label(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        return label
    }
}
