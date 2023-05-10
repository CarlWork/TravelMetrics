//
//  TemperatureViewController.swift
//  TravelMetrics
//
//  Created by Carl Work on 4/28/23.
//

import Foundation
import UIKit

class TemperatureViewController: UIViewController {
    let inputTemperatureTextField = UITextField()
    let segmentedControl = UISegmentedControl(items: ["Celsius", "Fahrenheit"])
    let resultLabel = UILabel()
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        // Configure and add subviews
        configureInputTemperatureTextField()
        configureSegmentedControl()
        configureResultLabel()
    }
    
    func configureInputTemperatureTextField() {
        inputTemperatureTextField.placeholder = "Enter temperature"
        inputTemperatureTextField.borderStyle = .roundedRect
        inputTemperatureTextField.keyboardType = .decimalPad
        inputTemperatureTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(inputTemperatureTextField)
        
        NSLayoutConstraint.activate([
            inputTemperatureTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            inputTemperatureTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            inputTemperatureTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    func configureSegmentedControl() {
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        view.addSubview(segmentedControl)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: inputTemperatureTextField.bottomAnchor, constant: 16),
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
        guard let inputText = inputTemperatureTextField.text, let inputValue = Double(inputText) else {
            print("Error: Invalid input")
            return
        }
        
        let inputTemperature = Measurement(value: inputValue, unit: segmentedControl.selectedSegmentIndex == 0 ? UnitTemperature.celsius : UnitTemperature.fahrenheit)
        let convertedTemperature = inputTemperature.converted(to: segmentedControl.selectedSegmentIndex == 0 ? UnitTemperature.fahrenheit : UnitTemperature.celsius)
        
        let inputUnit = segmentedControl.selectedSegmentIndex == 0 ? "C" : "F"
        let outputUnit = segmentedControl.selectedSegmentIndex == 0 ? "F" : "C"
        
        resultLabel.text = String(format: "%.2f %@ = %.2f %@", inputValue, inputUnit, convertedTemperature.value, outputUnit)
    }
}
