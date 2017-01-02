//
//  Helper.swift
//  SimpleAutoLayoutExample
//
//  Created by Bao Lei on 4/10/16.
//  Copyright © 2016 Bao Lei. All rights reserved.
//

import UIKit

class Helper: NSObject {
    class func viewWithColor(_ color: UIColor) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        return view
    }
    
    class func makeCircleWithRadius(_ radius: CGFloat, forView view: UIView) {
        view.clipsToBounds = true
        view.layer.cornerRadius = radius
    }
    
    class func addBorder(_ color: UIColor, width: CGFloat, forView view: UIView) {
        view.layer.borderColor = color.cgColor
        view.layer.borderWidth = width
    }
    
    class func label(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        return label
    }
}
