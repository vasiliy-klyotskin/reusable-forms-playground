//
//  RequestMapping.swift
//  FormPoc
//
//  Created by Василий Клецкин on 6/7/23.
//

import Foundation

func mapInputToRequest(inputs: FormValidationResult) throws -> FeatureOneSubmitRequest {
    guard inputs.values.allSatisfy({ $0.isValid }) else { throw NSError() }
    
    return .init(
        email: inputs[FeatureOneInputsIds.email]!.value,
        phone: inputs[FeatureOneInputsIds.phone]!.value,
        iin: inputs[FeatureOneInputsIds.iin]!.value
    )
}
