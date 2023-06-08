//
//  LoadingResourcePresenter.swift
//  FormPoc
//
//  Created by Василий Клецкин on 6/5/23.
//

import Foundation

public final class LoadResourcePresenter<Resource, View: ResourceView> {
    public typealias Mapper = (Resource) throws -> View.ResourceViewModel
    
    private let resourceView: View
    private let loadingView: ResourceLoadingView
    private let errorView: ResourceErrorView
    private let mapper: Mapper
    
    public init(
        resourceView: View,
        loadingView: ResourceLoadingView,
        errorView: ResourceErrorView,
        mapper: @escaping Mapper
    ) {
        self.resourceView = resourceView
        self.loadingView = loadingView
        self.errorView = errorView
        self.mapper = mapper
    }
    
    public init(
        resourceView: View,
        loadingView: ResourceLoadingView,
        errorView: ResourceErrorView
    ) where View.ResourceViewModel == Resource {
        self.resourceView = resourceView
        self.loadingView = loadingView
        self.errorView = errorView
        self.mapper = { $0 }
    }
    
    public func didStart() {
        errorView.display(.noError)
        loadingView.display(ResourceLoadingViewModel(isLoading: true))
    }
    
    public func didFinish(with resource: Resource) {
        do {
            resourceView.display(try mapper(resource))
            loadingView.display(ResourceLoadingViewModel(isLoading: false))
        } catch {
            didFinish(with: error)
        }
    }
    
    public func didFinish(with error: Error) {
        errorView.display(.error(message: error.localizedDescription))
        loadingView.display(ResourceLoadingViewModel(isLoading: false))
    }
    
    public func didCancel() {
        loadingView.display(.init(isLoading: false))
    }
}
