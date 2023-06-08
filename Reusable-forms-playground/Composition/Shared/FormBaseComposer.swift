//
//  FormBaseComposer.swift
//  FormPoc
//
//  Created by Василий Клецкин on 6/7/23.
//

import Foundation

enum FormBaseComposer<
    SubmitView: ResourceView,
    ValidationView: ResourceView,
    Request
> where
    ValidationView.ResourceViewModel == FormValidationResultViewModel,
    SubmitView.ResourceViewModel == Void
{
    typealias SubmitAdapter = LoadingAdapter<Void, SubmitView, Request>
    typealias SubmitPresenter = LoadResourcePresenter<Void, SubmitView>
    typealias ValidationAdapter = LoadingAdapter<FormValidationResult, AnyResourceView<ValidationView.ResourceViewModel>, Void>
    typealias ValidationPresenter = LoadResourcePresenter<FormValidationResult, AnyResourceView<ValidationView.ResourceViewModel>>
    
    static func compose(
        inputs: Inputs,
        views: Views<SubmitView, ValidationView>,
        submit: @escaping Submit<Request>,
        mapping: @escaping (FormValidationResult) throws -> Request
    ) -> (ValidationAdapter, SubmitAdapter) {
        let synchronizer = ValidationSynchronizer(inputs: inputs)
        let validationResourceView = DispatchDecorator(ResourceViewComposite(
            inputs.formInputs.erasedView,
            views.validationView.erasedView
        ))
        let validationLoadingView = DispatchDecorator(ResourceLoadingViewComposite(
            inputs.formInputs,
            views.validationLoadingView
        ))
        let validationPresenter = ValidationPresenter(
            resourceView: validationResourceView.erasedView,
            loadingView: validationLoadingView,
            errorView: views.validationErrorView,
            mapper: FormValidationResultViewModel.from
        )
        let validationAdapter = ValidationAdapter(
            presenter: validationPresenter,
            loader: { synchronizer.validate }
        )
        let submitPresenter = SubmitPresenter(
            resourceView: views.submitView,
            loadingView: views.submitLoadingView,
            errorView: views.submitErrorView
        )
        let submitAdapter = SubmitAdapter(
            presenter: submitPresenter,
            loader: submit
        )
        let requestPresenter = FormRequestPresenter(mapping: mapping)
        validationAdapter.onSuccess = requestPresenter.tryMakeRequest
        requestPresenter.onRequestReady = submitAdapter.handle
        return (validationAdapter, submitAdapter)
    }
}
