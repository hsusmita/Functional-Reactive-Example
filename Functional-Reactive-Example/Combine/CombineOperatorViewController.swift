//
//  CombineOperatorViewController.swift
//  Functional-Reactive-Example
//
//  Created by Susmita Horrow on 26/04/17.
//  Copyright © 2017 hsusmita. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

enum FormError: Error {
	case invalidEmail
	case invalidPassword
}

class CombineOperatorViewController: UIViewController {

	@IBOutlet weak var texttFieldEmail: UITextField!
	@IBOutlet weak var textFieldPassword: UITextField!
	@IBOutlet weak var buttonSignIn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
		combineLatest()
    }

	//MARK: - Combine Latest
	let emailString: MutableProperty<String> = MutableProperty<String>("")
	let passwordString: MutableProperty<String> = MutableProperty<String>("")
	let isValidForm: MutableProperty<Bool> = MutableProperty<Bool>(false)

	func combineLatest() {

		emailString <~ texttFieldEmail.reactive.continuousTextValues.skipNil()
		passwordString <~ textFieldPassword.reactive.continuousTextValues.skipNil()

		isValidForm <~ emailString.combineLatest(with: passwordString).map{
			email, password in

			return CombineOperatorViewController.isValidEmail(testStr: email) && CombineOperatorViewController.isValidPassword(testStr: password)
		}

		buttonSignIn.reactive.isEnabled <~ isValidForm
	}
}

extension CombineOperatorViewController: Routable {
	static var storyboardId: String {
		return "CombineOperatorViewController"
	}
	
	static var storyboardName: String {
		return "Main"
	}
}

//MARK: - Util Methods
extension CombineOperatorViewController {
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
