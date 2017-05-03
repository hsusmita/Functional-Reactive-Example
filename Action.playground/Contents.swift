//: Playground - noun: a place where people can play

import UIKit
import ReactiveSwift
import Result

var str = "Hello, playground"

let action = Action<Int, String, NoError> { number -> SignalProducer<String, NoError> in
	return SignalProducer<String, NoError> { (innerObserver, disposable) in
		innerObserver.send(value: "\(number * 3)")
		innerObserver.sendCompleted()
	}
}

let numberSignalProducer = action.apply(1)

let observer: Observer<String, ActionError<NoError>> = Observer(value: { (value) in
	print("value received = \(value)")
})
numberSignalProducer.start(observer)
