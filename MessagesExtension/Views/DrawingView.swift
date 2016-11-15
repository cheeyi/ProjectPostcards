//
//  DrawingView.swift
//  ProjectPostcards
//
//  Created by Bryan Rahn on 11/15/16.
//  Copyright © 2016 Team ProjectPostcards. All rights reserved.
//

import Foundation
import UIKit

class DrawingView: UIView {

    private lazy var bezierPath: UIBezierPath = {
        let path = UIBezierPath()
        path.lineCapStyle = .round
        path.miterLimit = 0
        path.lineWidth = 10
        return path
    }()

    private var brushColor = UIColor.red

    private let image: UIImage?

    init(image: UIImage?) {
        self.image = image
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        guard let image = image else {
            return
        }

        image.draw(in: rect)
        brushColor.setStroke()
        bezierPath.stroke(with: .normal, alpha: 1.0)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        bezierPath.move(to: touch.location(in: self))
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        bezierPath.addLine(to: touch.location(in: self))
        setNeedsDisplay()
    }
}
