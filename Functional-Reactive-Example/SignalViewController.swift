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
	var turnScheduler: TurnScheduler!
	@IBOutlet weak var label: UILabel!
	var colors: [UIColor] = [UIColor.red, UIColor.green, UIColor.blue]
	var colorName: [String] = ["red", "green", "blue"]

	override func viewDidLoad() {
        super.viewDidLoad()
		
		let gridView = GameGrid.gameGridView()
		gridView.frame = CGRect(x: 0, y: 100, width: 400, height: 200)
		self.view.addSubview(gridView)
		gridView.configure(with: Grid(row: 5, column: 5))
		gridView.start()
//		let (signal1, observer1) = Signal<Int, NoError>.pipe()
//		
//		let (signal2, observer2) = Signal<Int, NoError>.pipe()
//		
//		let (signal3, observer3) = Signal<Int, NoError>.pipe()
//
//		let _ = Signal.zip([signal1, signal2, signal3]).observeValues { arr in
//			arr.forEach({ index in
//				print(index)
//			})
//		}
//		observer1.send(value: 11)
//		observer2.send(value: 21)
//		observer3.send(value: 31)
//
	turnScheduler = TurnScheduler(numberOfPlayers: colors.count)
		
		let observer: Observer<Int, NoError> = Observer(value: { [weak self] count in
			self?.label.text = "Current Color is \((gridView.colors[count - 1]))"
			self?.label.backgroundColor = self?.colors[count - 1]
		})
		turnScheduler.turnChangeSignal.observe(observer)

		
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
