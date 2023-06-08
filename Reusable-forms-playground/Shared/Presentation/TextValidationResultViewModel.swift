//
//  ValidationViewModel.swift
//  FormPoc
//
//  Created by Василий Клецкин on 6/5/23.
//

import Foundation

struct TextValidationResultViewModel {
    let validationFailMessage: String?
    
    var needToShowValidationFail: Bool {
        validationFailMessage != nil
    }
    
    static func from(message: String) -> (TextValidationResult) -> TextValidationResultViewModel {
        { result in
            if result.isValid {
                return .init(validationFailMessage: nil)
            } else {
                return .init(validationFailMessage: message)
            }
        }
    }
    
    static func map(model: TextValidationResult) -> TextValidationResultViewModel {
        .init(validationFailMessage: model.isValid ? nil : model.message)
    }
}
