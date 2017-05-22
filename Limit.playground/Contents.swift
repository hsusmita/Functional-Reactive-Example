//: Playground - noun: a place where people can play

import UIKit
import ReactiveSwift
import Result
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

var str = "Hello, playground"


class ReactiveCounter {
	private var timer: Timer
	public private(set) var counterSignal: Signal<Int, NoError>
	private var timerObserver: Observer<Void, NoError>
	
	init(timeInterval: TimeInterval) {
		let (timerSignal, timerObserver) = Signal<Void, NoError>.pipe()
		
		Timer.scheduledTimer(withTimeInterval: 0, repeats: false) { _ in
			timerObserver.send(value: ())
		}
		timer = Timer.scheduledTimer(withTimeInterval: timeInterval,
		                             repeats: true,
		                             block: { timer in
										timerObserver.send(value: ())
		})
		counterSignal = timerSignal.scan(-1) { (count, _)  in
			return count + 1
		}
		self.timerObserver = timerObserver
	}
	
	
	func stopTimer() {
		timerObserver.sendCompleted()
		timer.invalidate()
	}
	
	deinit {
		timerObserver.sendCompleted()
		timer.invalidate()
	}
}

struct Person {
	var name: String
}

extension Person: Equatable {}

func ==(left: Person, right: Person) -> Bool {
	return left.name == right.name
}

class LimitExample {
	let reactiveCounter = ReactiveCounter(timeInterval: 1)
	let stringSignalProducer = SignalProducer<String, NoError> ({ observer, disposable in
		observer.send(value: "hello 1")
		observer.send(value: "world")
		observer.send(value: "world")
		observer.send(value: "world")
		observer.send(value: "hello 3")
		observer.send(value: "hello 4")
		observer.send(value: "hello 5")
		observer.send(value: "hello 5")
		observer.send(value: "hello 5")
		observer.send(value: "hello 6")
		observer.send(value: "world")
		observer.send(value: "world")
		observer.send(value: "world")
		observer.sendCompleted()
	})
	
	let personSignalProducer = SignalProducer<Person, NoError>({ observer, disposable in
		observer.send(value: Person(name: "person 1"))
		observer.send(value: Person(name: "person 2"))
		observer.send(value: Person(name: "person 3"))
		observer.send(value: Person(name: "person 4"))
		observer.send(value: Person(name: "person 5"))
		observer.send(value: Person(name: "person 3"))
		observer.send(value: Person(name: "person 2"))
		observer.sendCompleted()
	})
	
