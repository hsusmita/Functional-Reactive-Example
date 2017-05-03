//: Playground - noun: a place where people can play

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

var str = "Hello, playground"

struct MyError: Error {
	
}


// Signal
print("------ Signal basic ------")
let (signal, innerObserver) = Signal<Int, MyError>.pipe()
signal.observeResult { result in
	switch result {
	case let .success(value):
		print("value: \(value)")
	case let .failure(error):
		print("error: \(error)")
	}
}

innerObserver.send(value: 1) // print "1"
innerObserver.send(value: 2)
innerObserver.send(value: 3)

// if Error is `NoError`, you can use `observeValues`

// SignalProducer
print("\n------ SignalProducer basic ------")
let signalProducer = SignalProducer<Int, MyError> { (innerObserver, disposable) in
	print("startHandler called")
	innerObserver.send(value: 1)
}
signalProducer.start()
// This trailing closure is `startHandler`.
// When `start() called`,
// 1. a signal is created.
// 2. `startHandler` is called. Passed observer(first argument) is the innerObserver of the created signal.

signalProducer.startWithResult { result in
	switch result {
	case let .success(value):
		print("value: \(value)")
	case let .failure(error):
		print("error: \(error)")
	}
}
// startWithResult logics
// 1. a signal is created.
// 2. Passed trailing closure is registerd to the created signal
// 3. `startHandler` is called

signalProducer.startWithSignal { (signal, disposable) in
	print("You can access created signal here")
}




// MutableProperty: Read Write
// used for states of views, models ....
print("\n------ MutableProperty basic ------")
let mutableProperty = MutableProperty<Int>(0) // 0 is initial value
print(mutableProperty.value) // print 0
mutableProperty.value = 1
print(mutableProperty.value) // print 1

mutableProperty.signal // get Signal of property change
mutableProperty.producer // get SignalProducer of property change

// example
mutableProperty.signal
	.observeValues { value in
}



// Property: Read-only
print("\n------ Property basic ------")
let property = Property(mutableProperty)
print(property.value) // OK
// property.value = 1 // NG



// Action: return SignalProducer
// Action is used for network requests, UI actions, ....
print("\n------ Action basic ------")
let action = Action<Int, String, MyError> { number -> SignalProducer<String, MyError> in
	return SignalProducer<String, MyError> { (innerObserver, disposable) in
		innerObserver.send(value: "\(number)")
		innerObserver.sendCompleted()
	}
}
let number1SignalProducer = action.apply(1) // SignalProducer<String, MyError>
number1SignalProducer.start()

// to observe action
action.values // get signal of values
action.errors // get signal of errors

