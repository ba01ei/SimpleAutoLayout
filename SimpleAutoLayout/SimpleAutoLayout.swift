//
//  SimpleAutoLayout.swift
//  phototracer
//
//  Created by Bao Lei on 4/4/16.
//  Copyright © 2016 blei. All rights reserved.
//

import UIKit

class SimpleAutoLayout: NSObject {
    var superview: UIView
    var lastItem: UIView?
    static var sharedConstraintDict: [UIView: [NSLayoutConstraint]] = [:]
    
    public init(on superview:UIView) {
        self.superview = superview
        if SimpleAutoLayout.sharedConstraintDict[superview] == nil {
            SimpleAutoLayout.sharedConstraintDict[superview] = []
        }
    }
    
    // MARK: - Basic Placement and Alignment
    
    public func place(item: UIView,
                      fromLeft: CGFloat? = nil, fromRight: CGFloat? = nil,
                      fromTop: CGFloat? = nil, fromBottom: CGFloat? = nil,
                      fromCenterX: CGFloat? = nil, fromCenterY: CGFloat? = nil,
                      alignToLast: [NSLayoutAttribute: CGFloat]? = nil,
                      w: CGFloat? = nil, h: CGFloat? = nil,
                      aspectRatio: CGFloat? = nil)
        -> SimpleAutoLayout
    {
        add(item)
        if let fromLeft = fromLeft {
            addConstraint(item, a1: .Left, item2: superview, a2: .Left, constant: fromLeft)
        }
        if let fromRight = fromRight {
            addConstraint(item, a1: .Right, item2: superview, a2: .Right, constant: -fromRight)
        }
        if let fromTop = fromTop {
            addConstraint(item, a1: .Top, item2: superview, a2: .Top, constant: fromTop)
        }
        if let fromBottom = fromBottom {
            addConstraint(item, a1: .Bottom, item2: superview, a2: .Bottom, constant: -fromBottom)
        }
        if let fromCenterX = fromCenterX {
            addConstraint(item, a1: .CenterX, item2: superview, a2: .CenterX, constant: fromCenterX)
        }
        if let fromCenterY = fromCenterY {
            addConstraint(item, a1: .CenterY, item2: superview, a2: .CenterY, constant: fromCenterY)
        }
        if let alignToLast = alignToLast {
            for (attribute, offset) in alignToLast {
                addConstraint(item, a1: attribute, item2: lastItem, a2: attribute, constant: offset)
            }
        }
        
        setAttributes(item, w: w, h: h, aspectRatio: aspectRatio)
        return self
    }
    
    public func goRight(item: UIView, _ distance: CGFloat = 0, w: CGFloat? = nil, h: CGFloat? = nil, aspectRatio: CGFloat? = nil, alignToLast: [NSLayoutAttribute: CGFloat]? = nil, endWithMargin: CGFloat? = nil) -> SimpleAutoLayout {
        add(item)
        addConstraint(item, a1: .Left, item2: lastItem, a2: .Right, constant:distance)
        place(item, alignToLast: alignToLast, w: w, h: h, aspectRatio: aspectRatio)
        if let endWithMargin = endWithMargin {
            addConstraint(item, a1: .Right, item2: superview, a2: .Right, constant: -endWithMargin)
        }
        return self
    }
    
    public func goLeft(item: UIView, _ distance: CGFloat = 0, w: CGFloat? = nil, h: CGFloat? = nil, aspectRatio: CGFloat? = nil, alignToLast: [NSLayoutAttribute: CGFloat]? = nil, endWithMargin: CGFloat? = nil) -> SimpleAutoLayout {
        add(item)
        addConstraint(item, a1: .Right, item2: lastItem, a2: .Left, constant:-distance)
        place(item, alignToLast: alignToLast, w: w, h: h, aspectRatio: aspectRatio)
        if let endWithMargin = endWithMargin {
            addConstraint(item, a1: .Left, item2: superview, a2: .Left, constant: endWithMargin)
        }
        return self
    }
    
    public func goDown(item: UIView, _ distance: CGFloat = 0, w: CGFloat? = nil, h: CGFloat? = nil, aspectRatio: CGFloat? = nil, alignToLast: [NSLayoutAttribute: CGFloat]? = nil, endWithMargin: CGFloat? = nil) -> SimpleAutoLayout {
        add(item)
        addConstraint(item, a1: .Top, item2: lastItem, a2: .Bottom, constant: distance)
        place(item, alignToLast: alignToLast, w: w, h: h, aspectRatio: aspectRatio)
        if let endWithMargin = endWithMargin {
            addConstraint(item, a1: .Bottom, item2: superview, a2: .Bottom, constant: -endWithMargin)
        }
        return self
    }
    
    public func goUp(item: UIView, _ distance: CGFloat = 0, w: CGFloat? = nil, h: CGFloat? = nil, aspectRatio: CGFloat? = nil, alignToLast: [NSLayoutAttribute: CGFloat]? = nil, endWithMargin: CGFloat? = nil) -> SimpleAutoLayout {
        add(item)
        addConstraint(item, a1: .Bottom, item2: lastItem, a2: .Top, constant: -distance)
        place(item, alignToLast: alignToLast, w: w, h: h, aspectRatio: aspectRatio)
        if let endWithMargin = endWithMargin {
            addConstraint(item, a1: .Top, item2: superview, a2: .Top, constant: endWithMargin)
        }
        return self
    }
    
