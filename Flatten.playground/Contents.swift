//: Playground - noun: a place where people can play

import UIKit
import ReactiveSwift
import Result
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

struct ImageItem {
	var image: UIImage
	var name: String
}

class FlattenExampleViewController: UITableViewController {
	var images: [UIImage] = []
	var imageItems: [ImageItem] = []
	
	var flowerSignalProducer: SignalProducer<UIImage, NoError>?
	var animalSignalProducer: SignalProducer<UIImage, NoError>?
	var birdSignalProducer: SignalProducer<UIImage, NoError>?
	
	var imageSignalProducer: SignalProducer<SignalProducer<UIImage, NoError>, NoError>?
	
	func configureSignalProducers() -> SignalProducer<UIImage, NoError> {
		flowerSignalProducer = SignalProducer<UIImage, NoError>({ (observer, disposable) in
				DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
				observer.send(value: #imageLiteral(resourceName: "flower1.jpeg"))
			})
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
				observer.send(value:#imageLiteral(resourceName: "flower2.jpeg"))
			})
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
				observer.send(value: #imageLiteral(resourceName: "flower3.jpg"))
				observer.sendCompleted()
			})
		})
		
		animalSignalProducer = SignalProducer<UIImage, NoError>({ (observer, disposable) in
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
				observer.send(value: #imageLiteral(resourceName: "animal1.jpeg"))
			})
			DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
				observer.send(value: #imageLiteral(resourceName: "animal2.jpeg"))
			})
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
				observer.send(value: #imageLiteral(resourceName: "animal3.jpg"))
				observer.sendCompleted()
			})
			
		})
		
		birdSignalProducer = SignalProducer<UIImage, NoError>({ (observer, disposable) in
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
				observer.send(value: #imageLiteral(resourceName: "bird1.jpeg"))
			})
			DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
				observer.send(value: #imageLiteral(resourceName: "birds2.jpg"))
			})
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
				observer.send(value: #imageLiteral(resourceName: "bird3.jpeg"))
				observer.sendCompleted()
			})
		})
		let imageSignalProducer = SignalProducer<SignalProducer<UIImage, NoError>, NoError>([flowerSignalProducer!, animalSignalProducer!, birdSignalProducer!])
		
		return imageSignalProducer.flatten(.merge)
	}
	
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return images.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath)
		print(images[indexPath.row])
		cell.imageView?.image = images[indexPath.row]
		return cell
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ImageTableViewCell")
		configureSignalProducers().startWithValues({[weak self]  value in
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

let vc = FlattenExampleViewController()
vc.view.frame = CGRect(x: 0, y: 0, width: 320, height: 480)
PlaygroundPage.current.liveView = vc.view




