import UIKit

final class GGPetsViewController: UIViewController, ReloadableViewController {
    private let petsView = GGPetsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(petsView)
        NSLayoutConstraint.activate([
            petsView.topAnchor.constraint(equalTo: 
                view.safeAreaLayoutGuide.topAnchor),
            petsView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            petsView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            petsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func reloadData() {
        // Remove all subviews from the view
        view.subviews.forEach { $0.removeFromSuperview() }
        
        // Re-setup the view hierarchy
        let petsView = GGPetsView() // Recreate the pets view or any other views
        view.addSubview(petsView)
        NSLayoutConstraint.activate([
            petsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            petsView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            petsView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            petsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
