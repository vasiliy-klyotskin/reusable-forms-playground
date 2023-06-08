//
//  TextInputPresenter.swift
//  FormPoc
//
//  Created by Василий Клецкин on 6/5/23.
//

import Foundation

protocol TextInputErrorView {
    func isDisplayingError() -> Bool
}

protocol TextInputView {
    func displayActive(_ active: Bool)
}

final class TextInputPresenter {
    private let view: TextInputView
    private let errorView: TextInputErrorView

    init(view: TextInputView, errorView: TextInputErrorView) {
        self.view = view
        self.errorView = errorView
    }

    func changed() {
        view.displayActive(true)
    }

    func began() {
        if !errorView.isDisplayingError() {
            view.displayActive(true)
        }
    }

    func finished() {
        view.displayActive(false)
    }
}
