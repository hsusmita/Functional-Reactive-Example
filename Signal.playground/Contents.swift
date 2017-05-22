//: Playground - noun: a place where people can play

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

var str = "Hello, playground"

let (signal, observer) = Signal<Int, NoError>.pipe()
observer.send(value: 1)
observer.send(value: 2)
observer.send(value: 3)
observer.send(value: 4)
//observer.sendCompleted()

let signalObserver = Observer<Int, NoError>(
	value: { value in
	print("value = \(value)")
}, completed: { 
	print("completed")
}, interrupted: {
	print("interrupted")
})

signal.observe(signalObserver)
let eventObserver = Observer<Int, NoError>({ event in
	print(event.value)
})
signal.observe(eventObserver)

observer.send(value: 10)
/*
/*let signalObserver: Observer<Int, NoError> = Observer(value: { value in
	print("value = \(value)")
}, failed: { (error) in
	print("error = \(error)")
}, completed: { 
	print("completed")
}, interrupted: { 
	print("interrupted")
})*/

let signalObserver: Observer<Int, NoError> = Observer { event in
	if event.isCompleted {
		print("completed")
	}
	if let value = event.value {
		print("value = \(value)")
	}
	if let error = event.error {
		print(error)
	}
	
}

/*let signalProducer: SignalProducer<Int, NoError> = SignalProducer { (observer, disposable) in
	observer.send(value: 1)
	observer.send(value: 2)
	observer.send(value: 3)
}
let disposable = signalProducer.start(signalObserver)
*/

//signal.on(value: { count in
//	print("side effects = \(count)")
//})
//
////signal.observe(signalObserver)
//
//observer.send(value: 1)
//observer.send(value: 2)
//observer.send(value: 3)
//observer.sendCompleted()
//
*/