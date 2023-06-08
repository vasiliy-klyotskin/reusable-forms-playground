//
//  FormValidationResultViewModel.swift
//  InputFormPoc
//
//  Created by Василий Клецкин on 6/7/23.
//

import Foundation

struct FormValidationResultViewModel {
    let textValidationResults: [AnyHashable: TextValidationResultViewModel]
    
    var needToShowValidationFail: Bool {
        for result in textValidationResults.values {
            if result.needToShowValidationFail {
                return true
            }
        }
        return false
    }
    
    static func from(model: FormValidationResult) -> FormValidationResultViewModel {
        let viewModels = model.mapValues {
            TextValidationResultViewModel.map(model: $0)
        }
        return .init(textValidationResults: viewModels)
    }
}
