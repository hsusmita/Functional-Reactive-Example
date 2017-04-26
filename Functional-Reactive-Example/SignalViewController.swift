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
	let gridView = GameGrid.gameGridView()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		gridView.frame = CGRect(x: 0, y: 100, width: 400, height: 200)
		self.view.addSubview(gridView)
		gridView.configure(with: Grid(row: 5, column: 5))
		gridView.start()
		
		turnScheduler = TurnScheduler(numberOfPlayers: colors.count)
		let observer: Observer<Int, NoError> = Observer(value: { [unowned self] count in
			self.label.text = "Current Color is \((self.gridView.colors[count - 1]))"
			self.label.backgroundColor = self.colors[count - 1]
		})
		turnScheduler.turnChangeSignal.observe(observer)
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
