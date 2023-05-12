//
//  WeightViewController.swift
//  TravelMetrics
//
//  Created by Carl Work on 4/28/23.
//

import Foundation
import UIKit

class WeightViewController: UIViewController {
    let inputWeightTextField = UITextField()
    let segmentedControl = UISegmentedControl(items: ["Kilograms", "Pounds"])
    let resultLabel = UILabel()
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        configureInputWeightTextField()
        configureSegmentedControl()
        configureResultLabel()
    }
    
    func configureInputWeightTextField() {
        inputWeightTextField.placeholder = "Enter weight"
        inputWeightTextField.borderStyle = .roundedRect
        inputWeightTextField.keyboardType = .decimalPad
        inputWeightTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(inputWeightTextField)
        
        NSLayoutConstraint.activate([
            inputWeightTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            inputWeightTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            inputWeightTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    func configureSegmentedControl() {
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        view.addSubview(segmentedControl)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: inputWeightTextField.bottomAnchor, constant: 16),
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func configureResultLabel() {
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.textAlignment = .center
        resultLabel.numberOfLines = 0
        resultLabel.font = UIFont.systemFont(ofSize: 24)
        view.addSubview(resultLabel)
        
        NSLayoutConstraint.activate([
            resultLabel.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            resultLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            resultLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    @objc func segmentedControlValueChanged() {
        updateResult()
    }
    
    func updateResult() {
        guard let inputText = inputWeightTextField.text, let inputValue = Double(inputText) else {
            print("Error: Invalid input")
            return
        }
        
        let inputWeight = Measurement(value: inputValue, unit: segmentedControl.selectedSegmentIndex == 0 ? UnitMass.kilograms : UnitMass.pounds)
        let convertedWeight = inputWeight.converted(to: segmentedControl.selectedSegmentIndex == 0 ? UnitMass.pounds : UnitMass.kilograms)
        
        let inputUnit = segmentedControl.selectedSegmentIndex == 0 ? "kg" : "lb"
        let outputUnit = segmentedControl.selectedSegmentIndex == 0 ? "lb" : "kg"
        
        resultLabel.text = String(format: "%.2f %@ = %.2f %@", inputValue, inputUnit, convertedWeight.value, outputUnit)
    }
}
