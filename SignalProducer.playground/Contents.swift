//: Playground - noun: a place where people can play

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

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



//SignalProducer with an action

let action: () -> Int = {
	let randomNumber: UInt32 = arc4random_uniform(100)
	return Int(randomNumber)
}

let actionSignalProducer: SignalProducer<Int, NoError> = SignalProducer(action)
//actionSignalProducer.start(observer)

//SignalProducer with single value

let singleValueSignalProducer: SignalProducer<Int, NoError> = SignalProducer(value: 5)

//singleValueSignalProducer.start(observer)

//SignalProducer with sequence of values

let sequenceSignalProducer: SignalProducer<Int, NoError> = SignalProducer([1, 2, 3, 4, 5])
//sequenceSignalProducer.start(observer)


/*//SignalProducer from a signal

let (signal, signalObserver) = Signal<String, NoError>.pipe()


let signalProducer: SignalProducer<String, NoError> = SignalProducer(signal)

let producerObserver: Observer<String, NoError> = Observer(value: { value in
	print("value = \(value)")
}, completed: {
	print("completed")
})

signalObserver.send(value: "first String")
signalObserver.send(value: "second String")
signalProducer.start(producerObserver)

signalObserver.send(value: "third String")
signalObserver.send(value: "fourth String")
signalObserver.sendCompleted()
*/

class SignalProducerDemo {
	var signalProducer: SignalProducer<String, NoError>
	let compositeDisposable: CompositeDisposable
	
	init() {
		compositeDisposable = CompositeDisposable()
		
		signalProducer = SignalProducer {
			(observer, disposable) in
			disposable.add {
				print("I've been disposed! I can clean my resources ;)")
			}
		
			DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
				if !disposable.isDisposed {
					print("Sending first value")
					observer.send(value: "1")
				}
			})
			DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
				//if !disposable.isDisposed {
					print("Sending second value")
					observer.send(value: "2")
				//}
			})
			DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
				//if !disposable.isDisposed {
					print("Sending third value")
					observer.send(value: "3")
				//}
			})
		}
	}
	
	func observeSignal() {
		let disposable = signalProducer.startWithValues { value in
			print("a lot of heavy lifting")
			print("value sent by producer: \(value)")
		}
		compositeDisposable += disposable
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
			disposable.dispose()
		}
	}
	
	func observeWithSignal() {
		signalProducer.startWithSignal {
			(signal, disposable) in
			signal.observeValues({ value in
				print("inside the signal = \(value)")
				if !disposable.isDisposed {
					print("perform action")
				} else {
					print("disposed")
				}
			})
			compositeDisposable += disposable
		}
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
			self.compositeDisposable.dispose()
		}
		
	}
	
	deinit {
		//compositeDisposable.dispose()
	}
}

let demo = SignalProducerDemo().observeWithSignal()

