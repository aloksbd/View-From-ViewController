//
//  LoginFormViewController.swift
//  MVC
//
//  Created by alok subedi on 06/08/2021.
//

import UIKit

class LoginFormViewController: UIViewController {
    private func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func createTextField(placeholder: String, isPassword: Bool) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = isPassword
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
    private func createButton(title: String, fontColor: UIColor, backgroundColor: UIColor, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.tintColor = fontColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = 5
        button.addTarget(self, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    private lazy var usernameLabel: UILabel = createLabel(text: "Username")
    private lazy var usernameTextField: UITextField = createTextField(placeholder: "username", isPassword: false)
    
    private lazy var passwordLabel: UILabel = createLabel(text: "Password")
    private lazy var passwordTextField: UITextField = createTextField(placeholder: "password", isPassword: true)
    
    private lazy var signInButton: UIButton = createButton(title: "Log in", fontColor: .green, backgroundColor: .purple, action: #selector(login))
    var delegate: LoginControllerDelegate!
    
    @objc private func login() {
        guard let username = usernameTextField.text,
              let password = passwordTextField.text
        else {
            delegate.errorOnLogin("some fields empty")
            return
        }
        
        if password.count < 8 {
            delegate.errorOnLogin("password should be at least 8 character long")
            return
        }
        
        let url = URL(string: "https://someurl.com")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body: [String: Any] = [
            "username": username,
            "password": password
        ]
        let bodyData = try! JSONSerialization.data(withJSONObject: body)
        request.httpBody = bodyData
    
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                self.delegate.errorOnLogin(error.localizedDescription)
                return
            }
            if (response as? HTTPURLResponse)?.statusCode != 200 {
                self.delegate.errorOnLogin("login failed")
                return
            }
            self.delegate.loggedIn()
        }.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
        addConstraints()
    }
    
    private func addViews() {
        view.addSubview(usernameLabel)
        view.addSubview(usernameTextField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: view.topAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            
            usernameTextField.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8),
            usernameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            usernameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            passwordLabel.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 14),
            passwordLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 8),
            passwordTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            signInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 14),
            signInButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            signInButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            signInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension LoginFormViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        }
        if textField == passwordTextField {
            dismissKeyboard()
            login()
        }
        return false
    }
    
    private func dismissKeyboard() {
        view.endEditing(true)
    }
}
