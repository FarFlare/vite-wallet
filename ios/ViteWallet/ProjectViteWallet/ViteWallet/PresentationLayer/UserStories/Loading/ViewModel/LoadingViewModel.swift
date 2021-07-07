//
//  LoadingViewModel.swift
//  ViteWallet
//
//  Created by Anton Tekutov on 07.07.21.
//

final class LoadingViewModel {
    
	var output: LoadingOutput?
    
}

// MARK: - Configuration
extension LoadingViewModel: CustomizableLoadingViewModel {

}

// MARK: - Interface for view
extension LoadingViewModel: LoadingViewModelProtocol {
    
    func startConfiguration() {
        
    }
    
    func checkActiveUser(_ completion: @escaping(Bool) -> Void) {
        completion(false)
    }
}

