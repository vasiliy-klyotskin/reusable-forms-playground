//
//  Inputs.swift
//  FormPoc
//
//  Created by Василий Клецкин on 6/6/23.
//

import Foundation

struct FormTextInputs: ResourceLoadingView, ResourceView {
    typealias ResourceViewModel = FormValidationResultViewModel
    
    let inputs: [AnyHashable: TextInputViewController]
    
    func display(_ viewModel: ResourceLoadingViewModel) {
        inputs.values.forEach {
            $0.cancel()
            $0.view.resignFirstResponder()
        }
    }
    
    func display(_ formValidationResult: FormValidationResultViewModel) {
        for (key, input) in inputs {
            guard let inputValidationResult = formValidationResult.textValidationResults[key] else { continue }
            input.display(inputValidationResult)
        }
    }
    
    subscript(key: AnyHashable) -> TextInputViewController? {
        return inputs[key]
    }
}
