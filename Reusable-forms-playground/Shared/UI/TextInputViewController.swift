//
//  Abstract.swift
//  FormPoc
//
//  Created by Василий Клецкин on 6/5/23.
//

import UIKit

final class TextInputViewController: NSObject, UITextFieldDelegate {
    var onChange: ((String) -> Void)?
    var onBegin: ((String) -> Void)?
    var onFinish: ((String) -> Void)?
    var onCancel: (() -> Void)?
    
    let view = UITextField()
    
    private let loadingView = UIActivityIndicatorView()
    
    override init() {
        super.init()
        view.delegate = self
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        
        ])
    }
    
    var text: String { view.text ?? "" }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        onBegin?(textField.text ?? "")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        onFinish?(textField.text ?? "")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        onChange?(newText ?? "")
        return true
    }
    
    func cancel() {
        onCancel?()
    }
}

extension TextInputViewController: TextInputView {
    func displayActive(_ active: Bool) {
        if active {
            view.backgroundColor = .green
        } else {
            view.backgroundColor = .clear
        }
    }
}

extension TextInputViewController: TextInputErrorView {
    func isDisplayingError() -> Bool {
        view.backgroundColor == .red
    }
}

extension TextInputViewController: ResourceLoadingView {
    func display(_ viewModel: ResourceLoadingViewModel) {
        if viewModel.isLoading {
            loadingView.startAnimating()
        } else {
            loadingView.stopAnimating()
        }
    }
}

extension TextInputViewController: ResourceView {
    typealias ResourceViewModel = TextValidationResultViewModel
    
    func display(_ viewModel: ResourceViewModel) {
        if viewModel.needToShowValidationFail {
            view.backgroundColor = .red
        } else {
            view.backgroundColor = .clear
        }
    }
}

extension TextInputViewController: ResourceErrorView {
    func display(_ viewModel: ResourceErrorViewModel) {}
}
