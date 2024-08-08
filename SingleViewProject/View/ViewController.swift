//
//  ViewController.swift
//  SingleViewProject
//
//  Created by Ateeq Ahmed on 08/08/24.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    private var stackView: UIStackView!
    private var passwordField: UITextField?
    private var slider: UISlider?
    private var percentageLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        setupUI()
    }
    
    func fetchData(){
        WebServiceManager.shared.onFormFieldsUpdated = { [weak self] in
            self?.createFields()
        }
        WebServiceManager.shared.fetchFormData()
    }
    
    private func createFields() {
        for fieldData in WebServiceManager.shared.formFields {
               let labelView = UILabel()
               labelView.text = fieldData.label
               stackView.addArrangedSubview(labelView)
               
               switch fieldData.dataTypeID {
                   
               case 1:
                   let textField = createTextField(placeholder: fieldData.label!)
                   stackView.addArrangedSubview(textField)
                   
               case 2:
                   let passwordField = createTextField(placeholder: fieldData.label!, isSecure: true)
                   passwordField.delegate = self
                   passwordField.addTarget(self, action: #selector(passwordFieldDidChange(_:)), for: .editingChanged)
                   self.passwordField = passwordField
                   stackView.addArrangedSubview(passwordField)
                   
                   let slider = UISlider()
                   slider.minimumValue = 0
                   slider.maximumValue = 100
                   slider.isUserInteractionEnabled = false // Prevent user interaction
                   self.slider = slider
                   stackView.addArrangedSubview(slider)
                   
                   let percentageLabel = UILabel()
                   percentageLabel.textAlignment = .right
                   percentageLabel.text = "0%"
                   self.percentageLabel = percentageLabel
                   stackView.addArrangedSubview(percentageLabel)
                   
               case 3:
                   let pickerView = UIPickerView()
                   stackView.addArrangedSubview(pickerView)
                   
               case 4:
                   let datePicker = UIDatePicker()
                   stackView.addArrangedSubview(datePicker)
                   
               case 5:
                   let attachButton = UIButton(type: .system)
                   attachButton.setTitle("Attach Files", for: .normal)
                   attachButton.addTarget(self, action: #selector(attachFilesButtonTapped), for: .touchUpInside)
                   stackView.addArrangedSubview(attachButton)
                  
               default:
                   break
               }
           }
       }
    
    private func createTextField(placeholder: String, isSecure: Bool = false) -> UITextField {
           let textField = UITextField()
           textField.borderStyle = .roundedRect
           textField.placeholder = placeholder
           textField.isSecureTextEntry = isSecure
           return textField
       }

       // MARK: - Password Validation
       @objc private func passwordFieldDidChange(_ textField: UITextField) {
           guard let password = textField.text else { return }
           let percentage = validatePassword(password)
           slider?.value = Float(percentage)
           percentageLabel?.text = "\(percentage)%"
       }

       private func validatePassword(_ password: String) -> Int {
           var percentage = 0

           // Validation 1: Starts with uppercase letter
           if let firstChar = password.first, firstChar.isUppercase{
               percentage = 20
           }

           // Validation 2: Contains special character, lowercase, and number
           var containsSpecial = false
           var containsLowercase = false
           var containsNumber = false
           for char in password {
               if char.isLowercase { containsLowercase = true }
               if char.isNumber { containsNumber = true }
               if char.isPunctuation || char.isSymbol { containsSpecial = true }
           }
           if containsSpecial && containsLowercase && containsNumber {
               percentage = 40
           }

           // Validation 3: No consecutive special characters
           var previousWasSpecial = false
           var consecutiveSpecials = false
           for char in password {
               if char.isPunctuation || char.isSymbol {
                   if previousWasSpecial {
                       consecutiveSpecials = true
                       break
                   }
                   previousWasSpecial = true
               } else {
                   previousWasSpecial = false
               }
           }
           if !consecutiveSpecials {
               percentage = 60
           }

           // Validation 4: No consecutive numbers
           var previousWasNumber = false
           var consecutiveNumbers = false
           for char in password {
               if char.isNumber {
                   if previousWasNumber {
                       consecutiveNumbers = true
                       break
                   }
                   previousWasNumber = true
               } else {
                   previousWasNumber = false
               }
           }
           if !consecutiveNumbers {
               percentage = 80
           }

           // Validation 5: Length and first three characters
           if password.count >= 8, password.prefix(3).allSatisfy({ !$0.isPunctuation && !$0.isSymbol }) {
               percentage = 100
           }

           return percentage
   }
    
    func setupUI() {
        view.backgroundColor = .gray
        
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
}