	func startBlockingSignal() -> Signal<(), NoError> {
		let (signal, observer) = Signal<(), NoError>.pipe()
		DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
			observer.send(value: ())
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
			observer.sendCompleted()
		}
		return signal
	}
	
	func startIntegerBlockingSignal() -> Signal<(Int), NoError> {
		let (signal, observer) = Signal<Int, NoError>.pipe()
		DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
			observer.send(value: (100))
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + 6.5) {
			observer.send(value: (200))
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
			observer.send(value: (300))
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + 8.5) {
			observer.sendCompleted()
		}
		return signal
	}
	

	func skipFirstExample() {
		let observer = Observer<Int, NoError>(value: { (number) in
			print("number is \(number)")
		})
		reactiveCounter.counterSignal.skip(first: 5).observe(observer)
	}
	
	func skipWhileExample() {
		let observer = Observer<Int, NoError>(value: { (number) in
			print("number is \(number)")
		})
		reactiveCounter.counterSignal.skip(while: { (number) in
			number < 10
		}).observe(observer)
	}
	
	func skipUntilExample() {
		let observer = Observer<Int, NoError>(value: { (number) in
			print("number is \(number)")
		})
		let blockingSignal = startBlockingSignal()
		reactiveCounter.counterSignal.skip(until: blockingSignal).observe(observer)
	}
	
	func skipRepeatsExample() {
		let stringObserver = Observer<String, NoError> { string in
			print("current string is = \(string)")
		}
		stringSignalProducer.skipRepeats().start(stringObserver)
		
		stringSignalProducer.skipRepeats { (firstString, secondString) -> Bool in
			firstString.characters.count == secondString.characters.count
			}.start(stringObserver)
	}
	
	func uniqueValueExample() {
		let stringObserver = Observer<String, NoError> { string in
			print("current string is = \(string)")
		}
//		stringSignalProducer.uniqueValues().start(stringObserver)
		
		let personObserver = Observer<Person, NoError>(value: { person in
			print("Current person is = \(person.name)")
		})
		
		//personSignalProducer.start(personObserver)

		personSignalProducer.uniqueValues { (person) in
			person.name
		}.start(personObserver)
	}
	
	func takeUntilExample() {
		let observer = Observer<Int, NoError>(value: { (number) in
			print("number is \(number)")
		})
		let blockingSignal = startBlockingSignal()
		reactiveCounter.counterSignal.take(until: blockingSignal).observe(observer)
	}
	
	func takeUntilReplacementExample() {
		let observer = Observer<Int, NoError>(value: { (number) in
			print("number is \(number)")
		})
		let blockingSignal = startIntegerBlockingSignal()
		reactiveCounter.counterSignal.take(untilReplacement: blockingSignal).observe(observer)
	}
	
	func takeLastExample() {
		let observer = Observer<Int, NoError>(value: { (number) in
			print("number is \(number)")
		})
		DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] _ in
			self?.reactiveCounter.stopTimer()
		}
		reactiveCounter.counterSignal.take(last: 2).observe(observer)
	}
	
	func takeFirstExample() {
		let observer = Observer<Int, NoError>(value: { (number) in
			print("number is \(number)")
		})
		reactiveCounter.counterSignal.take(first: 2).observe(observer)
	}
	
	func takeWhileExample() {
		let observer = Observer<Int, NoError>(value: { (number) in
			print("number is \(number)")
		})
		reactiveCounter.counterSignal.take { (number) -> Bool in
			number < 10
		}.observe(observer)
	}
	func startDoubleSignal() -> Signal<(Double), NoError> {
		let (signal, observer) = Signal<Double, NoError>.pipe()
		DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
			observer.send(value: (1))
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
			observer.send(value: (1.25))
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
			observer.send(value: (1.5))
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
			observer.send(value: (2))
		}
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 2.25) {
			observer.send(value: (2.25))
		}

		DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
			observer.send(value: (2.5))
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
			observer.send(value: (3))
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
			observer.send(value: (4))
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + 4.75) {
			observer.send(value: (4.75))
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
			observer.send(value: (5))
		}
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 5.25) {
			observer.send(value: (5.25))
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
			observer.send(value: (5.5))
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + 5.75) {
			observer.send(value: (5.75))
		}
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
			observer.sendCompleted()
		}
		return signal
	}

	func debounceExample() {
		let observer = Observer<Double, NoError>(value: { (number) in
			print("number is \(number)")
		})
		let observer1 = Observer<Double, NoError>(value: { (number) in
			print("original number is \(number)")
		})
		let blockingSignal = startDoubleSignal()
		//blockingSignal.debounce(1, on: QueueScheduler.main).observe(observer)
		blockingSignal.observe(observer1)
		blockingSignal.debounce(1, on: QueueScheduler.main).observe(observer)
	}
}
/*
/// Forward the latest value on `scheduler` after at least `interval`
/// seconds have passed since *the returned signal* last sent a value. throttle

*/

/*
/// Forward the latest value on `scheduler` after at least `interval`
/// seconds have passed since `self` last sent a value. debounds
///

*/
let limitExample = LimitExample()
//limitExample.skipFirstExample()
//limitExample.skipWhileExample()
//limitExample.skipUntilExample()
//limitExample.skipRepeatsExample()
//limitExample.uniqueValueExample()
//limitExample.takeUntilExample()
//limitExample.takeUntilReplacementExample()
//limitExample.takeLastExample()
//limitExample.takeFirstExample()
//limitExample.takeWhileExample()
limitExample.debounceExample()
