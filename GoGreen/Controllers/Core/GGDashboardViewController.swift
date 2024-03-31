import UIKit

final class GGDashboardViewController: UIViewController, ReloadableViewController {
    private let dashboardView = GGDashboardView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(dashboardView)
        NSLayoutConstraint.activate([
            dashboardView.topAnchor.constraint(equalTo:
                view.safeAreaLayoutGuide.topAnchor),
            dashboardView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            dashboardView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            dashboardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func reloadData() {
    }
}
