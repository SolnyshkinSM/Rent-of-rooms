//
//  DiagramViewController.swift
//  Rent of rooms
//
//  Created by Administrator on 09.10.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

import UIKit
import CoreData

class DiagramViewController: UIViewController {
   

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()        
    }
    
    // MARK: - Methods
    
    func configureView() {
        
        let imageView = UIImageView(image: UIImage(named: "rateBackground"))
        view.addSubview(imageView)
        
        
        let blurEffect = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.view.bounds
        visualEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.view.insertSubview(visualEffectView, at: 1)
                
        
        guard let appDelegate = (UIApplication.shared.delegate as? AppDelegate) else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Payment.fetchRequest()
        
        let predicate = NSPredicate(format: "sum > %@", 0 as NSNumber)
        fetchRequest.predicate = predicate
        fetchRequest.resultType = .dictionaryResultType
        
        let sumExpression = NSExpression(format: "sum:(sum)")
        let sumExpressionDescription = NSExpressionDescription()
        sumExpressionDescription.expression = sumExpression
        sumExpressionDescription.name = "totalSum"
        sumExpressionDescription.expressionResultType = .doubleAttributeType
        
        fetchRequest.propertiesToFetch = ["client.name", sumExpressionDescription]
        fetchRequest.propertiesToGroupBy = ["client.name"]
        
        let sortDescriptor = NSSortDescriptor(key: "sum", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let results = try context.fetch(fetchRequest) as [Any]
            drawAChartOverAn(array: results)
        } catch let error as NSError {
            NSLog(error.localizedDescription)
        }
        
    }
    
    func drawAChartOverAn(array: [Any]) {
        
        var maxSum = 0.0
        for item in array {
            guard let sum = (item as? NSDictionary)!["totalSum"] as? Double else { continue }
            maxSum = max(maxSum, sum)
        }
        
                
        let offset = 50
        let coordinateX = 20
        
        let midY = Int(self.view.bounds.midY)
        let maxWidth = Int(self.view.bounds.width) - 40
        
        for (index, item) in array.enumerated() {
            
            guard let dict = item as? NSDictionary else { continue }
            guard let clientName = dict["client.name"] as? String else { continue }
            guard let sum = dict["totalSum"] as? Double else { continue }
            
            
            let coordinateY = midY - (offset * array.count) >> 1
            
            var width = 0
            if sum == maxSum {
                width = Int(self.view.bounds.width) - (coordinateX * 2)
            } else {
                width = Int(sum * Double(maxWidth) / maxSum)
            }
            
            let frame = CGRect(x: coordinateX, y: coordinateY + offset * index, width: width, height: 40)
            let view = UIView(frame: frame)
            view.backgroundColor = UIColor.randomColor()
            view.layer.cornerRadius = view.frame.height / 2
            
            let label = UILabel(frame: view.bounds.insetBy(dx: 5, dy: 5))
            label.font = UIFont(name: "AppleSDGothicNeo-Light", size: CGFloat(Double(width) * 0.08))
            label.textColor = .white
            if let text = getNumberFormatter().string(from: sum as NSNumber) {
                label.text = clientName + " - " + text
            }
                        
            
            let centerView = view.center
            view.center = CGPoint(x: Int(arc4random() % UInt32(self.view.bounds.maxX)), y: Int(arc4random() % UInt32(self.view.bounds.maxY)))
            
            UIView.animate(withDuration: 1) {
                view.center = centerView
            }
                
            
            view.addSubview(label)
            self.view.addSubview(view)
            
            
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
            view.addGestureRecognizer(recognizer)
        }
    }
    
    @objc
    func handleGesture(_ tapGestureRecognizer: UITapGestureRecognizer) {
        
        let view = tapGestureRecognizer.view
        let label = view?.subviews[0] as? UILabel
        let startTransform = view?.transform
        
        UIView.animate(withDuration: 0.3) {
            view?.transform = CGAffineTransform(scaleX: 1.13, y: 1.13)
        }
        
        let alert = UIAlertController(title: NSLocalizedString("info", comment: ""), message: label?.text, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: NSLocalizedString("Cansel", comment: ""), style: .cancel, handler: { (alertAction) in
            UIView.animate(withDuration: 0.3) {
                view?.transform = startTransform!
            }
        })
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
                
    }
    
}


