//
//  ConversionViewController.swift
//  TravelMetrics
//
//  Created by Carl Work on 5/9/23.
//

import Foundation

let textField1 = UITextField()
let textField2 = UITextField()

let pickerView1 = UIPickerView()
let pickerView2 = UIPickerView()

let textFieldStackView = UIStackView(arrangedSubviews: [textField1, textField2])
textFieldStackView.axis = .vertical
textFieldStackView.distribution = .fillEqually
textFieldStackView.spacing = 10

let pickerViewStackView = UIStackView(arrangedSubviews: [pickerView1, pickerView2])
pickerViewStackView.axis = .vertical
pickerViewStackView.distribution = .fillEqually
pickerViewStackView.spacing = 10

let horizontalStackView = UIStackView(arrangedSubviews: [textFieldStackView, pickerViewStackView])
horizontalStackView.axis = .horizontal
horizontalStackView.distribution = .fillEqually
horizontalStackView.spacing = 10

self.view.addSubview(horizontalStackView)

horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
    horizontalStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
    horizontalStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
    horizontalStackView.topAnchor.constraint(equalTo: self.view.topAnchor),
    horizontalStackView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1/3)
])

@objc func weightButtonTapped() {
    let alertController = UIAlertController(title: nil, message: "Choose Weight", preferredStyle: .actionSheet)

    let weights = ["Kilograms", "Pounds", "Grams", "Ounces"]  // Add more weights as needed

    for weight in weights {
        alertController.addAction(UIAlertAction(title: weight, style: .default, handler: { _ in
            self.weightButton.setTitle(weight, for: .normal)
            self.updateResult()
        }))
    }

    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

    self.present(alertController, animated: true, completion: nil)
}

func updateResult() {
    guard let inputText = inputWeightTextField.text, let inputValue = Double(inputText) else {
        print("Error: Invalid input")
        return
    }

    let inputUnit: UnitMass
    let outputUnit: UnitMass

    switch weightButton.title(for: .normal) {
    case "Kilograms":
        inputUnit = .kilograms
        outputUnit = .pounds
    case "Pounds":
        inputUnit = .pounds
        outputUnit = .kilograms
    // Add more cases for the other weights you added
    default:
        return
    }

    let inputWeight = Measurement(value: inputValue, unit: inputUnit)
    let convertedWeight = inputWeight.converted(to: outputUnit)

    resultLabel.text = String(format: "%.2f %@ = %.2f %@", inputValue, inputUnit.symbol, convertedWeight.value, outputUnit.symbol)
}
