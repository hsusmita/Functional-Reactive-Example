//
//  SignalViewController.swift
//  Functional-Reactive-Example
//
//  Created by Susmita Horrow on 21/04/17.
//  Copyright © 2017 hsusmita. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result

class SignalViewController: UIViewController {
	var turnScheduler: TurnScheduler!
	@IBOutlet weak var label: UILabel!
	let gridView = GameGrid.gameGridView()
	let currentColor = MutableProperty<Int>(0)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		gridView.frame = CGRect(x: 0, y: 100, width: 400, height: 200)
		self.view.addSubview(gridView)
		gridView.configure(with: Grid(row: 5, column: 5))
		gridView.start()
		
		let colors = gridView.colors
		turnScheduler = TurnScheduler(numberOfTurns: colors.count)
		let observer: Observer<Int, NoError> = Observer(value: { [unowned self] count in
			
			self.label.text = "Tap grid of \(self.gridView.colorsName[count - 1]) Color"
			self.label.backgroundColor = colors[count - 1]
		})
		
		turnScheduler.turnChangeSignal.observe(observer)		
		turnScheduler.turnChangeSignal.observeValues { [unowned self] currentTurn in
			self.currentColor.value = currentTurn
		}
		
		gridView.selectedRowSignal.observeValues { value in
			let hit = value == self.currentColor.value
			print(hit)
		}
		
//		signalProducerFromSignal()
		createSignalProducer()
	}
	
	func createSignalProducer() {
		let sp: SignalProducer<Int, NoError> = SignalProducer<Int, NoError>(turnScheduler.turnChangeSignal)
		let observer1: Observer<Int, NoError> = Observer<Int, NoError>.init(value: {value in
				print("value from producer = \(value)")
		})
		sp.start(observer1)
		
		let signalProducer1: SignalProducer<Int, NoError> = SignalProducer<Int, NoError>{ () -> Int in
			let randomNum:UInt32 = arc4random_uniform(100) // range is 0 to 99
			return Int(randomNum)
		}
		
		signalProducer1.start( { value in
			print(value)
		})
	}
	
	func signalProducerFromSignal() {
		let (signal, observer) = Signal<Int, NoError>.pipe()
		let producer = SignalProducer<Int, NoError>(signal)
		let subscriber1 = Observer<Int, NoError>(value: { print("Subscriber 1 received \($0)") } )
		let subscriber2 = Observer<Int, NoError>(value: { print("Subscriber 2 received \($0)") } )
		
		
		print("Subscriber 1 starts the producer")
		producer.start(subscriber1)
		
		print("Send value `10` on the signal")
		// subscriber1 will receive the value
		observer.send(value: 10)
		
		print("Subscriber 2 starts the producer")
		// Notice how nothing happens at this moment, i.e. subscriber2 does not receive the previously sent value
		producer.start(subscriber2)
		
		print("Send value `20` on the signal")
		// Notice that now, subscriber1 and subscriber2 will receive the value
		observer.send(value: 20)
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		gridView.stop()
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
