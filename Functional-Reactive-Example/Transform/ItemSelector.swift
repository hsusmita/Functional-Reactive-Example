//
//  ItemSelector.swift
//  Functional-Reactive-Example
//
//  Created by Susmita Horrow on 26/04/17.
//  Copyright © 2017 hsusmita. All rights reserved.
//

import Foundation
import UIKit
import ReactiveSwift
import Result

class ItemSelector: NSObject {
	var items: [String] = []
	
	fileprivate let selectedIndexPaths = MutableProperty<[IndexPath]>([])
	
	var selectedCountChangeSignal: Signal<[IndexPath], NoError> {
		return selectedIndexPaths.signal
	}
}

extension ItemSelector: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
		if let itemCell = cell as? ItemTableViewCell {
			itemCell.configure(string: items[indexPath.row])
			itemCell.isCellSelected.signal.observeValues({ [unowned self] value in
				if value {
					self.selectedIndexPaths.value.append(indexPath)
				} else {
					if let index = self.selectedIndexPaths.value.index(of: indexPath) {
						self.selectedIndexPaths.value.remove(at: index)
					}
				}
			})
		}
		return cell
	}
}
