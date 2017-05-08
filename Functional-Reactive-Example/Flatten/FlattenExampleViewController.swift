//
//  FlattenExampleViewController.swift
//  Functional-Reactive-Example
//
//  Created by Susmita Horrow on 05/05/17.
//  Copyright © 2017 hsusmita. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

struct ImageItem {
	var image: UIImage
	var name: String
}

class FlattenExampleViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	var images: [UIImage] = []
	var imageItems: [ImageItem] = []
	
	var flowerSignalProducer: SignalProducer<UIImage, NoError>?
	var animalSignalProducer: SignalProducer<UIImage, NoError>?
	var birdSignalProducer: SignalProducer<UIImage, NoError>?
	
	var imageSignalProducer: SignalProducer<SignalProducer<UIImage, NoError>, NoError>?
	
	func configureSignalProducers() -> SignalProducer<UIImage, NoError> {
		flowerSignalProducer = SignalProducer<UIImage, NoError>({ (observer, disposable) in
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
				observer.send(value: UIImage(named: "flower1")!)
			})
			DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
				observer.send(value: UIImage(named: "flower2")!)
			})
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
				observer.send(value: UIImage(named: "flower3")!)
				observer.sendCompleted()
			})
		})
		
		animalSignalProducer = SignalProducer<UIImage, NoError>({ (observer, disposable) in
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
				observer.send(value: UIImage(named: "animal1")!)
			})
			DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
				observer.send(value: UIImage(named: "animal2")!)
			})
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
				observer.send(value: UIImage(named: "animal3")!)
				observer.sendCompleted()
			})

		})
		
		birdSignalProducer = SignalProducer<UIImage, NoError>({ (observer, disposable) in
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
				observer.send(value: UIImage(named: "bird1")!)
			})
			DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
				observer.send(value: UIImage(named: "bird2")!)
			})
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
				observer.send(value: UIImage(named: "bird3")!)
				observer.sendCompleted()
			})
		})
		
		let imageSignalProducer = SignalProducer<SignalProducer<UIImage, NoError>, NoError>([flowerSignalProducer!, animalSignalProducer!, birdSignalProducer!])
		return imageSignalProducer.flatten(.concat)
//			.map({ (image) in
//			return ImageItem(image: image, name: "item")
//		})
//		
//			.flatMap(.merge, transform: { image in
//			return ImageItem(image: image, name: "item")
//		})
		/*return SignalProducer<SignalProducer<UIImage, NoError>, NoError>{ [unowned self](observer, disposable) in
			observer.send(value: self.flowerSignalProducer!)
			DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
				observer.send(value: self.birdSignalProducer!)
				observer.sendCompleted()
			})
			
		}.flatten(.latest)*/
		
	
		
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		configureSignalProducers().startWithValues({ [weak self] value in
			guard let weakSelf = self else {
				return
			}
			weakSelf.tableView.beginUpdates()
			weakSelf.images.append(value)
			let nextIndexPath = IndexPath(row: weakSelf.images.count - 1, section: 0)
			weakSelf.tableView.insertRows(at: [nextIndexPath], with: .automatic)
			weakSelf.tableView.endUpdates()
		})
    }
}

extension FlattenExampleViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return images.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath)
		cell.imageView?.image = images[indexPath.row]
		return cell
	}
}

extension FlattenExampleViewController: Routable {
	static var storyboardId: String {
		return "FlattenExampleViewController"
	}
	static var storyboardName: String {
		return "Main"
	}
}
