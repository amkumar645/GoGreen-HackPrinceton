import UIKit

final class GGScoreboardViewController: UIViewController, ReloadableViewController {
    
    private let scoreboardView = GGScoreboardView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(scoreboardView)
        NSLayoutConstraint.activate([
            scoreboardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scoreboardView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            scoreboardView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            scoreboardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func reloadData() {
        // Remove all subviews from the view
        view.subviews.forEach { $0.removeFromSuperview() }
        
        // Re-setup the view hierarchy
        let scoreboardView = GGScoreboardView()
        view.addSubview(scoreboardView)
        NSLayoutConstraint.activate([
            scoreboardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scoreboardView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            scoreboardView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            scoreboardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