    public func from(item: UIView) -> SimpleAutoLayout {
        lastItem = item
        return self
    }
    
    // MARK: - Setting attributes on individual items
    
    public func setAttributes(item: UIView, w: CGFloat? = nil, h: CGFloat? = nil, aspectRatio: CGFloat? = nil) -> SimpleAutoLayout {
        if let w = w {
            width(item, w)
        }
        if let h = h {
            height(item, h)
        }
        if let aspectRatio = aspectRatio {
            self.aspectRatio(item, aspectRatio)
        }
        lastItem = item
        return self
    }
    
    public func width(item: UIView, _ w: CGFloat) -> SimpleAutoLayout {
        addConstraint(item, a1: .Width, constant:w)
        lastItem = item
        return self
    }
    public func height(item: UIView, _ h: CGFloat) -> SimpleAutoLayout {
        addConstraint(item, a1: .Height, constant:h)
        lastItem = item
        return self
    }
    public func aspectRatio(item: UIView, _ wDividedByH: CGFloat) -> SimpleAutoLayout {
        addConstraint(item, a1: .Width, item2: item, a2: .Height, multiplier: wDividedByH)
        lastItem = item
        return self
    }
    
    // MARK: - Under the hood (or for complex edge cases)
    
    private func add(view:UIView) {
        if view.superview != superview {
            superview.addSubview(view)
        }
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public func constraint(item1: UIView, a1: NSLayoutAttribute, item2: UIView? = nil, a2: NSLayoutAttribute = .NotAnAttribute) -> NSLayoutConstraint? {
        for oldConstraint in superview.constraints {
            if item1 === oldConstraint.firstItem as? UIView
                && item2 === oldConstraint.secondItem as? UIView
                && a1 == oldConstraint.firstAttribute
                && a2 == oldConstraint.secondAttribute
            {
                return oldConstraint
            }
        }
        return nil
    }
    
    public func addConstraint(item1:UIView, a1: NSLayoutAttribute, item2: UIView? = nil, a2:NSLayoutAttribute = .NotAnAttribute, multiplier:CGFloat = 1, constant:CGFloat = 0, relation:NSLayoutRelation = .Equal, priority:UILayoutPriority? = nil) -> SimpleAutoLayout {
        let constraint = NSLayoutConstraint(item: item1, attribute: a1, relatedBy: relation, toItem: item2, attribute: a2, multiplier: multiplier, constant: constant)
        
        if let priority = priority {
            constraint.priority = priority
        }
        
        for oldConstraint in superview.constraints {
            if constraint.firstItem as? UIView == oldConstraint.firstItem as? UIView
                && constraint.secondItem as? UIView == oldConstraint.secondItem as? UIView
                && constraint.firstAttribute == oldConstraint.firstAttribute
                && constraint.secondAttribute == oldConstraint.secondAttribute
            {
                superview.removeConstraint(oldConstraint)
                if let index = SimpleAutoLayout.sharedConstraintDict[superview]?.indexOf(oldConstraint) {
                    SimpleAutoLayout.sharedConstraintDict[superview]?.removeAtIndex(index)
                }
                
                break
            }
        }
        superview.addConstraint(constraint)
        SimpleAutoLayout.sharedConstraintDict[superview]?.append(constraint)
        return self
    }
    
    // MARK: - Making changes
    
    public func updateConstant(item1 : UIView, a1: NSLayoutAttribute, item2: UIView, a2: NSLayoutAttribute, newConstant: CGFloat) -> SimpleAutoLayout {
        constraint(item1, a1: a1, item2: item2, a2: a2)?.constant = newConstant
        return self
    }
    
    public func animate(duration: NSTimeInterval) {
        superview.setNeedsUpdateConstraints()
        UIView.animateWithDuration(duration, animations: {
            self.superview.layoutIfNeeded()
        })
    }
    
    public func removeConstraint(item1: UIView, a1: NSLayoutAttribute, item2: UIView? = nil, a2: NSLayoutAttribute = .NotAnAttribute) -> SimpleAutoLayout {
        for oldConstraint in superview.constraints {
            if item1 === oldConstraint.firstItem as? UIView
                && item2 === oldConstraint.secondItem as? UIView
                && a1 == oldConstraint.firstAttribute
                && a2 == oldConstraint.secondAttribute
            {
                superview.removeConstraint(oldConstraint)
                if let index = SimpleAutoLayout.sharedConstraintDict[superview]?.indexOf(oldConstraint) {
                    SimpleAutoLayout.sharedConstraintDict[superview]?.removeAtIndex(index)
                }
                break
            }
        }
        return self
    }
    
    public func destroyAllConstraints() -> SimpleAutoLayout {
        guard let constraints = SimpleAutoLayout.sharedConstraintDict[superview] else {
            return self
        }
        for oldConstraint in constraints {
            superview.removeConstraint(oldConstraint)
        }
        // NSLog("superview removed \(constraints.count) and now has \(superview.constraints.count)")
        // NSLog("constraints left: %@", superview.constraints)
        SimpleAutoLayout.sharedConstraintDict[superview] = []
        return self
    }
}
