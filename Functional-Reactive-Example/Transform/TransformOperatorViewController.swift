//
//  TransformOperatorViewController.swift
//  Functional-Reactive-Example
//
//  Created by Susmita Horrow on 26/04/17.
//  Copyright © 2017 hsusmita. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class TransformOperatorViewController: UIViewController {

	@IBOutlet weak var doneButton: UIButton!
	@IBOutlet weak var tableView: UITableView!
	
	var itemSelector = ItemSelector()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		itemSelector.items = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6"]
		let nib = UINib(nibName: "ItemTableViewCell", bundle: Bundle.main)
		tableView.register(nib, forCellReuseIdentifier: "ItemCell")
		tableView.dataSource = itemSelector
		tableView.reloadData()
		doneButton.reactive.isEnabled <~ itemSelector.selectedCountChangeSignal.map({ indexPaths in
			return !indexPaths.isEmpty
		})
    }
}

extension TransformOperatorViewController: Routable {
	static var storyboardId: String {
		return "TransformOperatorViewController"
	}
	
	static var storyboardName: String {
		return "Main"
	}
}
