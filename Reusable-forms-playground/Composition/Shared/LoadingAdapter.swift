//
//  LoadingAdapter.swift
//  FormPoc
//
//  Created by Василий Клецкин on 6/5/23.
//

import Foundation

import Foundation

final class LoadingAdapter<Model, View: ResourceView, Request> {
    typealias Loader<Model> = (@escaping (Result<Model, Error>) -> Void) -> Void
    private let presenter: LoadResourcePresenter<Model, View>
    private let loader: (Request) -> Loader<Model>
    
    var onError: ((Error) -> Void)?
    var onSuccess: ((Model) -> Void)?
    
    private var token = UUID()
    
    init(presenter: LoadResourcePresenter<Model, View>, loader: @escaping (Request) -> Loader<Model>) {
        self.presenter = presenter
        self.loader = loader
    }
    
    func handle(_ input: Request) {
        cancel()
        presenter.didStart()
        let load = loader(input)
        let taskToken = self.token
        load() { [weak self] result in
            guard let self = self else { return }
            guard taskToken == self.token else { return }
            switch result {
            case .success(let model):
                self.onSuccess?(model)
                self.presenter.didFinish(with: model)
            case .failure(let error):
                self.onError?(error)
                self.presenter.didFinish(with: error)
            }
        }
    }
    
    func cancel() {
        token = UUID()
        presenter.didCancel()
    }
}

extension LoadingAdapter where Request == Void {
    func handle() { handle(()) }
}
