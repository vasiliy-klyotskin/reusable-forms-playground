//
//  FeatureOneValidations.swift
//  FormPoc
//
//  Created by Василий Клецкин on 6/7/23.
//

import Foundation

func validatePhone(_ value: String) -> TextValidationResult {
    .init(
        value: value,
        isValid: Set(value).contains("+"),
        message: "phone is invalid"
    )
}

func validateEmail(_ value: String) -> TextValidationResult {
    .init(
        value: value,
        isValid: Set(value).contains("@"),
        message: "email is invalid"
    )
}

func validateIin(_ value: String) -> TextValidationResult {
    .init(
        value: value,
        isValid: Set(value).contains("0"),
        message: "iin is invalid"
    )
}
