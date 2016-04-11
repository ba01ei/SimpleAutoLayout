SimpleAutoLayout
================

A super simple library for doing Auto Layout on iOS.

# Motivation

Like everyone said: no one likes Interface Builder. Doing Auto Layout programmatically is hard on its own.

Previously people made things like Masonry, Snapkit, Stevia, etc. They are all great. SimpleAutoLayout is similar, but comes with a different flavor: it does less magic and tries to stay closer to the original Auto Layout APIs.

It's not a DSL or a radical new way to think about layouts. It's just a set of chainable functions that makes using Auto Layout really simple. So it is easy to debug, and it is extremely flexible (e.g. adding any constraint, editing or removing constraints, animating a change).

# How to use

## Quick Start Guide

To layout viewA (100x100), viewB (100x100), viewC (100x100) horizontally (left margin, gap = 10), and inside viewC have viewD (40x40) and viewE (40x40) aligned vertically (top margin, gap = 10):

    SimpleAutoLayout(superview: self.view)
        .place(viewA, fromLeft: 10, fromTop: 10, w: 100, h: 100)
        .goRight(viewB, 10, alignToLast: [.Width: 0, .Top: 0, .Bottom: 0])
        .goRight(viewC, 10, alignToLast: [.Width: 0, .Top: 0, .Bottom: 0])
        .place(viewD, alignToLast: [.Top: 10, .CenterX: 0], w: 40, h: 40)
        .goDown(viewE, 10, alignToLast: [.Left: 0, .Right: 0, .Height: 0])

(No need to call superview.addSubview(viewA) or set translatesAutoresizingMaskIntoConstraints. This is it.)

## Details

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

Another way add a subview is to use `goLeft`, `goRight`, `goUp`, or `goDown`. For example:

    SimpleAutoLayout(on: self)
        .place(label1, fromLeft: 10, fromRight: 10, fromTop: 40, w: 100)
        .goDown(label2, 30, alignToLast: [.Left: 0, .Right: 0])

means that label2 with be 30 points below label1 (.Top of label2 is 30 below .Bottom of label1), and the .Left and .Right will be the same as label1

Also there is a `from` function that resets the last view. So if viewB and viewC are both right below viewA, you can do

    .place(viewA, ...)
    .goDown(viewB, distance, ...)
    .from(viewA).goDown(viewC, distance, ...)

Finally, everything translates to a set of `addConstraint` calls, which is the most basic function that can add any constraint (with item1, a1 (meaning attribute1), item2, a2, multiplier, constant, relation, priority). For anything more complicated, there is always this fallback.

And keep in mind that everything is chainable. All the functions return the same SimpleAutoLayout object.


# Example

Checkout [SimpleAutoLayoutExample](SimpleAutoLayoutExample/SimpleAutoLayoutExample/ViewController.swift). Go to `SimpleAutoLayoutExample` folder, run `pod install` and `open SimpleAutoLayoutExample.xcworkspace`, choose an iPhone simulator and run. 

The layout result:

![example.png](https://raw.githubusercontent.com/ba01ei/SimpleAutoLayout/master/example.png)


# still not 100% convinced?

Also checkout [SimpleAutoLayout.swift](SimpleAutoLayout/SimpleAutoLayout.swift) to see how few lines it takes. Because how SimpleAutoLayout library itself is simple short, simple, and straightforward, it's extremely easy to debug when something is unexpected. And the library itself is unlikely to cause any new complexity or issue.

And also because of that, it's highly unlikely this is going to go out of maintenance. (Unless Apple discontinued Auto Layout completely) 

I've tried to quickly build a simple app in a few days (to be published to App Store in the future after more polishing) to make sure it really handles a lot of real world design examples that are rather complex. And with SimpleAutoLayout it can be down really fast.

Some other Auto Layout syntax sugars are also cool, but this one allows you to handle most of the views with 1 view/line (even the `addSubview` call is handled by that 1 call). (For example, if you are placing a number of views horizontally, when you call goRight on each view you can also set the vertical alignment, width, height, etc in the same function call.) There's something nice about having all the layout attributes of one view in one place (or one line), e.g. you can easily comment out a view, or move it to a different file.


