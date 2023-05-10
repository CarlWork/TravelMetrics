//  CurrencyViewController.swift
//  TravelMetrics
//
//  Created by Carl Work on 4/28/23.
//

import Foundation
import UIKit

class CurrencyViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    var currencies: [Currency] = [] {
        didSet {
            DispatchQueue.main.async {
                self.sourceCurrencyPicker.reloadAllComponents()
                self.targetCurrencyPicker.reloadAllComponents()
            }
        }
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies[row].code
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard row < currencies.count else {
            print("Error: Selected row is out of range.")
            return
        }
        if pickerView == sourceCurrencyPicker {
            // Update source currency variable
            sourceCurrencyLabel.text = currencies[row].name
        } else if pickerView == targetCurrencyPicker {
            // Update target currency variable
            targetCurrencyLabel.text = currencies[row].name
        }
    }
    
    func configureConvertButton() {
        convertButton.translatesAutoresizingMaskIntoConstraints = false
        convertButton.setTitle("Convert", for: .normal)
        convertButton.addTarget(self, action: #selector(convertButtonTapped), for: .touchUpInside)
        convertButton.backgroundColor = UIColor.systemBlue
        convertButton.setTitleColor(UIColor.white, for: .normal)
        convertButton.layer.cornerRadius = 8
        convertButton.clipsToBounds = true
        view.addSubview(convertButton)
        
        NSLayoutConstraint.activate([
            convertButton.topAnchor.constraint(equalTo: targetCurrencyPicker.bottomAnchor, constant: 16),
            convertButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func loadAvailableSymbols() {
        NetworkManager.shared.fetchAvailableSymbols { [weak self] result in
            switch result {
            case .success(let fetchedCurrencies):
                self?.currencies = fetchedCurrencies
            case .failure(let error):
                print("Error fetching available symbols: \(error.localizedDescription)")
            }
        }
    }
    
    @objc func convertButtonTapped() {
        // Get the selected currencies
        let sourceCurrency = currencies[sourceCurrencyPicker.selectedRow(inComponent: 0)].code
        let targetCurrency = currencies[targetCurrencyPicker.selectedRow(inComponent: 0)].code
        
        guard let amountText = inputAmountTextField.text else {
            print("Error: Amount not entered")
            return
        }
        
        NetworkManager.shared.fetchConvertedAmount(amount: amountText, from: sourceCurrency, to: targetCurrency) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let convertedAmount):
                    self?.resultLabel.text = "\(amountText) \(sourceCurrency) = \(convertedAmount) \(targetCurrency)"
                case .failure(let error):
                    print("Error fetching converted amount: \(error.localizedDescription)")
                    self?.resultLabel.text = "Error: Could not fetch converted amount."
                }
            }
        }
    }
    
    
    
    
    
    
    let inputAmountTextField = UITextField()
    let sourceCurrencyPicker = UIPickerView()
    let targetCurrencyPicker = UIPickerView()
    let sourceCurrencyLabel = UILabel()
    let targetCurrencyLabel = UILabel()
    let convertButton = UIButton(type: .system)
    let resultLabel = UILabel()
    
    override func loadView() {
        super.loadView()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // background color
        view.backgroundColor = .white
        
        // Configure and add subviews
        configureInputAmountTextField()
        configureSourceCurrencyPicker()
        configureTargetCurrencyPicker()
        configureCurrencyLabels()
        configureConvertButton()
        configureResultLabel()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadAvailableSymbols()
    }
    
    
    
    func configureInputAmountTextField() {
        // Configure inputAmountTextField properties
        inputAmountTextField.placeholder = "Enter amount"
        inputAmountTextField.borderStyle = .roundedRect
        inputAmountTextField.keyboardType = .decimalPad
        inputAmountTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(inputAmountTextField)
        
        // Add Auto Layout constraints
        NSLayoutConstraint.activate([
            inputAmountTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            inputAmountTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            inputAmountTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    func configureSourceCurrencyPicker() {
        sourceCurrencyPicker.translatesAutoresizingMaskIntoConstraints = false
        sourceCurrencyPicker.delegate = self
        sourceCurrencyPicker.dataSource = self
        view.addSubview(sourceCurrencyPicker)
        
        NSLayoutConstraint.activate([
            sourceCurrencyPicker.topAnchor.constraint(equalTo: inputAmountTextField.bottomAnchor, constant: 50),
            sourceCurrencyPicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            sourceCurrencyPicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    func configureTargetCurrencyPicker() {
        targetCurrencyPicker.translatesAutoresizingMaskIntoConstraints = false
        targetCurrencyPicker.delegate = self
        targetCurrencyPicker.dataSource = self
        view.addSubview(targetCurrencyPicker)
        
        NSLayoutConstraint.activate([
            targetCurrencyPicker.topAnchor.constraint(equalTo: sourceCurrencyPicker.bottomAnchor, constant: 16),
            targetCurrencyPicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            targetCurrencyPicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    func configureCurrencyLabels() {
        // Configure sourceCurrencyLabel properties
        sourceCurrencyLabel.translatesAutoresizingMaskIntoConstraints = false
        if !currencies.isEmpty {
            sourceCurrencyLabel.text = currencies[0].name
        }
        view.addSubview(sourceCurrencyLabel)
        
        // Configure targetCurrencyLabel properties
        targetCurrencyLabel.translatesAutoresizingMaskIntoConstraints = false
        if !currencies.isEmpty {
            targetCurrencyLabel.text = currencies[0].name
        }
        view.addSubview(targetCurrencyLabel)
        
        // Add Auto Layout constraints
        NSLayoutConstraint.activate([
            sourceCurrencyLabel.bottomAnchor.constraint(equalTo: sourceCurrencyPicker.topAnchor, constant: -1),
            sourceCurrencyLabel.centerXAnchor.constraint(equalTo: sourceCurrencyPicker.centerXAnchor),
            
            targetCurrencyLabel.bottomAnchor.constraint(equalTo: targetCurrencyPicker.topAnchor, constant: -1),
            targetCurrencyLabel.centerXAnchor.constraint(equalTo: targetCurrencyPicker.centerXAnchor)
        ])
    }
    
    
    func configureResultLabel() {
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.textAlignment = .center
        resultLabel.numberOfLines = 0
        resultLabel.font = UIFont.systemFont(ofSize: 24)
        view.addSubview(resultLabel)
        
        NSLayoutConstraint.activate([
            resultLabel.topAnchor.constraint(equalTo: convertButton.bottomAnchor, constant: 16),
            resultLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            resultLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
}
