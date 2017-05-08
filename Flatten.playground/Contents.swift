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
	
//	@IBOutlet weak var tableView: UITableView!
	var images: [UIImage] = []
	var imageItems: [ImageItem] = []
	
	var flowerSignalProducer: SignalProducer<UIImage, NoError>?
	var animalSignalProducer: SignalProducer<UIImage, NoError>?
	var birdSignalProducer: SignalProducer<UIImage, NoError>?
	
	var imageSignalProducer: SignalProducer<SignalProducer<UIImage, NoError>, NoError>?
	
	func configureSignalProducers() -> SignalProducer<UIImage, NoError> {
		flowerSignalProducer = SignalProducer<UIImage, NoError>({ (observer, disposable) in
			
			print("3")
			DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
				print("3.1")
				print(#imageLiteral(resourceName: "animal1.jpeg"))
				
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
		
		
			print(" flower : \(flowerSignalProducer) bird:  \(birdSignalProducer) animal: \(animalSignalProducer)")
		
		let imageSignalProducer = SignalProducer<SignalProducer<UIImage, NoError>, NoError>([flowerSignalProducer!, animalSignalProducer!, birdSignalProducer!])
		
		print("4")
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
	
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		print("number of rows \(images.count)")
		return images.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//		let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath)
//		print(cell)
		print("asd")
		let cell = UITableViewCell(style: .default, reuseIdentifier: "ImageTableViewCell")
		print(cell)
//		let cell = tableView.cellForRow(at: indexPath)
		print(images[indexPath.row])
		
		
		cell.imageView?.image = images[indexPath.row]
		return cell
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		print("view did load")
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ImageTableViewCell")
		print("1")
		configureSignalProducers().startWithValues({  value in
//			guard let weakSelf = self else {
//				return
//			}
			print("5")
			print("value : \(value)")
			
			self.tableView.beginUpdates()
			self.images.append(value)
			let nextIndexPath = IndexPath(row: self.images.count - 1, section: 0)
			self.tableView.insertRows(at: [nextIndexPath], with: .automatic)
			self.tableView.endUpdates()
		})
		print("2")
	}
}


let vc = FlattenExampleViewController()
vc.view.frame = CGRect.init(x: 0, y: 0, width: 320, height: 480)
PlaygroundPage.current.liveView = vc.view

