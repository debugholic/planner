//
//  ViewController.swift
//  planner
//
//  Created by 김영훈 on 2024/04/04.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: SwipableTableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
    }
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SwipableTableViewCell
        
        let button1 = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 50)))
        button1.backgroundColor = .red
        cell.add(button: button1, to: .trailing)
        
        let button2 = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 50)))
        button2.backgroundColor = .blue
        cell.add(button: button2, to: .trailing)
        
        let button3 = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 50)))
        button3.backgroundColor = .red
        cell.add(button: button3, to: .leading)
        
        let button4 = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 50)))
        button4.backgroundColor = .blue
        cell.add(button: button4, to: .leading)

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}
