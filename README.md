SimpleAutoLayout
================

A super simple library for doing auto layout on iOS.

# Motivation

Like everyone is saying: no one likes interface builder. Auto Layout is hard programmatically on its own.

Previously people made things like masonry, snapkit, Stevia, etc. They are all great. SimpleAutoLayout is similar, but comes with a different flavor: it does less and tries to stay closer to the original Auto Layout APIs. It's not a DSL or a radical new way to layout views. It's just a set of chainable functions that makes using Auto Layout really simple. So it is easy to debug, and it is extremely flexible (e.g. adding any constraint, editing or removing constraints, animating a change).

# How to use

First create a SimpleAutoLayout object with a superview.

    SimpleAutoLayout(on: superview)

Then place all the subviews. One way to place a subview is to use the `place` function. Meanings of each params:

    fromLeft: distance from left border of the superview
    fromRight: distance from right border of the superview
    fromTop: distance from top border of the superview
    fromBottom: distance from bottom border of the superview
    fromCenterX: distance to this view's centerX from superview's centerX
    fromCenterY: distance to this view's centerY from superview's centerY
    alignToLast: a dictionary. key is an NSAutoLayoutAttribute, like .Left, .CenterX, value is the difference between this view's this attribute and last view's such attribute (last view is the view we placed before calling this line)
    w: width
    h: height
    aspectRatio: w/h. Only use no more than 2 of w, h, and aspectRatio to avoid a conflict. 

Another way add a subview is to use goLeft, goRight, goUp, or goDown. For example:

    SimpleAutoLayout(on: self)
        .place(label1, fromLeft: 10, fromRight: 10, fromTop: 40, w: 100)
        .goDown(label2, 30, alignToLast: [.Left: 0, .Right: 0])

means that label2 with be 30 points below label1 (.Top of label2 is 30 below .Bottom of label1), and the .Left and .Right will be the same as label1

Finally, everything translates to a set of `addConstraint` calls, which is the most basic function that can add any constraint (with item1, a1 (meaning attribute1), item2, a2, multiplier, constant, relation, priority). For anything more complicated, there is always this fallback.

And keep in mind that everything is chainable. All the functions return the same SimpleAutoLayout object.


# Example

Checkout the SimpleAutoLayoutExample folder. Run `pod install` and `open SimpleAutoLayoutExample.xcworkspace`, choose an iPhone simulator and run. Check example.png if you don't want to compile.


