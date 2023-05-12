//
//  ConversionViewController.swift
//  TravelMetrics
//
//  Created by Carl Work on 5/9/23.
//

import Foundation
import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate {
    
    enum WeightUnit: String, CaseIterable {
        case kilograms
        case pounds
        case ounces
        case grams
        
        var unit: UnitMass {
            switch self {
            case .kilograms:
                return .kilograms
            case .pounds:
                return .pounds
            case .ounces:
                return .ounces
            case .grams:
                return .grams
            }
        }
    }
    
    enum TemperatureUnit: String, CaseIterable {
        case celsius
        case fahrenheit
        
        var unit: UnitTemperature {
            switch self {
            case .celsius:
                return .celsius
            case .fahrenheit:
                return .fahrenheit
            }
        }
    }
    
    enum DistanceUnit: String, CaseIterable {
        case feet
        case meters
        case yards
        case miles
        case kilometers
        case inches
        case centimeters
        
        var unit: UnitLength {
            switch self {
            case .feet:
                return .feet
            case .meters:
                return .meters
            case .yards:
                return .yards
            case .miles:
                return .miles
            case .kilometers:
                return .kilometers
            case .inches:
                return .inches
            case .centimeters:
                return .centimeters
            }
        }
    }
    
    var weightUnit1: WeightUnit = .kilograms
    var weightUnit2: WeightUnit = .kilograms
    
    var temperatureUnit1: TemperatureUnit = .celsius
    var temperatureUnit2: TemperatureUnit = .celsius
    
    var distanceUnit1: DistanceUnit = .meters
    var distanceUnit2: DistanceUnit = .meters
    
    
    class ConversionService {
        
        func convert(_ value: Double, from: WeightUnit, to: WeightUnit) -> Double {
            let fromMeasurement = Measurement(value: value, unit: from.unit)
            let toMeasurement = fromMeasurement.converted(to: to.unit)
            return toMeasurement.value
        }
        
        func convert(_ value: Double, from: TemperatureUnit, to: TemperatureUnit) -> Double {
            let fromMeasurement = Measurement(value: value, unit: from.unit)
            let toMeasurement = fromMeasurement.converted(to: to.unit)
            return toMeasurement.value
        }
        
        func convert(_ value: Double, from: DistanceUnit, to: DistanceUnit) -> Double {
            let fromMeasurement = Measurement(value: value, unit: from.unit)
            let toMeasurement = fromMeasurement.converted(to: to.unit)
            return toMeasurement.value
        }
        
    }
    
    
    
    
    let weightLabel = UILabel()
    let temperatureLabel = UILabel()
    let distanceLabel = UILabel()
    
    
    // Weight
    let weightField1 = UITextField()
    let weightField2 = UITextField()
    let weightButton1 = UIButton()
    let weightButton2 = UIButton()
    
    // Temperature
    let temperatureField1 = UITextField()
    let temperatureField2 = UITextField()
    let temperatureButton1 = UIButton()
    let temperatureButton2 = UIButton()
    
    // Distance
    let distanceField1 = UITextField()
    let distanceField2 = UITextField()
    let distanceButton1 = UIButton()
    let distanceButton2 = UIButton()
    
    var scrollView: UIScrollView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        view.backgroundColor = UIColor.darkGray
        
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(scrollView)
        
        configureTextFields()
        configureButtons()
        configureLabels()
        configureStackViews()
        
        distanceField1.keyboardType = .decimalPad
        distanceField2.keyboardType = .decimalPad
        weightField1.keyboardType = .decimalPad
        weightField2.keyboardType = .decimalPad
        temperatureField1.keyboardType = .decimalPad
        temperatureField2.keyboardType = .decimalPad
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        
        toolbar.setItems([flexSpace, doneButton], animated: false)
        
        distanceField1.inputAccessoryView = toolbar
        distanceField2.inputAccessoryView = toolbar
        weightField1.inputAccessoryView = toolbar
        weightField2.inputAccessoryView = toolbar
        temperatureField1.inputAccessoryView = toolbar
        temperatureField2.inputAccessoryView = toolbar
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func configureLabels() {
        weightLabel.text = "Weight"
        temperatureLabel.text = "Temperature"
        distanceLabel.text = "Distance"
        
        if UITraitCollection.current.userInterfaceStyle == .dark {
            [weightLabel, temperatureLabel, distanceLabel].forEach {
                $0.textColor = .white
                $0.font = UIFont.boldSystemFont(ofSize: 20)
            }
        } else {
            [weightLabel, temperatureLabel, distanceLabel].forEach {
                $0.textColor = .black
                $0.font = UIFont.boldSystemFont(ofSize: 20)
            }
        }
    }
    
    
    func configureTextFields() {
        [weightField1, weightField2, temperatureField1, temperatureField2, distanceField1, distanceField2].forEach {
            $0.placeholder = "Enter value"
            $0.borderStyle = .roundedRect
            $0.delegate = self
            
            if UITraitCollection.current.userInterfaceStyle == .dark {
                $0.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
                $0.textColor = .white
            } else {
                $0.backgroundColor = .white
                $0.textColor = .black
            }
        }
    }
    
    
    
    
    func configureButtons() {
        [weightButton1, weightButton2, temperatureButton1, temperatureButton2, distanceButton1, distanceButton2].forEach {
            $0.setTitle("Choose Unit", for: .normal)
            
            if UITraitCollection.current.userInterfaceStyle == .dark {
                $0.setTitleColor(.systemBlue, for: .normal)
            } else {
                $0.setTitleColor(.blue, for: .normal)
            }
        }
        
        weightButton1.addTarget(self, action: #selector(weightButton1Tapped), for: .touchUpInside)
        weightButton2.addTarget(self, action: #selector(weightButton2Tapped), for: .touchUpInside)
        temperatureButton1.addTarget(self, action: #selector(temperatureButton1Tapped), for: .touchUpInside)
        temperatureButton2.addTarget(self, action: #selector(temperatureButton2Tapped), for: .touchUpInside)
        distanceButton1.addTarget(self, action: #selector(distanceButton1Tapped), for: .touchUpInside)
        distanceButton2.addTarget(self, action: #selector(distanceButton2Tapped), for: .touchUpInside)
    }
    
    func configureStackViews() {
        let weightStackView = createStackView(with: [weightField1, weightButton1, weightField2, weightButton2])
        let temperatureStackView = createStackView(with: [temperatureField1, temperatureButton1, temperatureField2, temperatureButton2])
        let distanceStackView = createStackView(with: [distanceField1, distanceButton1, distanceField2, distanceButton2])
        
        let weightCluster = UIStackView(arrangedSubviews: [weightLabel, weightStackView])
        weightCluster.axis = .vertical
        weightCluster.alignment = .center
        weightCluster.spacing = 10
        
        let temperatureCluster = UIStackView(arrangedSubviews: [temperatureLabel, temperatureStackView])
        temperatureCluster.axis = .vertical
        temperatureCluster.alignment = .center
        temperatureCluster.spacing = 10
        
        let distanceCluster = UIStackView(arrangedSubviews: [distanceLabel, distanceStackView])
        distanceCluster.axis = .vertical
        distanceCluster.alignment = .center
        distanceCluster.spacing = 10
        
        let spacer1 = UIView()
        let spacer2 = UIView()
        let spacer3 = UIView()
        let spacer4 = UIView()
        
        let verticalStackView = UIStackView(arrangedSubviews: [spacer1, weightCluster, spacer2, temperatureCluster, spacer3, distanceCluster, spacer4])
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 0
        verticalStackView.alignment = .fill
        verticalStackView.distribution = .fillEqually
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.scrollView.addSubview(verticalStackView)
        
        let guide = scrollView.contentLayoutGuide
        let frameGuide = scrollView.frameLayoutGuide
        
        NSLayoutConstraint.activate([
            verticalStackView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20),
            verticalStackView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -20),
            verticalStackView.topAnchor.constraint(equalTo: guide.topAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            verticalStackView.widthAnchor.constraint(equalTo: frameGuide.widthAnchor, constant: -40),
        ])
        
        NSLayoutConstraint.activate([
            spacer1.heightAnchor.constraint(equalTo: spacer2.heightAnchor),
            spacer2.heightAnchor.constraint(equalTo: spacer3.heightAnchor),
            spacer3.heightAnchor.constraint(equalTo: spacer4.heightAnchor)
        ])
    }
    
    
    
    func createStackView(with views: [UIView]) -> UIStackView {
        let field1 = views[0]
        let button1 = views[1]
        let field2 = views[2]
        let button2 = views[3]
        
        let stackView1 = UIStackView(arrangedSubviews: [field1, button1])
        stackView1.axis = .horizontal
        stackView1.spacing = 10
        stackView1.alignment = .fill
        stackView1.distribution = .fillProportionally
        
        let stackView2 = UIStackView(arrangedSubviews: [field2, button2])
        stackView2.axis = .horizontal
        stackView2.spacing = 10
        stackView2.alignment = .fill
        stackView2.distribution = .fillProportionally
        
        let stackView = UIStackView(arrangedSubviews: [stackView1, stackView2])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set a constant width for the buttons and fill the remaining space for the text fields
        let buttonWidth: CGFloat = 160
        [button1, button2].forEach { button in
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        }
        [field1, field2].forEach { field in
            field.translatesAutoresizingMaskIntoConstraints = false
            field.setContentHuggingPriority(.defaultLow, for: .horizontal)
            field.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }
        
        return stackView
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Get new text
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        
        // Convert new text to a number
        if let newValue = Double(newText) {
            if textField == weightField1 {
                updateWeightConversion(newValue, from: weightUnit1, to: weightUnit2, updateField: weightField2)
            } else if textField == weightField2 {
                updateWeightConversion(newValue, from: weightUnit2, to: weightUnit1, updateField: weightField1)
            }
        }
        
        return true
    }
    
    func updateWeightConversion(_ value: Double, from: WeightUnit, to: WeightUnit, updateField: UITextField) {
        let inputValue = Measurement(value: value, unit: from.unit)
        let outputValue = inputValue.converted(to: to.unit)
        let roundedOutputValue = Double(round(100 * outputValue.value) / 100)
        updateField.text = "\(roundedOutputValue)"
    }
    
    
    func updateTemperatureConversion(_ value: Double = 0, from: TemperatureUnit, to: TemperatureUnit, updateField: UITextField) {
        let conversionService = ConversionService()
        let result = conversionService.convert(value, from: from, to: to)
        let roundedResult = Double(round(100 * result) / 100)
        updateField.text = String(roundedResult)
    }
    
    func updateDistanceConversion(_ value: Double = 0, from: DistanceUnit, to: DistanceUnit, updateField: UITextField) {
        let conversionService = ConversionService()
        let result = conversionService.convert(value, from: from, to: to)
        let roundedResult = Double(round(100 * result) / 100) 
        updateField.text = String(roundedResult)
    }
    
    
    
    func presentMeasurementOptions(for button: UIButton, options: [String], completion: @escaping (String) -> Void) {
        let alertController = UIAlertController(title: nil, message: "Choose Unit", preferredStyle: .actionSheet)
        for option in options {
            alertController.addAction(UIAlertAction(title: option, style: .default, handler: { [weak self] _ in
                button.setTitle(option, for: .normal)
                completion(option)
            }))
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = button
            popoverController.sourceRect = CGRect(x: button.bounds.midX, y: button.bounds.midY, width: 0, height: 0)
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            
            scrollView.contentInset = insets
            scrollView.scrollIndicatorInsets = insets
            
            if let activeTextField = self.view.findFirstResponder() as? UITextField {
                let rect = self.view.convert(activeTextField.bounds, from: activeTextField)
                self.scrollView.scrollRectToVisible(rect, animated: true)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let insets = UIEdgeInsets.zero
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
    }
    
    
    
    @objc func doneButtonTapped() {
        view.endEditing(true)
    }
    
    @objc func weightButton1Tapped() {
        presentMeasurementOptions(for: weightButton1, options: WeightUnit.allCases.map { $0.rawValue }) { [weak self] selectedUnit in
            guard let strongSelf = self else { return }
            strongSelf.weightUnit1 = WeightUnit(rawValue: selectedUnit.lowercased()) ?? .kilograms
            let value = Double(strongSelf.weightField1.text ?? "") ?? 0
            strongSelf.updateWeightConversion(value, from: strongSelf.weightUnit1, to: strongSelf.weightUnit2, updateField: strongSelf.weightField2)
        }
    }
    
    @objc func weightButton2Tapped() {
        presentMeasurementOptions(for: weightButton2, options: WeightUnit.allCases.map { $0.rawValue }) { [weak self] selectedUnit in
            guard let strongSelf = self else { return }
            strongSelf.weightUnit2 = WeightUnit(rawValue: selectedUnit.lowercased()) ?? .kilograms
            let value = Double(strongSelf.weightField2.text ?? "") ?? 0
            strongSelf.updateWeightConversion(value, from: strongSelf.weightUnit2, to: strongSelf.weightUnit1, updateField: strongSelf.weightField1)
        }
    }
    
    @objc func temperatureButton1Tapped() {
        presentMeasurementOptions(for: temperatureButton1, options: TemperatureUnit.allCases.map { $0.rawValue }) { [weak self] selectedUnit in
            guard let strongSelf = self else { return }
            strongSelf.temperatureUnit1 = TemperatureUnit(rawValue: selectedUnit.lowercased()) ?? .celsius
            let value = Double(strongSelf.temperatureField1.text ?? "") ?? 0
            strongSelf.updateTemperatureConversion(value, from: strongSelf.temperatureUnit1, to: strongSelf.temperatureUnit2, updateField: strongSelf.temperatureField2)
        }
    }
    
    @objc func temperatureButton2Tapped() {
        presentMeasurementOptions(for: temperatureButton2, options: TemperatureUnit.allCases.map { $0.rawValue }) { [weak self] selectedUnit in
            guard let strongSelf = self else { return }
            strongSelf.temperatureUnit2 = TemperatureUnit(rawValue: selectedUnit.lowercased()) ?? .celsius
            let value = Double(strongSelf.temperatureField2.text ?? "") ?? 0
            strongSelf.updateTemperatureConversion(value, from: strongSelf.temperatureUnit2, to: strongSelf.temperatureUnit1, updateField: strongSelf.temperatureField1)
        }
    }
    
    @objc func distanceButton1Tapped() {
        presentMeasurementOptions(for: distanceButton1, options: DistanceUnit.allCases.map { $0.rawValue }) { [weak self] selectedUnit in
            guard let strongSelf = self else { return }
            strongSelf.distanceUnit1 = DistanceUnit(rawValue: selectedUnit.lowercased()) ?? .meters
            let value = Double(strongSelf.distanceField2.text ?? "") ?? 0
            strongSelf.updateDistanceConversion(value, from: strongSelf.distanceUnit2, to: strongSelf.distanceUnit1, updateField: strongSelf.distanceField1)
        }
    }
    
    @objc func distanceButton2Tapped() {
        presentMeasurementOptions(for: distanceButton2, options: DistanceUnit.allCases.map { $0.rawValue }) { [weak self] selectedUnit in
            guard let strongSelf = self else { return }
            strongSelf.distanceUnit2 = DistanceUnit(rawValue: selectedUnit.lowercased()) ?? .meters
            let value = Double(strongSelf.distanceField2.text ?? "") ?? 0
            strongSelf.updateDistanceConversion(value, from: strongSelf.distanceUnit2, to: strongSelf.distanceUnit1, updateField: strongSelf.distanceField1)
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == weightField1 {
            let value = Double(textField.text ?? "") ?? 0
            updateWeightConversion(value, from: weightUnit1, to: weightUnit2, updateField: weightField2)
        } else if textField == weightField2 {
            let value = Double(textField.text ?? "") ?? 0
            updateWeightConversion(value, from: weightUnit2, to: weightUnit1, updateField: weightField1)
        } else if textField == temperatureField1 {
            let value = Double(textField.text ?? "") ?? 0
            updateTemperatureConversion(value, from: temperatureUnit1, to: temperatureUnit2, updateField: temperatureField2)
        } else if textField == temperatureField2 {
            let value = Double(textField.text ?? "") ?? 0
            updateTemperatureConversion(value, from: temperatureUnit2, to: temperatureUnit1, updateField: temperatureField1)
        } else if textField == distanceField1 {
            let value = Double(textField.text ?? "") ?? 0
            updateDistanceConversion(value, from: distanceUnit1, to: distanceUnit2, updateField: distanceField2)
        } else if textField == distanceField2 {
            let value = Double(textField.text ?? "") ?? 0
            updateDistanceConversion(value, from: distanceUnit2, to: distanceUnit1, updateField: distanceField1)
        }
    }
}

extension UIView {
    func findFirstResponder() -> UIView? {
        if self.isFirstResponder {
            return self
        }
        for subView in self.subviews {
            if let firstResponder = subView.findFirstResponder() {
                return firstResponder
            }
        }
        return nil
    }
}



