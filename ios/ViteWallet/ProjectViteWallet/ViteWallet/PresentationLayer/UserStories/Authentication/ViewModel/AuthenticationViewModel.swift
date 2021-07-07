//
//  AuthenticationViewModel.swift
//  ViteWallet
//
//  Created by Антон Текутов on 07.07.2021.
//

final class AuthenticationViewModel {
	var output: AuthenticationOutput?
}

// MARK: - Configuration
extension AuthenticationViewModel: CustomizableAuthenticationViewModel {

}

// MARK: - Interface for view
extension AuthenticationViewModel: AuthenticationViewModelProtocol {

}

