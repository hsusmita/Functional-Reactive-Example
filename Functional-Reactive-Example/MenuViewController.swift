//
//  MenuViewController.swift
//  Functional-Reactive-Example
//
//  Created by Susmita Horrow on 20/04/17.
//  Copyright © 2017 hsusmita. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

	@IBOutlet private weak var tableView: UITableView!
	fileprivate var menuArray: [Router.Destination] = [.signal, .signalProducer, .action, .binding, .transform, .combine, .flatten]
	fileprivate var router: Router?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		router = Router(root: self)
		tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension MenuViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return menuArray.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
		cell.textLabel?.text = menuArray[indexPath.row].title
		return cell
	}
}

extension MenuViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let destination = menuArray[indexPath.row]
		router?.present(destination: destination)
	}
}
