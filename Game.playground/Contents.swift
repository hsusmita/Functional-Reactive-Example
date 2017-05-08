//: Playground - noun: a place where people can play

import Foundation
import ReactiveSwift
import Result
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

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

let counter = ReactiveCounter(timeInterval: 1.0)
//counter.counterSignal.observeValues { (count) in
//	print(count)
//}
counter.stopTimer()


//counter.counterSignal.flatMap(.merge) { (count)  in
//	SignalProducer(value: "value = \(count)")
//}.observeValues { string in
//	print(string)
//}
//
//counter.counterSignal.map { count in
//	return "value = \(count)"
//	}.observeValues { string in
//	print(string)
//}
//
