//
//  BindingViewController.swift
//  Functional-Reactive-Example
//
//  Created by Susmita Horrow on 19/04/17.
//  Copyright © 2017 hsusmita. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result
import ReactiveCocoa

class BindingViewController: UIViewController {

	@IBOutlet weak var textField: UITextField!
	let x: MutableProperty<UIColor> = MutableProperty(UIColor.red)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let binding: BindingTarget<UIColor> = self.reactive.makeBindingTarget { (controller, color) in
				controller.view.backgroundColor = color
				controller.textField.textColor = color
		}
		let sp = textField.reactive.continuousTextValues.flatMap(FlattenStrategy.concat) { (string) in
			return SignalProducer<UIColor, NoError> { (observer, disposable) in
				if (string?.characters.count)! > 10 {
					observer.send(value: UIColor.blue)
				} else {
					observer.send(value: UIColor.red)
				}
				observer.sendCompleted()
			}
		}
//		textField.reactive.textColor <~ sp
		x <~ sp
		binding <~ sp
		x.signal.observeValues { (color) in
			print(color)
		}
		
		/*
			How to bind?
		*/
		let label = UILabel()
		label.text = textField.text
		
		label.reactive.text <~ textField.reactive.continuousTextValues

	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

extension BindingViewController: Routable {
	static var storyboardId: String {
		return "BindingViewController"
	}
	static var storyboardName: String {
		return "Main"
	}
}
