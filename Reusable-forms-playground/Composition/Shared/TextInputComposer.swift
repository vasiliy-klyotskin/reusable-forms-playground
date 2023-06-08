//
//  TextInputComposer.swift
//  FormPoc
//
//  Created by Василий Клецкин on 6/7/23.
//

import Foundation

typealias AsyncValidation = (String) -> (@escaping (Result<TextValidationResult, Error>) -> Void) -> Void
typealias Validation = (String) -> TextValidationResult

func compose(
    validation: @escaping AsyncValidation,
    id: AnyHashable
) -> Input {
    typealias ValidationPresenter = LoadResourcePresenter<TextValidationResult, DispatchDecorator<TextInputViewController>>
    typealias ValidationAdapter = LoadingAdapter<TextValidationResult, DispatchDecorator<TextInputViewController>, String>
    
    let controller = TextInputViewController()
    let validationPresenter = ValidationPresenter(
        resourceView: DispatchDecorator(controller),
        loadingView: DispatchDecorator(controller),
        errorView: DispatchDecorator(controller),
        mapper: TextValidationResultViewModel.map
    )
    let validationAdapter = ValidationAdapter(
        presenter: validationPresenter,
        loader: validation
    )
    let inputPresenter = TextInputPresenter(
        view: controller,
        errorView: controller
    )
    
    controller.onCancel = validationAdapter.cancel
    controller.onBegin = { _ in inputPresenter.began() }
    controller.onChange = { _ in inputPresenter.changed() }
    controller.onFinish = { value in
        inputPresenter.finished()
        validationAdapter.handle(value)
    }
    
    return .init(controller: controller, validation: validation)
}

func compose(
    validation: @escaping Validation,
    id: AnyHashable
) -> Input {
    compose(validation: toAsync(sync: validation), id: id)
}
