//
//  FeatureOneFormController.swift
//  FormPoc
//
//  Created by Василий Клецкин on 6/6/23.
//

import UIKit

final class FeatureOneFormController: UIViewController {
    var onSubmit: (() -> Void)?
    private var inputs: FormTextInputs?
    
    @IBOutlet weak var phoneField: UIView!
    @IBOutlet weak var emailField: UIView!
    @IBOutlet weak var iinField: UIView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var switchControl: UISwitch!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBAction func submitPressed(_ sender: Any) {
        onSubmit?()
    }
    
    convenience init(inputs: FormTextInputs) {
        self.init()
        self.inputs = inputs
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bundle = Bundle(for: Self.self)
        bundle.loadNibNamed(String(describing: Self.self), owner: self)
        guard let inputs = self.inputs else { return }
        inputs[FeatureOneInputsIds.iin]?.view.fixIn(view: iinField)
        inputs[FeatureOneInputsIds.phone]?.view.fixIn(view: phoneField)
        inputs[FeatureOneInputsIds.email]?.view.fixIn(view: emailField)
    }
}

extension FeatureOneFormController: FeatureOneFormView {
    func showSubmitSuccess() {
        statusLabel.text = "Form has been submitted!"
    }
    
    func showSubmitError(show: Bool) {
        if show {
            statusLabel.text = "Submission error"
        }
    }
    
    func showSubmmitIndication(_ isLoading: Bool) {
        if isLoading {
            statusLabel.text = "Performing submission..."
        }
    }
    
    func showValidationIndication(_ isValidating: Bool) {
        if isValidating {
            statusLabel.text = "Performing presubmit validation..."
        }
    }
    
    func showValidationFail(_ result: FormValidationResultViewModel) {
        if result.needToShowValidationFail {
            statusLabel.text = "Presubmit validation failed"
        }
    }
    
    func displayPolicyNotification() {
        showAlert(title: "Important", message: "You need to agree to the terms and conditions")
    }
    
    func isAgreedWithPolicies() -> Bool {
        switchControl.isOn
    }
    
    private func showAlert(title: String, message: String) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.addAction(.init(title: "Ok", style: .default))
        present(controller, animated: true)
    }
}
