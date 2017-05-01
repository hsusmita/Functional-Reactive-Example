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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func createSignalProducer() {
		let turnScheduler = TurnScheduler(turnsForSlot: 5, numberOfSlots: 1)

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
