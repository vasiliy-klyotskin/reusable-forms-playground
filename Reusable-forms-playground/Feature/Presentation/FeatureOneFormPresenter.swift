//
//  FeatureOneFormPresenter.swift
//  FormPoc
//
//  Created by Василий Клецкин on 6/6/23.
//

import Foundation

protocol FeatureOneFormView {
    func isAgreedWithPolicies() -> Bool
    func displayPolicyNotification()
}

final class FeatureOneFormPresenterNew {
    var onAgreedWithPolicies: (() -> Void)?
    
    private let view: FeatureOneFormView
    
    init(view: FeatureOneFormView) {
        self.view = view
    }
    
    func proceedSubmittingWithCheckingPolicies() {
        if !view.isAgreedWithPolicies() {
            view.displayPolicyNotification()
        } else {
            onAgreedWithPolicies?()
        }
    }
}
