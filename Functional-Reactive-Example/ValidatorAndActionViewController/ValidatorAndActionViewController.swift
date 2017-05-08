//
//  ValidatorAndActionViewController.swift
//  Functional-Reactive-Example
//
//  Created by Pulkit Vaid on 27/04/17.
//  Copyright © 2017 hsusmita. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result

enum LoginError: Error {
	case invalidCredentials
	case loginError
}

struct Person {
	var fName: String
	var lName: String
}


class ValidatorAndActionViewController: UIViewController {

	@IBOutlet weak var textFieldEmail: UITextField!
	@IBOutlet weak var textFieldPassword: UITextField!
	@IBOutlet weak var buttonSignIn: UIButton!

	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
		validatingProperty()
		setupAction()

		activityIndicator.hidesWhenStopped = true
		activityIndicator.reactive.isAnimating <~ loginAction.isExecuting
    }

	//MARK: - Action
	let viewModel: FormVieWModel = FormVieWModel()
	let loginAction: Action<(email: String, password: String), Person, LoginError>

	func setupAction() {

		loginAction.events.observeValues {
			event in
			switch event {
			case .value(let person):
				print(person)
				print("Login Success")
			case .failed(let loginError):
				print("Login Failure")
				print(loginError)
			default:
				print("event default case")
			}
		}

		buttonSignIn.reactive.controlEvents(.touchUpInside).observeValues {
			[unowned self]
			_ in
			self.loginAction.apply((email: self.email_ValidatingProperty.value , password: self.password_ValidatingProperty.value))
				.start()
		}
	}

	let emailString: MutableProperty<String> = MutableProperty<String>("")
	let passwordString: MutableProperty<String> = MutableProperty<String>("")

	//MARK: - ValidatingProperty
	let email_ValidatingProperty: ValidatingProperty<String, FormError>
	let password_ValidatingProperty: ValidatingProperty<String, FormError>
	let isFormValid_ValidatingProperty: MutableProperty<Bool> = MutableProperty<Bool>(false)

	required init?(coder aDecoder: NSCoder) {

		//Validating Property
		email_ValidatingProperty = ValidatingProperty<String, FormError>(emailString) {
			input in
			return ValidatorAndActionViewController.isValidEmail(testStr: input) ? ValidatorOutput.valid : ValidatorOutput.invalid(.invalidEmail)
		}

		email_ValidatingProperty.signal.observeValues { (string) in
			print(string)
		}

		password_ValidatingProperty = ValidatingProperty<String, FormError>(passwordString) {
			input in
			ValidatorAndActionViewController.isValidPassword(testStr: input) ? .valid : .invalid(.invalidPassword)
		}

		isFormValid_ValidatingProperty <~ Property.combineLatest(email_ValidatingProperty.result, password_ValidatingProperty.result)
			.signal
			.map {
				emailResult, passwordResult in
				print("-------")
				return !emailResult.isInvalid && !passwordResult.isInvalid
		}

		//Action
		loginAction = Action(enabledIf: isFormValid_ValidatingProperty, viewModel.loginWithEmail)
		
		super.init(coder: aDecoder)
	}

	func validatingProperty() {
		emailString <~ textFieldEmail.reactive.continuousTextValues.skipNil()
		passwordString <~ textFieldPassword.reactive.continuousTextValues.skipNil()
		buttonSignIn.reactive.isEnabled <~ isFormValid_ValidatingProperty
	}
}


extension ValidatorAndActionViewController: Routable {
	static var storyboardId: String {
		return "ValidatorAndActionViewController"
	}

	static var storyboardName: String {
		return "Main"
	}
}

//MARK: - Util Methods
extension ValidatorAndActionViewController {
	static func isValidEmail(testStr:String) -> Bool {
		print(testStr)
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
		let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
		return emailTest.evaluate(with: testStr)
	}

	static func isValidPassword(testStr: String) -> Bool {
		print(testStr)
		return testStr.characters.count > 4
	}
}


class FormVieWModel {

	func loginWithEmail(email: String, password: String) -> SignalProducer<Person, LoginError> {
		return SignalProducer {
			sink, disposable in

			let myEmail = "pulkit@fueled.com"
			let myPassword = "password"

			if email == myEmail && password == myPassword {
				sink.send(value: Person(fName: "Pulkit", lName: "Vaid"))
				DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: { 
					sink.sendCompleted()
				})

			}
			else {
				sink.send(error: LoginError.invalidCredentials)
			}

			disposable.add {
				print("disposed called / clean up code")
			}
		}
	}
	
}
