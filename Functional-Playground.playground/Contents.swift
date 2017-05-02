//: Playground - noun: a place where people can play

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

var str = "Hello, playground"

let observer: Observer<Int, NoError> = Observer.init(value: { value in
	print("value = \(value)")
}, failed: { (error) in
	print("error = \(error)")
}, completed: { 
	print("signal completed")
}, interrupted: {
	print("signal interrupted")
})

let action: () -> Int = {
	let randomNumber: UInt32 = arc4random_uniform(100)
	return Int(randomNumber)
}

let signalProducer: SignalProducer<Int, NoError> = SignalProducer(action)
signalProducer.start(observer)

