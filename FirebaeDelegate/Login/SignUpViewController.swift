//
//  SignUpViewController.swift
//  FirebaeDelegate
//
//  Created by C4Q on 11/18/19.
//  Copyright © 2019 Iram Fattah. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    //MARK: UI Objects
    
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Fave Spots: Create Account"
        label.font = UIFont(name: "Verdana-Bold", size: 28)
        label.textColor = UIColor(red: 255/255, green: 86/255, blue: 0/255, alpha: 1.0)
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Email"
        textField.font = UIFont(name: "Verdana", size: 14)
        textField.backgroundColor = .white
        textField.borderStyle = .bezel
        textField.autocorrectionType = .no
        textField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        return textField
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Password"
        textField.font = UIFont(name: "Verdana", size: 14)
        textField.backgroundColor = .white
        textField.borderStyle = .bezel
        textField.autocorrectionType = .no
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        return textField
    }()
    
    lazy var createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Verdana-Bold", size: 14)
        button.backgroundColor = UIColor(red: 255/255, green: 67/255, blue: 0/255, alpha: 1)
        button.layer.cornerRadius = 5
       // button.addTarget(self, action: #selector(trySignUp), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 198/255, green: 198/255, blue: 198/255, alpha: 1)
        setupHeaderLabel()
        setupCreateStackView()

        // Do any additional setup after loading the view.
    }
    
    //MARK: Obj C methods
    
    @objc func validateFields() {
           guard emailTextField.hasText, passwordTextField.hasText else {
               createButton.backgroundColor = UIColor(red: 255/255, green: 67/255, blue: 0/255, alpha: 0.5)
               createButton.isEnabled = false
               return
           }
           createButton.isEnabled = true
           createButton.backgroundColor = UIColor(red: 255/255, green: 67/255, blue: 0/255, alpha: 1)
       }
    
    
    //MARK: UI Setup
       
       private func setupHeaderLabel() {
           view.addSubview(headerLabel)
           
           headerLabel.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               headerLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30),
               headerLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
               headerLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
               headerLabel.heightAnchor.constraint(lessThanOrEqualTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.08)])
       }
       
       private func setupCreateStackView() {
           let stackView = UIStackView(arrangedSubviews: [emailTextField,passwordTextField,createButton])
           stackView.axis = .vertical
           stackView.spacing = 15
           stackView.distribution = .fillEqually
           self.view.addSubview(stackView)
           
           stackView.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               stackView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 100),
               stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
               stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)])
       }
    


}
