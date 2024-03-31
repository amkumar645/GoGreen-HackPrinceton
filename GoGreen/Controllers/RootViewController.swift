import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red // Set the background color of the root view controller
        
        // Create an instance of GGTabViewController
        let tabViewController = GGTabViewController()
        
        // Add GGTabViewController as a child view controller
        addChild(tabViewController)
        view.addSubview(tabViewController.view)
        tabViewController.didMove(toParent: self)
    }
}
