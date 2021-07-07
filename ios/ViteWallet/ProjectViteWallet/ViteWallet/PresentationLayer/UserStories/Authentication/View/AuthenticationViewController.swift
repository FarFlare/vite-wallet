//
//  AuthenticationViewController.swift
//  ViteWallet
//
//  Created by Антон Текутов on 07.07.2021.
//

import UIKit

final class AuthenticationViewController: UIViewController {
    
    var viewModel: AuthenticationViewModelProtocol!
    var coordinator: AuthenticationCoordinatorProtocol!
    
    var onboardingController: UIViewController!
    
    private var _view: AuthenticationView {
        return view as! AuthenticationView
    }
    
    override func loadView() {
        self.view = AuthenticationView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .res.tintMain()
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSelf()
    }
    
    private func configureSelf() {
        onboardingController = coordinator.generateOnboarding()
        addChildViewControllerToView(vc: onboardingController, into: _view.onboardingContainer)
        
        _view.emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        _view.passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        _view.signInButton.addTarget(self, action: #selector(signInButtonDidTapped(sender:)), for: .touchUpInside)
        
        _view.emailTextField.delegate = self
        _view.passwordTextField.delegate = self
        
        addKeyboardObserver(selector: #selector(keyboardNotification(notification:)))
        addTapGestureToHideKeyboardCustom()
    }
    
    func addTapGestureToHideKeyboardCustom(to view: UIView? = nil) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardCustom(_:)))
        if let view = view {
            view.addGestureRecognizer(tapGesture)
        } else {
            self.view.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc private func dismissKeyboardCustom(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
        UIView.animate(withDuration: 0.4) { [ weak self ] in
            self?._view.backgroundView.transform = .init(translationX: 0, y: 0)
        }
    }
    
    // MARK: - UI elements actions
    
    @objc private func signInButtonDidTapped(sender: UIButton) {
        guard let text = _view.emailTextField.text,
              text.isNotEmpty,
              text.isEmail
        else { return }
        
        sender.tapAnimation()        
        coordinator.openModule(.loading, openingMode: .showInNewRootNavigationStack)
    }
}

// MARK: - Keyboard

extension AuthenticationViewController {
    
    @objc private func keyboardNotification(notification: NSNotification) {
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else { return }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height
        
        UIView.animate(withDuration: 0.3) { [ weak self ] in
            self?._view.backgroundView.transform = .init(translationX: 0, y: -keyboardHeight)
        }
    }
}

// MARK: - UITextFieldDelegate

extension AuthenticationViewController: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        while textField.text?.contains(" ") == true {
            textField.text = textField.text?.replacingOccurrences(of: " ", with: "")
        }
        switch textField {
        case _view.emailTextField:
            if let text = textField.text,
               text.isEmail {
                _view.manageViewVisibility(view: _view.passwordTextField, hidden: false)
                _view.manageStackYPosition(maxVisibleView: _view.passwordTextField)
            } else {
                _view.manageViewVisibility(view: _view.passwordTextField, hidden: true)
                _view.manageViewVisibility(view: _view.signInButton, hidden: true)
                _view.manageStackYPosition(maxVisibleView: _view.emailTextField)
            }
            
        case _view.passwordTextField:
            if let text = textField.text,
               !text.isEmpty {
                _view.manageViewVisibility(view: _view.signInButton, hidden: false)
                _view.manageStackYPosition(maxVisibleView: _view.signInButton)
            } else {
                _view.manageViewVisibility(view: _view.signInButton, hidden: true)
                _view.manageStackYPosition(maxVisibleView: _view.passwordTextField)
            }
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        switch textField {
        case _view.emailTextField:
            _view.emailTextField.text?.capitalizeFirstLetter()
            _view.passwordTextField.becomeFirstResponder()
        default:
            view.endEditing(true)
        }
        
        return true
    }
}
