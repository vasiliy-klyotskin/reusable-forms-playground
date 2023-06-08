//
//  ValidationSynchronizer.swift
//  InputFormPoc
//
//  Created by Василий Клецкин on 6/8/23.
//

import Foundation

final class ValidationSynchronizer {
    private let inputs: Inputs
    
    init(inputs: Inputs) {
        self.inputs = inputs
    }
    
    func validate(completion: @escaping (Result<FormValidationResult, Error>) -> Void) {
        var results: FormValidationResult = [:]
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "com.validationSynchronizer.validationQueue")
        for (id, input) in inputs {
            let value = input.controller.text
            let validation = input.validation(value)
            group.enter()
            queue.async {
                validation { result in
                    switch result {
                    case .success(let validation):
                        results[id] = validation
                    default: break
                    }
                    group.leave()
                }
            }
        }
        group.notify(queue: .global()) {
            completion(.success(results))
        }
    }
}
