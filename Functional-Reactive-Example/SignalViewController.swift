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
		turnScheduler = TurnScheduler(numberOfPlayers: colors.count)
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
