//
//  Router.swift
//  Functional-Reactive-Example
//
//  Created by Susmita Horrow on 20/04/17.
//  Copyright © 2017 hsusmita. All rights reserved.
//

import Foundation
import UIKit

class Router {
	
	enum Destination {
		case binding
		case signal
		
		var viewController: UIViewController? {
			switch self {
			case .binding:
				return BindingViewController.storyboardInstance
			case .signal:
				return SignalViewController.storyboardInstance
			}
		}
	}
	
	private let rootViewController: UIViewController
	
	init(root: UIViewController) {
		self.rootViewController = root
	}
	
	func present(destination: Destination) {
		if let vc = destination.viewController {
			rootViewController.navigationController?.pushViewController(vc, animated: true)
		}
	}
}

extension Routable where Self: UIViewController {
	static var storyboardInstance: Self? {
		let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
		let viewController = storyboard.instantiateViewController(withIdentifier: storyboardId)
		return viewController as? Self
	}
}
