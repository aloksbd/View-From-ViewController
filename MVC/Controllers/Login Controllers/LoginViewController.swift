//
//  ViewController.swift
//  MVC
//
//  Created by alok subedi on 18/07/2021.
//

import UIKit

class LoginViewController: UIViewController {
    private func createLabel(text: String, color: UIColor = .black, font: UIFont = UIFont.systemFont(ofSize: 14)) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = color
        label.font = font
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    private lazy var appIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .green
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var errorLabel: UILabel = createLabel(text: "", color: .red)
    
    private lazy var appNameLabel: UILabel = createLabel(text: "MVC App", color: .purple, font: UIFont.systemFont(ofSize: 32, weight: .semibold))
    
    private var loginFormView: UIView!
    
    private lazy var signInWithGoogleButton: UIButton = createButton(title: "Log in with Google", fontColor: .white, backgroundColor: #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), action: #selector(loginWithGoogle))
    private lazy var signInWithFacebookButton: UIButton = createButton(title: "Log in with Facebook", fontColor: .white, backgroundColor: #colorLiteral(red: 0.2588235294, green: 0.4039215686, blue: 0.6980392157, alpha: 1), action: #selector(loginWithFacebook))
    private lazy var signUpButton: UIButton = createButton(title: "Sign up", fontColor: .systemBlue, backgroundColor: .white, action: #selector(openSignUpView))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        addLoginFormViewController()
        addViews()
        addConstraints()
        addTapGestureToHideKeyboard()
    }
    
    private func addLoginFormViewController() {
        let loginFormViewController = LoginFormViewController()
        addChild(loginFormViewController)
        loginFormViewController.didMove(toParent: self)
        loginFormViewController.delegate = self
        loginFormView = loginFormViewController.view
        loginFormView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: Tap gesture to hide keyboard
    private func addTapGestureToHideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func loginWithFacebook() {
        let loginManager = LoginManager()
        
        loginManager.logIn(permissions: [], from: self) { [weak self] (result, error) in
            guard let self = self else { return }
            if let error = error {
                self.showError(error.localizedDescription)
                return
            }
            if result.isCancelled {
                self.showError("User cancelled login")
                return
            }
            self.openHomeView()
        }
    }
    
    @objc func loginWithGoogle() {
        let signInConfig = "Google sign in configuration"
        
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { [weak self] user, error in
            guard let self = self else { return }
            
            if let error = error {
                self.showError(error.localizedDescription)
            }
            self.openHomeView()
        }
    }
    
    private func showError(_ message: String) {
        DispatchQueue.main.async {
            self.errorLabel.text = message
        }
    }
    
    // MARK: Navigation
    func openHomeView() {
        DispatchQueue.main.async {
            let homeVC = HomeViewController()
            homeVC.modalPresentationStyle = .fullScreen
            self.present(homeVC, animated: true)
        }
    }
    
    @objc func openSignUpView() {
        let signUpVC = SignupViewController()
        signUpVC.modalPresentationStyle = .fullScreen
        self.present(signUpVC, animated: true)
    }
}

extension LoginViewController: LoginControllerDelegate {
    func errorOnLogin(_ message: String) {
        showError(message)
    }
    
    func loggedIn() {
        openHomeView()
    }
}

// MARK: Add sub views
extension LoginViewController {
    private func addViews() {
        view.addSubview(appIcon)
        view.addSubview(appNameLabel)
        view.addSubview(errorLabel)
        view.addSubview(loginFormView)
        view.addSubview(signInWithGoogleButton)
        view.addSubview(signInWithFacebookButton)
        view.addSubview(signUpButton)
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            appIcon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 75),
            appIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appIcon.heightAnchor.constraint(equalToConstant: 75),
            appIcon.widthAnchor.constraint(equalTo: appIcon.heightAnchor),
            
            appNameLabel.topAnchor.constraint(equalTo: appIcon.bottomAnchor, constant: 14),
            appNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            errorLabel.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 40),
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            loginFormView.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 14),
            loginFormView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            loginFormView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            signInWithGoogleButton.topAnchor.constraint(equalTo: loginFormView.bottomAnchor, constant: 14),
            signInWithGoogleButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            signInWithGoogleButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            signInWithFacebookButton.topAnchor.constraint(equalTo: signInWithGoogleButton.bottomAnchor, constant: 14),
            signInWithFacebookButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            signInWithFacebookButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            signUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}
