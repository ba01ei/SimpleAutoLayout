//
//  SimpleAutoLayout.swift
//  phototracer
//
//  Created by Bao Lei on 4/4/16.
//  Copyright © 2016 blei. All rights reserved.
//

import UIKit

/// Instances of SimpleAutoLayout class can be created to provide the Auto Layout helper functions.
/// Each instance has a specified superview, and automatically tracks the last subview.
open class SimpleAutoLayout: NSObject {
    var superview: UIView
    var lastItem: UIView?
    static var sharedConstraintDict: [UIView: [NSLayoutConstraint]] = [:]
    
    /// Initialize a SimpleAutoLayout object with a superview.
    public init(on superview:UIView) {
        self.superview = superview
        if SimpleAutoLayout.sharedConstraintDict[superview] == nil {
            SimpleAutoLayout.sharedConstraintDict[superview] = []
        }
    }
    
    // MARK: - Basic Placement and Alignment
    
    /// Added a view as the subview of this SimpleAutoLayout object's superview.
    /// Other than the subview to be added, all params are optional. Not passing in means on constraint on that field.
    /// @param item the subview to be added
    /// @param fromLeft the distance from this superview's left border to this subview's left border
    /// @param fromRight the distance from this superview's right border to this subview's right border
    /// @param fromTop the distance from this superview's top border to this subview's top border
    /// @param fromBottom the distance from this superview's bottom border to this subview's bottom border
    /// @param fromCenterX the distance from this superview's center X to this subview's center X
    /// @param fromCenterY the distance from this superview's center Y to this subview's center Y
    /// @param alignToLast a dictionary where keys are NSLayoutAttribute, the values are the difference between this subview's value on that attribute and the last subview's. (The last subview is the subview which we set layout constraint through SimpleAutoLayout)
    /// @param w the subview's width
    /// @param h the subview's height
    /// @param aspectRatio the subview's width/height ratio
    @discardableResult open func place(_ item: UIView,
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
            addConstraint(item, a1: .left, item2: superview, a2: .left, constant: fromLeft)
        }
        if let fromRight = fromRight {
            addConstraint(item, a1: .right, item2: superview, a2: .right, constant: -fromRight)
        }
        if let fromTop = fromTop {
            addConstraint(item, a1: .top, item2: superview, a2: .top, constant: fromTop)
        }
        if let fromBottom = fromBottom {
            addConstraint(item, a1: .bottom, item2: superview, a2: .bottom, constant: -fromBottom)
        }
        if let fromCenterX = fromCenterX {
            addConstraint(item, a1: .centerX, item2: superview, a2: .centerX, constant: fromCenterX)
        }
        if let fromCenterY = fromCenterY {
            addConstraint(item, a1: .centerY, item2: superview, a2: .centerY, constant: fromCenterY)
        }
        if let alignToLast = alignToLast {
            for (attribute, offset) in alignToLast {
                addConstraint(item, a1: attribute, item2: lastItem, a2: attribute, constant: offset)
            }
        }
        
