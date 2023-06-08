//
//  FeatureOneFormComposer.swift
//  FormPoc
//
//  Created by Василий Клецкин on 6/5/23.
//

import Foundation

enum FeatureOneFormComposer {
    static func composeFeatureOne(
        submit: @escaping Submit<FeatureOneSubmitRequest>,
        iinValidation: @escaping AsyncValidation
    ) -> FeatureOneFormController {
        let inputs = composeFeatureOneInputs(iinValidation: iinValidation)
        return composeFeatureOneForm(inputs: inputs, submit: submit)
    }

    static private func composeFeatureOneForm(
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

    static private func composeFeatureOneViews(controller: FeatureOneFormController) -> Views<DispatchDecorator<FeatureSubmitViewWrapper>, DispatchDecorator<FeatureValidationViewWrapper>> {
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

    static private func composeFeatureOneInputs(iinValidation: @escaping AsyncValidation) -> Inputs {
        let emailId = FeatureOneInputsIds.email
        let phoneId = FeatureOneInputsIds.phone
        let iinId = FeatureOneInputsIds.iin
        
        return [
            emailId: TextInputComposer.compose(validation: validateEmail, id: emailId),
            phoneId: TextInputComposer.compose(validation: validatePhone, id: phoneId),
            iinId: TextInputComposer.compose(validation: iinValidation, id: iinId)
        ]
    }
}
