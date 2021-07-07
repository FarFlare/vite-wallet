//
//  AuthenticationView.swift
//  ViteWallet
//
//  Created by Антон Текутов on 07.07.2021.
//

import UIKit

final class AuthenticationView: UIView {

    let backgroundView = UIView()
        
    let stack = UIStackView()
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let signInButton = ButtonWithTouchSize()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    func manageSignInButtonVisibility(hidden: Bool) {
        DispatchQueue.main.async { [ weak self ] in
            UIView.animate(withDuration: 0.4) { [ weak self ] in
                self?.signInButton.isHidden = hidden
                self?.signInButton.alpha = hidden ? 0 : 1
                self?.passwordTextField.isHidden = hidden
                self?.passwordTextField.alpha = hidden ? 0 : 1
                self?.setNeedsLayout()
                self?.layoutIfNeeded()
            }
        }
    }

    // MARK: - Private methods
    
    private func setupView() {
        backgroundColor = .res.background()
        
        addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = .res.background()
        
        backgroundView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 12
        
        stack.addArrangedSubview(emailTextField)
        UIStyleManager.textFieldDefault(textField: emailTextField, placeholderText: .res.authenticationEmailInputPlaceholder())
        
        stack.addArrangedSubview(passwordTextField)
        UIStyleManager.textFieldDefault(textField: passwordTextField, placeholderText: .res.authenticationPasswordInputPlaceholder())
        
        stack.addArrangedSubview(signInButton)
        UIStyleManager.buttonPrimary(signInButton)
        signInButton.setTitle(.res.authenticationSignInButtonText())
        signInButton.isHidden = true
        
        makeConstraints()
    }

    private func makeConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundView.leftAnchor.constraint(equalTo: leftAnchor),
            backgroundView.rightAnchor.constraint(equalTo: rightAnchor),

            stack.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -48),
            stack.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            stack.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, constant: -48)
        ])
    }
}
