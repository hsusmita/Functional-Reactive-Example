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
	
	init(timeInterval: TimeInterval) {
		let (timerSignal, timerObserver) = Signal<Void, NoError>.pipe()
		timerObserver.send(value: ())
		timer = Timer.scheduledTimer(withTimeInterval: timeInterval,
		                             repeats: true,
		                             block: { timer in
										timerObserver.send(value: ())
		})
		
		timer.fire()
		
		counterSignal = timerSignal.scan(-1) { (count, _)  in
			return count + 1
		}
	}
	
	func stopTimer() {
		timer.invalidate()
	}
	
	deinit {
		timer.invalidate()
	}
}
