//
//  FlattenViewController.swift
//  Functional-Reactive-Example
//
//  Created by Pulkit Vaid on 03/05/17.
//  Copyright © 2017 hsusmita. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

class FlattenViewController: UIViewController, UITableViewDataSource {

	@IBOutlet weak var buttonMen: UIButton!
	@IBOutlet weak var buttonWomen: UIButton!
	@IBOutlet weak var buttomKids: UIButton!

	@IBOutlet weak var tableViewClothes: UITableView!

	let viewModel = FlattenViewModel()
	let disposable = CompositeDisposable()

	override func viewDidLoad() {

		super.viewDidLoad()
		setupTableView()
//		setupEventObserver()

		disposable += buttonMen.reactive.controlEvents(.touchUpInside).observe { [unowned self]
			_ in
			self.viewModel.generateEvent(category: .men)
		}

		disposable += buttonWomen.reactive.controlEvents(.touchUpInside).observe { [unowned self]
			_ in
			self.viewModel.generateEvent(category: .women)
		}

		disposable += buttomKids.reactive.controlEvents(.touchUpInside).observe { [unowned self]
			_ in
			self.viewModel.generateEvent(category: .kids)
		}
	}

	func setupTableView() {
		//		tableView.reactive.reloadData <~ data.output.signal.map { _ in return () }
		//		tableView.reactive.reloadData <~ ds.producer.map{ _ in return ()}
		//		data.input.send(value: ["asd", "asd"])
		tableViewClothes.dataSource = self
		tableViewClothes.reactive.reloadData <~ viewModel.ds.producer.map{ _ in return () }
	}

//	func setupEventObserver() {
//		viewModel.eventSignal.output.observeValues {
//			(event) in
//			print("Event Recived : \(event)")
//		}
//	}

	//MARK: - UITableViewDataSource
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.numberofRowsInSection(section: section)
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
		let model = viewModel.tableViewModelforIndexPath(indexPath: indexPath)
		cell.textLabel?.text = model?.itemName
		cell.detailTextLabel?.text = "\(model?.price ?? 0)"

		return cell
	}

	deinit {
		disposable.dispose()
	}
}


extension FlattenViewController: Routable {
	static var storyboardId: String {
		return "FlattenViewController"
	}

	static var storyboardName: String {
		return "Main"
	}
}
