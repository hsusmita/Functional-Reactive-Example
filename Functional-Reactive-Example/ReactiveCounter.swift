//
//  ReactiveCounter.swift
//  Functional-Reactive-Example
//
//  Created by Susmita Horrow on 24/04/17.
//  Copyright © 2017 hsusmita. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

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
