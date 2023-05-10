//  DistanceViewController.swift
//  TravelMetrics
//
//  Created by Carl Work on 4/28/23.
//

import Foundation
import UIKit

class DistanceViewController: UIViewController {
    let inputDistanceTextField = UITextField()
    let segmentedControl = UISegmentedControl(items: ["Kilometers", "Miles"])
    let resultLabel = UILabel()
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        // Configure and add subviews
        configureInputDistanceTextField()
        configureSegmentedControl()
        configureResultLabel()
    }
    
    func configureInputDistanceTextField() {
        inputDistanceTextField.placeholder = "Enter distance"
        inputDistanceTextField.borderStyle = .roundedRect
        inputDistanceTextField.keyboardType = .decimalPad
        inputDistanceTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(inputDistanceTextField)
        
        NSLayoutConstraint.activate([
            inputDistanceTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            inputDistanceTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            inputDistanceTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    func configureSegmentedControl() {
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        view.addSubview(segmentedControl)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: inputDistanceTextField.bottomAnchor, constant: 16),
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
        guard let inputText = inputDistanceTextField.text, let inputValue = Double(inputText) else {
            print("Error: Invalid input")
            return
        }
        
        let inputDistance = Measurement(value: inputValue, unit: segmentedControl.selectedSegmentIndex == 0 ? UnitLength.kilometers : UnitLength.miles)
        let convertedDistance = inputDistance.converted(to: segmentedControl.selectedSegmentIndex == 0 ? UnitLength.miles : UnitLength.kilometers)
        
        let inputUnit = segmentedControl.selectedSegmentIndex == 0 ? "km" : "mi"
        let outputUnit = segmentedControl.selectedSegmentIndex == 0 ? "mi" : "km"
        
        resultLabel.text = String(format: "%.2f %@ = %.2f %@", inputValue, inputUnit, convertedDistance.value, outputUnit)
    }
}
