//
//  TurnScheduler.swift
//  Functional-Reactive-Example
//
//  Created by Susmita Horrow on 24/04/17.
//  Copyright © 2017 hsusmita. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

class TurnScheduler {
	public private(set) var turnChangeSignal: Signal<Int, NoError>
	private var counter: ReactiveCounter
	
	init(turnsForSlot: Int, numberOfSlots: Int) {
		counter = ReactiveCounter(timeInterval: 2.0)
		turnChangeSignal = counter.counterSignal
			.take(while: { count in
			return count < turnsForSlot * numberOfSlots
		})
			.map { count in
			return ((count) % turnsForSlot) + 1
		}
	}
	
	deinit {
		counter.stopTimer()
	}
}
