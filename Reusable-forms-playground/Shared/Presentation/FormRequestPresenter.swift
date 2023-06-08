//
//  FormRequestPresenter.swift
//  FormPoc
//
//  Created by Василий Клецкин on 6/7/23.
//

import Foundation

final class FormRequestPresenter<Request> {
    typealias Mapping = ([AnyHashable: TextValidationResult]) throws -> Request
    var onRequestReady: ((Request) -> Void)?
    
    private let mapping: Mapping
    
    init(mapping: @escaping Mapping) {
        self.mapping = mapping
    }
    
    func tryMakeRequest(with results: [AnyHashable: TextValidationResult]) {
        if let request = try? mapping(results) {
            onRequestReady?(request)
        }
    }
}
