//
//  UIViewExtensions.swift
//  ProjectPostcards
//
//  Created by Chee Yi Ong on 11/15/16.
//  Copyright © 2016 Team ProjectPostcards. All rights reserved.
//

import UIKit

extension UIView {

    var autolayout: Bool {
        get {
            return !translatesAutoresizingMaskIntoConstraints
        }

        set(newValue) {
            translatesAutoresizingMaskIntoConstraints = !newValue
        }
    }

    func withAutoLayout() -> Self {
        autolayout = true
        return self
    }
}

extension UIView {
    var constraintsTo: ConstraintsGenerator {
        return ConstraintsGenerator(view: self)
    }
}

// MARK: - Autolayout additions

extension UIView {

    func constraintsToFillSuperview(equalMargins margin: CGFloat) -> [NSLayoutConstraint] {
        return constraintsTo.fill(marginH: margin, marginV: margin)
    }

    func constraintsToFillSuperview(margins: UIEdgeInsets = UIEdgeInsets.zero) -> [NSLayoutConstraint] {
        return constraintsTo.fillHorizontally(leadingMargin: margins.left, trailingMargin: margins.right) +
            constraintsTo.fillVertically(topMargin: margins.top, bottomMargin: margins.bottom)
    }

    func constraintsToFillSuperview(marginH: CGFloat, marginV: CGFloat) -> [NSLayoutConstraint] {
        return constraintsTo.fillHorizontally(margins: marginH) +
            constraintsTo.fillVertically(margins: marginV)
    }

    func constraintsToFillSuperviewHorizontally(margins: CGFloat = 0) -> [NSLayoutConstraint] {
        return constraintsTo.fillHorizontally(leadingMargin: margins, trailingMargin: -margins)
    }

    func constraintsToFillSuperviewVertically(margins: CGFloat = 0) -> [NSLayoutConstraint] {
        return constraintsTo.fillVertically(topMargin: margins, bottomMargin: -margins)
    }

    func constraintsToFillSuperviewHorizontally(leadingMargin: CGFloat, trailingMargin: CGFloat) -> [NSLayoutConstraint] {
        return constraintsTo.fillHorizontally(leadingMargin: leadingMargin, trailingMargin: trailingMargin)
    }

    func constraintsToFillSuperviewVertically(topMargin: CGFloat, bottomMargin: CGFloat) -> [NSLayoutConstraint] {
        return constraintsTo.fillVertically(topMargin: topMargin, bottomMargin: bottomMargin)
    }

    func constraintsToCenterView() -> [NSLayoutConstraint] {
        return constraintsTo.centerView()
    }
}


struct ConstraintsGenerator {
    let view: UIView

    public func fill(equalMargins margin: CGFloat) -> [NSLayoutConstraint] {
        return fill(marginH: margin, marginV: margin)
    }

    public func fill(margins: UIEdgeInsets = UIEdgeInsets.zero) -> [NSLayoutConstraint] {
        return fillHorizontally(leadingMargin: margins.left, trailingMargin: margins.right) +
            fillVertically(topMargin: margins.top, bottomMargin: margins.bottom)
    }

    public func fill(marginH: CGFloat, marginV: CGFloat) -> [NSLayoutConstraint] {
        return fillHorizontally(margins: marginH) + fillVertically(margins: marginV)
    }

    public func fillHorizontally(margins: CGFloat = 0) -> [NSLayoutConstraint] {
        return fillHorizontally(leadingMargin: margins, trailingMargin: -margins)
    }

    public func fillVertically(margins: CGFloat = 0) -> [NSLayoutConstraint] {
        return fillVertically(topMargin: margins, bottomMargin: -margins)
    }

    public func fillHorizontally(leadingMargin: CGFloat, trailingMargin: CGFloat) -> [NSLayoutConstraint] {
        guard let superview = view.superview else {
            fatalError("This view does not have a superview: \(view)")
        }
        let leader = view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leadingMargin)
        let trailer = view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: trailingMargin)
        return [leader, trailer]
    }

    public func fillVertically(topMargin: CGFloat, bottomMargin: CGFloat) -> [NSLayoutConstraint] {
        guard let superview = view.superview else {
            fatalError("This view does not have a superview: \(view)")
        }
        let top = view.topAnchor.constraint(equalTo: superview.topAnchor, constant: topMargin)
        let bottom = view.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: bottomMargin)
        return [top, bottom]
    }

    public func centerView() -> [NSLayoutConstraint] {
        guard let superview = view.superview else {
            fatalError("This view does not have a superview: \(view)")
        }
        let centerX = view.centerXAnchor.constraint(equalTo: superview.centerXAnchor)
        let centerY = view.centerYAnchor.constraint(equalTo: superview.centerYAnchor)
        return [centerX, centerY]
    }
}
