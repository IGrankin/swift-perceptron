//
//  Perceptron.swift
//  1LabML
//
//  Created by Igor Grankin on 17/10/2018.
//  Copyright © 2018 Igor Grankin. All rights reserved.
//

import Foundation

class Perceptron {
    
    enum PredictedSymbol: String {
        case characterA = "A"
        case number9 = "9"
    }
    
    var weights: [Double] = []
    public var inputs: [UInt8] = []
    private let eduSpeed = 0.7
    var activationFunctionLastResult: UInt8!
    
    init() {}
    
    func prepareWeights() {
        let array: [Double]? = UserDefaults.standard.object(forKey: "mlLab.weightsArray") as? [Double]
        if array == nil {
            for _ in 0..<10000 {
                weights.append(Double.random(in: -0.3...0.3))
            }
        } else {
            weights = array!
        }
    }
    
    func saveWeights() {
        UserDefaults.standard.set(weights, forKey: "mlLab.weightsArray")
    }
    
    func clearWeights() {
        UserDefaults.standard.set(nil, forKey: "mlLab.weightsArray")
        prepareWeights()
    }
    
    func activateFunction() -> PredictedSymbol {
        var sum = weights[0]
        for i in 1..<10000 {
            sum += Double(inputs[i-1]) * weights[i]
        }
        activationFunctionLastResult = sum >= 0 ? 1 : 0
        return activationFunctionLastResult > 0 ? .characterA : .number9
        
    }
    
    func learnThatCurrentImage(is character: PredictedSymbol) {
        var expectedResult: UInt8
        switch character {
        case .characterA:
            expectedResult = 1
        default:
            expectedResult = 0
        }
        learnWith(new: expectedResult)
    }
    
    func learnWith(new result: UInt8) {
        let delta: Double = Double(result) - Double(activationFunctionLastResult!)
        weights[0] += eduSpeed * delta
        for i in 1..<10000 {
            weights[i] += eduSpeed * delta * Double(inputs[i-1])
        }
    }
}
