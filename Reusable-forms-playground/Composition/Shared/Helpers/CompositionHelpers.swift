//
//  Adapters.swift
//  FormPoc
//
//  Created by Василий Клецкин on 6/7/23.
//

import Foundation

typealias Inputs = [AnyHashable: Input]

struct Input {
    let controller: TextInputViewController
    let validation: AsyncValidation
}

extension Inputs {
    var formInputs: FormTextInputs { .init(inputs: mapValues { $0.controller })  }
}

typealias Submit<Request> = (Request) -> (@escaping (Result<Void, Error>) -> Void) -> Void

typealias AsyncValidation = (String) -> (@escaping (Result<TextValidationResult, Error>) -> Void) -> Void

typealias Validation = (String) -> TextValidationResult

struct Views<SubmitView: ResourceView, ValidationView: ResourceView> {
    let submitErrorView: ResourceErrorView
    let submitLoadingView: ResourceLoadingView
    let submitView: SubmitView
    let validationErrorView: ResourceErrorView
    let validationLoadingView: ResourceLoadingView
    let validationView: ValidationView
}

func toAsync<I, R>(sync: @escaping (I) -> R) -> (I) -> ((Result<R, Error>) -> Void) -> Void {
    { value in
        { completion in
            completion(.success(sync(value)))
        }
    }
}

final class ResourceLoadingViewComposite: ResourceLoadingView {
    private let wrappies: [ResourceLoadingView]
    
    init(_ wrappies: ResourceLoadingView...) {
        self.wrappies = wrappies
    }
    
    func display(_ viewModel: ResourceLoadingViewModel) {
        wrappies.forEach { $0.display(viewModel) }
    }
}

final class ResourceViewComposite<Wrappee: ResourceView>: ResourceView {
    typealias ResourceViewModel = Wrappee.ResourceViewModel
    
    private let wrappees: [Wrappee]
    
    init(_ wrappees: Wrappee...) {
        self.wrappees = wrappees
    }
    
    func display(_ viewModel: ResourceViewModel) {
        wrappees.forEach { $0.display(viewModel) }
    }
}

final class AnyResourceView<ResourceViewModel>: ResourceView {
    typealias ResourceViewModel = ResourceViewModel
    
    var action: (ResourceViewModel) -> Void
    
    init<T: ResourceView>(_ wrappie: T) where T.ResourceViewModel == ResourceViewModel {
        action = wrappie.display
    }
    
    func display(_ viewModel: ResourceViewModel) {
        action(viewModel)
    }
}

extension ResourceView {
    var erasedView: AnyResourceView<ResourceViewModel> { .init(self) }
}
