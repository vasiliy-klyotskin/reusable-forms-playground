//
//  Disapatching.swift
//  InputFormPoc
//
//  Created by Василий Клецкин on 6/8/23.
//

import Foundation

final class DispatchDecorator<T: AnyObject> {
    let wrappie: T
    let queue: DispatchQueue
    
    init(_ wrappie: T, queue: DispatchQueue = .main) {
        self.wrappie = wrappie
        self.queue = queue
    }
    
    func dispatch(action: @escaping () -> Void) {
        if Thread.isMainThread && queue == .main {
            action()
        } else {
            queue.async { action() }
        }
    }
}

extension DispatchDecorator: ResourceLoadingView where T: ResourceLoadingView {
    func display(_ viewModel: ResourceLoadingViewModel) {
        dispatch { [weak wrappie] in wrappie?.display(viewModel) }
    }
}

extension DispatchDecorator: ResourceErrorView where T: ResourceErrorView {
    func display(_ viewModel: ResourceErrorViewModel) {
        dispatch { [weak wrappie] in wrappie?.display(viewModel) }
    }
}

extension DispatchDecorator: ResourceView where T: ResourceView {
    typealias ResourceViewModel = T.ResourceViewModel
    
    func display(_ viewModel: ResourceViewModel) {
        dispatch { [weak wrappie] in wrappie?.display(viewModel) }
    }
}
