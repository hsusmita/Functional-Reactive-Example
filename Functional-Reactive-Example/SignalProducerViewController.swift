//
//  SignalProducerViewController.swift
//  Functional-Reactive-Example
//
//  Created by Susmita Horrow on 01/05/17.
//  Copyright © 2017 hsusmita. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result

class SignalProducerViewController: UIViewController {

	var turnScheduler: TurnScheduler?
	
	@IBOutlet weak var turnLabel: UILabel!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		createSignalProducer()
		singleValueSignalProducer()
    }

	// init(_ signal: S)
	// This example shows how to create signal producer from a signal

	func createSignalProducer() {
		turnScheduler = TurnScheduler(turnsForSlot: 5, numberOfSlots: 1)
		guard let turnScheduler = turnScheduler else {
			return
		}
		let firstSignalProducer: SignalProducer<Int, NoError> = SignalProducer<Int, NoError>(turnScheduler.turnChangeSignal)
		let observer: Observer<Int, NoError> = Observer<Int, NoError>.init(value: { [weak self] value in
			self?.turnLabel.text = String(value)
		})
		firstSignalProducer.start(observer)
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
		
		//		let signalProducer1: SignalProducer<Int, NoError> = SignalProducer<Int, NoError>{ () -> Int in
		//			let randomNum:UInt32 = arc4random_uniform(100) // range is 0 to 99
		//			return Int(randomNum)
		//		}
		//
		//		signalProducer1.start( { value in
		//			print(value)
		//		})
	}
	
	struct Error: Swift.Error {

	}
	
	func singleValueSignalProducer() {
		let signalProducer: SignalProducer<Int, NoError> = SignalProducer(value: 5)
		let observer: Observer<Int, NoError> = Observer(value: { value in
			print("Emitted value = \(value)")
		}, completed: {
			print("completed")
		})
		signalProducer.start(observer)
		
		let sp: SignalProducer<Int, NoError> = SignalProducer([1 , 2 , 3, 4, 5])
		sp.start(observer)
		
		let resultObserver: Observer<Int, Error> = Observer(value: { (value) in
			print("Emitted value = \(value)")
		}, failed: { (error) in
			print("Failed with error = \(error)")
		}, completed: {
			print("Completed")
		})
		
		let sp2: SignalProducer<Int, Error> = SignalProducer(error: Error())
		sp2.start(resultObserver)
	}

	func resultSignalProducer() {
		let resultObserver: Observer<Int, Error> = Observer(value: { (value) in
			print("Emitted value = \(value)")
		}, failed: { (error) in
			print("Failed with error = \(error)")
		}, completed: {
			print("Completed")
		})

		let resultError = Result<Int, Error>(error: Error())
		let errorProducer: SignalProducer<Int, Error> = SignalProducer(result: resultError)
		
		errorProducer.start(resultObserver)
		
		let resultValue = Result<Int, Error>(value: 10)
		let valueProducer: SignalProducer<Int, Error> = SignalProducer(result: resultValue)
		
		valueProducer.start(resultObserver)
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SignalProducerViewController: Routable {
	static var storyboardId: String {
		return "SignalProducerViewController"
	}
	static var storyboardName: String {
		return "Main"
	}
}
