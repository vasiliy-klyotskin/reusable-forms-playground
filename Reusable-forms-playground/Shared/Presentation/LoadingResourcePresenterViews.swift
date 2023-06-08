//
//  LoadingResourcePresenterViews.swift
//  FormPoc
//
//  Created by Василий Клецкин on 6/5/23.
//

import Foundation

public protocol ResourceView {
    associatedtype ResourceViewModel
    func display(_ viewModel: ResourceViewModel)
}

public protocol ResourceLoadingView {
    func display(_ viewModel: ResourceLoadingViewModel)
}

public protocol ResourceErrorView {
    func display(_ viewModel: ResourceErrorViewModel)
}

public struct ResourceLoadingViewModel {
    public let isLoading: Bool
}

public struct ResourceErrorViewModel {
    public let message: String?
    
    static var noError: ResourceErrorViewModel {
        return ResourceErrorViewModel(message: nil)
    }
    
    static func error(message: String) -> ResourceErrorViewModel {
        return ResourceErrorViewModel(message: message)
    }
}

struct DummyView: ResourceErrorView, ResourceLoadingView {
    func display(_ viewModel: ResourceErrorViewModel) {}
    func display(_ viewModel: ResourceLoadingViewModel) {}
}