        setAttributes(item, w: w, h: h, aspectRatio: aspectRatio)
        return self
    }
    
    /// Added a view as the subview of this SimpleAutoLayout object's superview, and place it to the right of the last subview that we added a constraint through SimpleAutoLayout.
    /// @param item the subview to be added
    /// @param distance the distance between this subview and the last subview
    /// @param w the subview's width
    /// @param h the subview's height
    /// @param aspectRatio the subview's width/height ratio
    /// @param alignToLast a dictionary where keys are NSLayoutAttribute, the values are the difference between this subview's value on that attribute and the last subview's. (The last subview is the subview which we set layout constraint through SimpleAutoLayout)
    /// @param endWithMargin if passed in, this subview will have this such distance to the right border of the superview
    @discardableResult open func goRight(_ item: UIView, _ distance: CGFloat = 0, w: CGFloat? = nil, h: CGFloat? = nil, aspectRatio: CGFloat? = nil, alignToLast: [NSLayoutAttribute: CGFloat]? = nil, endWithMargin: CGFloat? = nil) -> SimpleAutoLayout {
        add(item)
        addConstraint(item, a1: .left, item2: lastItem, a2: .right, constant:distance)
        place(item, alignToLast: alignToLast, w: w, h: h, aspectRatio: aspectRatio)
        if let endWithMargin = endWithMargin {
            addConstraint(item, a1: .right, item2: superview, a2: .right, constant: -endWithMargin)
        }
        return self
    }
    
    /// Added a view as the subview of this SimpleAutoLayout object's superview, and place it to the left of the last subview that we added a constraint through SimpleAutoLayout.
    /// @param item the subview to be added
    /// @param distance the distance between this subview and the last subview
    /// @param w the subview's width
    /// @param h the subview's height
    /// @param aspectRatio the subview's width/height ratio
    /// @param alignToLast a dictionary where keys are NSLayoutAttribute, the values are the difference between this subview's value on that attribute and the last subview's. (The last subview is the subview which we set layout constraint through SimpleAutoLayout)
    /// @param endWithMargin if passed in, this subview will have this such distance to the left border of the superview
    @discardableResult open func goLeft(_ item: UIView, _ distance: CGFloat = 0, w: CGFloat? = nil, h: CGFloat? = nil, aspectRatio: CGFloat? = nil, alignToLast: [NSLayoutAttribute: CGFloat]? = nil, endWithMargin: CGFloat? = nil) -> SimpleAutoLayout {
        add(item)
        addConstraint(item, a1: .right, item2: lastItem, a2: .left, constant:-distance)
        place(item, alignToLast: alignToLast, w: w, h: h, aspectRatio: aspectRatio)
        if let endWithMargin = endWithMargin {
            addConstraint(item, a1: .left, item2: superview, a2: .left, constant: endWithMargin)
        }
        return self
    }
    
    /// Added a view as the subview of this SimpleAutoLayout object's superview, and place it below the last subview that we added a constraint through SimpleAutoLayout.
    /// @param item the subview to be added
    /// @param distance the distance between this subview and the last subview
    /// @param w the subview's width
    /// @param h the subview's height
    /// @param aspectRatio the subview's width/height ratio
    /// @param alignToLast a dictionary where keys are NSLayoutAttribute, the values are the difference between this subview's value on that attribute and the last subview's. (The last subview is the subview which we set layout constraint through SimpleAutoLayout)
    /// @param endWithMargin if passed in, this subview will have this such distance to the bottom border of the superview
    @discardableResult open func goDown(_ item: UIView, _ distance: CGFloat = 0, w: CGFloat? = nil, h: CGFloat? = nil, aspectRatio: CGFloat? = nil, alignToLast: [NSLayoutAttribute: CGFloat]? = nil, endWithMargin: CGFloat? = nil) -> SimpleAutoLayout {
        add(item)
        addConstraint(item, a1: .top, item2: lastItem, a2: .bottom, constant: distance)
        place(item, alignToLast: alignToLast, w: w, h: h, aspectRatio: aspectRatio)
        if let endWithMargin = endWithMargin {
            addConstraint(item, a1: .bottom, item2: superview, a2: .bottom, constant: -endWithMargin)
        }
        return self
    }
    
    /// Added a view as the subview of this SimpleAutoLayout object's superview, and place it above the last subview that we added a constraint through SimpleAutoLayout.
    /// @param item the subview to be added
    /// @param distance the distance between this subview and the last subview
    /// @param w the subview's width
    /// @param h the subview's height
    /// @param aspectRatio the subview's width/height ratio
    /// @param alignToLast a dictionary where keys are NSLayoutAttribute, the values are the difference between this subview's value on that attribute and the last subview's. (The last subview is the subview which we set layout constraint through SimpleAutoLayout)
    /// @param endWithMargin if passed in, this subview will have this such distance to the top border of the superview
    @discardableResult open func goUp(_ item: UIView, _ distance: CGFloat = 0, w: CGFloat? = nil, h: CGFloat? = nil, aspectRatio: CGFloat? = nil, alignToLast: [NSLayoutAttribute: CGFloat]? = nil, endWithMargin: CGFloat? = nil) -> SimpleAutoLayout {
        add(item)
        addConstraint(item, a1: .bottom, item2: lastItem, a2: .top, constant: -distance)
        place(item, alignToLast: alignToLast, w: w, h: h, aspectRatio: aspectRatio)
        if let endWithMargin = endWithMargin {
            addConstraint(item, a1: .top, item2: superview, a2: .top, constant: endWithMargin)
        }
        return self
    }
    
    /// Reset the last item to this subview.
    /// @example We want to have A, and B, C, D are all aligned right below A, so we can do place(A).goDown(B).from(A).goDown(C).from(A).goDown(D) and B, C, D's tops will all be aligned with the bottom of A
    @discardableResult open func from(_ item: UIView) -> SimpleAutoLayout {
        lastItem = item
        return self
    }
    
    // MARK: - Setting attributes on individual items
    
    /// Set some attributes for a subview.
    /// @param w the subview's width
    /// @param h the subview's height
    /// @param aspectRatio the subview's width/height ratio
    @discardableResult open func setAttributes(_ item: UIView, w: CGFloat? = nil, h: CGFloat? = nil, aspectRatio: CGFloat? = nil) -> SimpleAutoLayout {
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
    
    /// Set the width for a subview.
    /// @param w the subview's width
    @discardableResult open func width(_ item: UIView, _ w: CGFloat) -> SimpleAutoLayout {
        addConstraint(item, a1: .width, constant:w)
        lastItem = item
        return self
    }
    
    /// Set the height for a subview.
    /// @param h the subview's height
    @discardableResult open func height(_ item: UIView, _ h: CGFloat) -> SimpleAutoLayout {
        addConstraint(item, a1: .height, constant:h)
        lastItem = item
        return self
    }
    
    /// Set the aspect ratio for a subview.
    /// @param wDividedByH the subview's width/height ratio
    @discardableResult open func aspectRatio(_ item: UIView, _ wDividedByH: CGFloat) -> SimpleAutoLayout {
        addConstraint(item, a1: .width, item2: item, a2: .height, multiplier: wDividedByH)
        lastItem = item
        return self
    }
    
    // MARK: - Under the hood (or for complex edge cases)
    
    fileprivate func add(_ view:UIView) {
        if view.superview != superview {
            superview.addSubview(view)
        }
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// Get an existing layout constraint
    /// @param item1 first item of the constraint
    /// @param a1 attribute of the first item
    /// @param item2 second item of the constraint
    /// @param a2 attribute of the second item
    @discardableResult open func constraint(_ item1: UIView, a1: NSLayoutAttribute, item2: UIView? = nil, a2: NSLayoutAttribute = .notAnAttribute) -> NSLayoutConstraint? {
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
    
    /// Add a very custom layout constraint for a subview.
    /// @param item1 first item of the constraint
    /// @param a1 attribute of the first item
    /// @param item2 second item of the constraint
    /// @param a2 attribute of the second item
    /// @param multiplier multiplier of the constraint
    /// @param constant constant of the constraint
    /// @param relation relation of the constraint
    /// @param priority priority of the constraint
    @discardableResult open func addConstraint(_ item1:UIView, a1: NSLayoutAttribute, item2: UIView? = nil, a2:NSLayoutAttribute = .notAnAttribute, multiplier:CGFloat = 1, constant:CGFloat = 0, relation:NSLayoutRelation = .equal, priority:UILayoutPriority? = nil) -> SimpleAutoLayout {
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
                if let index = SimpleAutoLayout.sharedConstraintDict[superview]?.index(of: oldConstraint) {
                    SimpleAutoLayout.sharedConstraintDict[superview]?.remove(at: index)
                }
                
                break
            }
        }
        superview.addConstraint(constraint)
        SimpleAutoLayout.sharedConstraintDict[superview]?.append(constraint)
        return self
    }
    
    // MARK: - Making changes
    
    /// Update the constant of an existing layout constaint
    /// @param item1 first item of the constraint
    /// @param a1 attribute of the first item
    /// @param item2 second item of the constraint
    /// @param a2 attribute of the second item
    /// @param newConstant the new constant value
    @discardableResult open func updateConstant(_ item1 : UIView, a1: NSLayoutAttribute, item2: UIView, a2: NSLayoutAttribute, newConstant: CGFloat) -> SimpleAutoLayout {
        constraint(item1, a1: a1, item2: item2, a2: a2)?.constant = newConstant
        return self
    }
    
    /// Make the constraint update in this run loop animated.
    /// This can be chained to one or multiple updateConstant calls.
    @discardableResult open func animate(_ duration: TimeInterval) -> SimpleAutoLayout {
        superview.setNeedsUpdateConstraints()
        UIView.animate(withDuration: duration, animations: {
            self.superview.layoutIfNeeded()
        })
        return self
    }
    
    /// Remove an existing layout constaint
    /// @param item1 first item of the constraint
    /// @param a1 attribute of the first item
    /// @param item2 second item of the constraint
    /// @param a2 attribute of the second item
    @discardableResult open func removeConstraint(_ item1: UIView, a1: NSLayoutAttribute, item2: UIView? = nil, a2: NSLayoutAttribute = .notAnAttribute) -> SimpleAutoLayout {
        for oldConstraint in superview.constraints {
            if item1 === oldConstraint.firstItem as? UIView
                && item2 === oldConstraint.secondItem as? UIView
                && a1 == oldConstraint.firstAttribute
                && a2 == oldConstraint.secondAttribute
            {
                superview.removeConstraint(oldConstraint)
                if let index = SimpleAutoLayout.sharedConstraintDict[superview]?.index(of: oldConstraint) {
                    SimpleAutoLayout.sharedConstraintDict[superview]?.remove(at: index)
                }
                break
            }
        }
        return self
    }
    
    /// Remove all existing layout constaints added through SimpleAutoLayout
    @discardableResult open func destroyAllConstraints() -> SimpleAutoLayout {
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
