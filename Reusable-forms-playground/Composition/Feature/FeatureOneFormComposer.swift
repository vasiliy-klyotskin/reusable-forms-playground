//
//  Composer.swift
//  FormPoc
//
//  Created by Василий Клецкин on 6/5/23.
//

import Foundation

func composeFeatureOne(
    submit: @escaping Submit<FeatureOneSubmitRequest>,
    iinValidation: @escaping AsyncValidation
) -> FeatureOneFormController {
    let inputs = composeFeatureOneInputs(iinValidation: iinValidation)
    return composeFeatureOneForm(inputs: inputs, submit: submit)
}

func composeFeatureOneForm(
    inputs: Inputs,
    submit: @escaping Submit<FeatureOneSubmitRequest>
) -> FeatureOneFormController {
    let formController = FeatureOneFormController(inputs: inputs.formInputs)
    let (validation, submission) = FormBaseComposer.compose(
        inputs: inputs,
        views: composeFeatureOneViews(controller: formController),
        submit: submit,
        mapping: mapInputToRequest
    )
    let featureOnePresenter = FeatureOneFormPresenterNew(view: formController)
    formController.onSubmit = featureOnePresenter.proceedSubmittingWithCheckingPolicies
    featureOnePresenter.onAgreedWithPolicies = validation.handle
    submission.onSuccess = { _ in print("Happy path") }
    return formController
}

func composeFeatureOneViews(controller: FeatureOneFormController) -> Views<DispatchDecorator<FeatureSubmitViewWrapper>, DispatchDecorator<FeatureValidationViewWrapper>> {
    let submitView = FeatureSubmitViewWrapper(controller)
    let validationView = FeatureValidationViewWrapper(controller)
    return .init(
        submitErrorView: DispatchDecorator(submitView),
        submitLoadingView: DispatchDecorator(submitView),
        submitView: DispatchDecorator(submitView),
        validationErrorView: DispatchDecorator(validationView),
        validationLoadingView: DispatchDecorator(validationView),
        validationView: DispatchDecorator(validationView)
    )
}

func composeFeatureOneInputs(iinValidation: @escaping AsyncValidation) -> Inputs {
    let emailId = FeatureOneInputsIds.email
    let phoneId = FeatureOneInputsIds.phone
    let iinId = FeatureOneInputsIds.iin
    
    return [
        emailId: compose(validation: validateEmail, id: emailId),
        phoneId: compose(validation: validatePhone, id: phoneId),
        iinId: compose(validation: iinValidation, id: iinId)
    ]
}
