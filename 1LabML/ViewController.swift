//
//  ViewController.swift
//  1LabML
//
//  Created by Igor Grankin on 16/10/2018.
//  Copyright © 2018 Igor Grankin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var canvasView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    
    private var lastPoint: CGPoint!
    private let perceptron = Perceptron()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lastPoint = CGPoint.zero
        canvasView.isUserInteractionEnabled = true
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        canvasView.addGestureRecognizer(gesture)
        
        perceptron.prepareWeights()
    }
    
    @objc func handleGesture(_ panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.location(in: panGesture.view!)
        switch panGesture.state {
        case .began:
            lastPoint = translation
        case .changed:
            drawLine(from: lastPoint, to: translation)
            lastPoint = translation
            UIGraphicsEndImageContext()
        case .cancelled:
            drawLine(from: lastPoint, to: lastPoint)
            UIGraphicsEndImageContext()
        case .ended:
            drawLine(from: lastPoint, to: lastPoint)
            UIGraphicsEndImageContext()
        default:
            break
        }
    }
    
    func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
        UIGraphicsBeginImageContext(canvasView.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        canvasView.image?.draw(in: canvasView.bounds)
        context.move(to: fromPoint)
        context.addLine(to: toPoint)
        context.setLineCap(.round)
        context.setBlendMode(.normal)
        context.setLineWidth(7.0)
        context.setStrokeColor(UIColor.red.cgColor)
        context.strokePath()
        canvasView.image = UIGraphicsGetImageFromCurrentImageContext()
        
    }
    
    func rasterize() {
        UIGraphicsBeginImageContext(CGSize(width: 100, height: 100))
        canvasView.image?.draw(in: CGRect(x: 0, y: 0, width: 100, height: 100))
        canvasView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    @IBAction func calculatePixels(_ sender: Any) {
        rasterize()
        let output = canvasView.image?.pixelValues()
        //        print(output?.pixelValues, output?.width, output?.height)
        perceptron.inputs = (output?.pixelValues)!
        let result = perceptron.activateFunction()
        //        print(result)
        resultLabel.text = result.rawValue
    }
    
    @IBAction func charApressed(_ sender: Any) {
        perceptron.learnThatCurrentImage(is: .characterA)
    }
    
    @IBAction func char9Pressed(_ sender: Any) {
        perceptron.learnThatCurrentImage(is: .number9)
    }
    
    @IBAction func clearPressed(_ sender: Any) {
        canvasView.image = nil
        resultLabel.text = "-"
    }
    
    @IBAction func clearWeightsPressed(_ sender: Any) {
        perceptron.clearWeights()
    }
    
    @IBAction func saveWeightsPressed(_ sender: Any) {
        perceptron.saveWeights()
    }
}

