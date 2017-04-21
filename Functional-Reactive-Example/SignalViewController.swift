//
//  SignalViewController.swift
//  Functional-Reactive-Example
//
//  Created by Susmita Horrow on 21/04/17.
//  Copyright © 2017 hsusmita. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

class SignalViewController: UIViewController {
	var turnSheduler: TurnScheduler!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		turnSheduler = TurnScheduler(numberOfPlayers: 4)
		turnSheduler.turnChangeSignal.observeValues { count in
			print(count)
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SignalViewController: Routable {
	static var storyboardId: String {
		return "SignalViewController"
	}
	static var storyboardName: String {
		return "Main"
	}
}

class TurnScheduler {
	public private(set) var turnChangeSignal: Signal<Int, NoError>
	private var counter: ReactiveCounter

	init(numberOfPlayers: Int) {
		counter = ReactiveCounter(timeInterval: 1.5)
		turnChangeSignal = counter.counterSignal.map({ count in
			return ((count) % numberOfPlayers) + 1
		})
	}
	
	deinit {
		counter.stopTimer()
	}
}

class ReactiveCounter {
	private var timer: Timer
	public private(set) var counterSignal: Signal<Int, NoError>
	
	init(timeInterval: TimeInterval) {
		var signals: [Signal<Void, NoError>] = []
		let (timerSignal, timerObserver) = Signal<Void, NoError>.pipe()
		
		timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { timer in
			timerObserver.send(value: ())
			signals.append(timerSignal)
		})
		
		timer.fire()
		
		counterSignal = Signal.merge(signals).scan(-1) { (count, _)  in
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
