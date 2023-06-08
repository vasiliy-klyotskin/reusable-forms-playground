//
//  Helpers.swift
//  FormPoc
//
//  Created by Василий Клецкин on 6/5/23.
//

import Foundation

final class FeatureSubmitViewWrapper: ResourceLoadingView, ResourceErrorView, ResourceView {
    typealias ResourceViewModel = Void
    
    private let controller: FeatureOneFormController
    
    init(_ controller: FeatureOneFormController) {
        self.controller = controller
    }
    
    func display(_ viewModel: Void) {
        controller.showSubmitSuccess()
    }
    func display(_ viewModel: ResourceErrorViewModel) {
        controller.showSubmitError(show: viewModel.message != nil)
    }
    func display(_ viewModel: ResourceLoadingViewModel) {
        controller.showSubmmitIndication(viewModel.isLoading)
    }
}


final class FeatureValidationViewWrapper: ResourceLoadingView, ResourceErrorView, ResourceView {
    typealias ResourceViewModel = FormValidationResultViewModel
    
    private let controller: FeatureOneFormController
    
    init(_ controller: FeatureOneFormController) {
        self.controller = controller
    }
    
    func display(_ viewModel: ResourceErrorViewModel) {}
    func display(_ viewModel: FormValidationResultViewModel) {
        controller.showValidationFail(viewModel)
    }
    func display(_ viewModel: ResourceLoadingViewModel) {
        controller.showValidationIndication(viewModel.isLoading)
    }
}
