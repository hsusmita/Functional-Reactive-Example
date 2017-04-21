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

	@IBOutlet weak var label: UILabel!
	@IBOutlet weak var textView: UITextView!
	@IBOutlet weak var nextButton: UIButton!
	@IBOutlet weak var statusLabel: UILabel!

	let result: MutableProperty<Bool> = MutableProperty(false)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		handleReactively()
	}
	
	func handleNonReactively() {
		// Non Reactive way
		label.text = textView.text
		textView.delegate = self
	}
	
	func handleReactively() {
		// Reactive Binding
		
		label.reactive.text <~ textView.reactive.continuousTextValues
		
		// MutableProperty as Binding Target
		let signal: Signal<Bool, NoError> = textView.reactive.continuousTextValues.map { (string) in
			guard let string = string else {
				return false
			}
			return string.characters.count > 20
		}
		let _ = result <~ signal
		
		// UIKit Binding target
		nextButton.reactive.isEnabled <~ result
		
		// Custom Binding Target
		let bindingTarget: BindingTarget<Bool> = statusLabel.reactive.makeBindingTarget { label, result in
			label.backgroundColor = result ? UIColor.green : UIColor.red
			label.text = result ? "Valid" :  "Not valid"
		}
		let _ = bindingTarget <~ result // MutableProperty as Binding Source
		let observer = Observer<Bool, NoError> { (event) in
			switch event {
			case let .value(v):
				print("value is \(v)")
				
			default:
				break
			}
		}
		
		let observer2 = Observer<Bool, NoError> { (event) in
			switch event {
			case let .value(v):
				print("value is \(v) observer2")
				
			default:
				break
			}
		}
		result.signal.observe(observer)
		observer.send(value: true)
		
		//An observer is something which defines the ways to handle different events of a signal.
		
		result.signal.observe(observer, during: self.reactive.lifetime)
		let (sig, sink) = Signal<Int, NoError>.pipe()
		sink.send(value: 1)
		
		let gesture = UITapGestureRecognizer(target: self, action: #selector(handleSelector(gesture:)))
	}
	
	func handleSelector(gesture: UITapGestureRecognizer) {
		
	}
}

extension BindingViewController: UITextViewDelegate {
	func textViewDidChange(_ textView: UITextView) {
		label.text = textView.text
		
		if let string = textView.text, string.characters.count > 20 {
			statusLabel.backgroundColor = UIColor.green
			statusLabel.text = "Valid"
			nextButton.isEnabled = true
		} else {
			statusLabel.backgroundColor = UIColor.red
			statusLabel.text = "Not Valid"
			nextButton.isEnabled = false
		}
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
