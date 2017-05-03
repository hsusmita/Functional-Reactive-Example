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
	@IBOutlet weak var scoreLabel: UILabel!
	@IBOutlet weak var resultLabel: UILabel!
	@IBOutlet weak var startButton: UIButton!
	
	let gridView = GameGridView.gameGridView()
	let currentColor = MutableProperty<Int>(0)
	let colors: [UIColor] = [.red, .blue, .green, .magenta, .gray]
	var colorsName = ["Red", "Blue", "Green", "Magenta", "Gray"]

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		let width = self.view.frame.width
		gridView.frame = CGRect(x: 0, y: 200, width: width, height: width)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.addSubview(self.gridView)
		self.gridView.configure(colors: self.colors)
		
		startButton.reactive.controlEvents(.touchUpInside).observeValues { [unowned self] button in
			self.gridView.start()
			self.startButton.isEnabled = false
			self.turnScheduler = TurnScheduler(turnsForSlot: self.colors.count, numberOfSlots: 1)
			
			//Observe signal and perform side effects
			let observer: Observer<Int, NoError> = Observer(value: { [unowned self] count in
				self.label.text = "Tap grid of \(self.colorsName[count - 1]) Color"
				self.label.backgroundColor = self.colors[count - 1]
				self.startButton.isEnabled = false
				
				}, completed: { [weak self] count in
					self?.label.text = "Game Over"
					self?.gridView.stop()
					self?.startButton.isEnabled = true
			})
			
			self.turnScheduler.turnChangeSignal.observe(observer)
			self.currentColor <~ self.turnScheduler.turnChangeSignal
		}
		
		//Aggregate signal values
		scoreLabel.reactive.text <~	gridView.selectedRowSignal.filter { value in
			return value == self.currentColor.value
			}
			.scan(0) { (sum, value) in
				return sum + 1
			}
			.map { total in
				return "Total hit count = \(total)"
		}
		
		resultLabel.reactive.text <~ gridView.selectedRowSignal
			.reduce(0) { (sum, value) in
				if value == self.currentColor.value {
					return sum + 1
				} else {
					return sum
				}
			}
			.map { total in
				return (total > 10) ? "Well done" : "Better luck next time"
		}
		
		gridView.selectedRowSignal.collect().observeValues { values in
			print(values)
		}
		
		gridView.selectedRowSignal.collect { (values) -> Bool in
			return values.count == 3
		}.observeValues { values in
			print(values)
		}

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
