//: Playground - noun: a place where people can play

import UIKit
import ReactiveSwift
import Result
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

class TranformationExamples {
	
	enum APIError: Swift.Error {
		case invalidRequest
		case serviceUnreachable
	}
	
	enum LoginError: Swift.Error {
		case loginUnsuccessful
		case loginParamInvalid
	}
	
	struct Person {
		init(dict: [String: Any]) {
		}
	}
	
	func mapExample() { // Example of Map
		let (numberSignal, inputNumberObserver) = Signal<Int, NoError>.pipe()
		let stringSignal: Signal<String, NoError>  = numberSignal.map { number in
			return "[\(number)]"
		}
		
		let stringSignalObserver = Observer<String, NoError>(value: { string in
			print(string)
		}, completed: {
			print("completed")
		}, interrupted: {
			print("interrupted")
		})
		stringSignal.observe(stringSignalObserver)
		
		inputNumberObserver.send(value: 1)
		inputNumberObserver.send(value: 2)
		inputNumberObserver.send(value: 3)
		inputNumberObserver.send(value: 4)
		inputNumberObserver.send(value: 5)
	}
	
	func filterExample() {
		let (numberSignal, inputNumberObserver) = Signal<Int, NoError>.pipe()
		let evenSignal: Signal<Int, NoError> = numberSignal.filter { $0 % 2 == 0 }
		let stringSignal: Signal<String, NoError>  = evenSignal.map { number in
			return "[\(number)]"
		}
		let stringSignalObserver = Observer<String, NoError>(value: { string in
			print(string)
		}, completed: {
			print("completed")
		}, interrupted: {
			print("interrupted")
		})
		stringSignal.observe(stringSignalObserver)
		
		inputNumberObserver.send(value: 1)
		inputNumberObserver.send(value: 2)
		inputNumberObserver.send(value: 3)
		inputNumberObserver.send(value: 4)
		inputNumberObserver.send(value: 5)
	}
	
	func mapErrorExample() {
		let loginSignalProducer = SignalProducer<[String: Any], APIError> { (sink, disposable) in
//			sink.send(value: [:])
			sink.send(error: APIError.invalidRequest)
		}
		
		let signalProducer: SignalProducer<Person, LoginError> = loginSignalProducer.mapError { (apiError) in
			switch apiError {
			case .invalidRequest:
				return LoginError.loginParamInvalid
				
			case .serviceUnreachable:
				return LoginError.loginUnsuccessful
			}
		}.map { info in
			return Person(dict: info)
		}
		
		let observer = Observer<Person, LoginError>.init(value: { person in
			print("value is = \(person)")
		}, failed: { (error) in
			print(error)
		}, completed: { 
			print("completed")
		}, interrupted: {
			
		})
		
		signalProducer.start(observer)
	}

	func filterMapExample() {
		let (numberSignal, inputNumberObserver) = Signal<Int?, NoError>.pipe()
		let stringSignal: Signal<String, NoError>  = numberSignal.filterMap { number in
//			return "[\(number)]"
			if let number = number {
				return "[\(number)]"
			} else {
				return nil
			}
		}
		
		let stringSignalObserver = Observer<String, NoError>(value: { string in
			print(string)
		}, completed: {
			print("completed")
		}, interrupted: {
			print("interrupted")
		})
		stringSignal.observe(stringSignalObserver)
		
		inputNumberObserver.send(value: 1)
		inputNumberObserver.send(value: 2)
		inputNumberObserver.send(value: nil)
		inputNumberObserver.send(value: 3)
		inputNumberObserver.send(value: 4)
		inputNumberObserver.send(value: 5)
	}
	/*
	It is kinda like `debounce`. The values sent would be dropped if it is emitted at a faster rate than what the scheduler is capable to drain.
	Say if in the main runloop `lazyMap(on: UIScheduler())` receives N values, at the end only the last sent would be evaluated.
	*/
	
	func lazyMapExample() {
		let (numberSignal, inputNumberObserver) = Signal<Int, NoError>.pipe()
		let scheduler = QueueScheduler(qos: .background, name: "queue", targeting: nil)
		let stringSignal: Signal<String, NoError>  = numberSignal.lazyMap(on: UIScheduler()) { (number) in
			return "[\(number)]"
		}
		let stringSignalObserver = Observer<String, NoError>(value: { string in
			print(string)
		}, completed: {
			print("completed")
		}, interrupted: {
			print("interrupted")
		})
//		scheduler.schedule {}
		stringSignal.observe(stringSignalObserver)
//		
//		DispatchQueue.main.asyncAfter(deadline: .now() + 1) { 
//			inputNumberObserver.send(value: 1)
//		}
//		
//		DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//			inputNumberObserver.send(value: 2)
//		}
//		DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//			inputNumberObserver.send(value: 3)
//		}
//		DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
//			inputNumberObserver.send(value: 4)
//		}
		
		inputNumberObserver.send(value: 2)
		inputNumberObserver.send(value: 3)
		inputNumberObserver.send(value: 4)
		inputNumberObserver.send(value: 5)
		inputNumberObserver.send(value: 6)
		inputNumberObserver.send(value: 7)
		inputNumberObserver.send(value: 8)

	}
}

let example = TranformationExamples()
//example.mapExample()
//example.filterExample()
//example.mapErrorExample()
//example.filterMapExample()
example.lazyMapExample()



