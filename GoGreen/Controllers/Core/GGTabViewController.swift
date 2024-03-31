import UIKit

final class GGTabViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        setUpTabs()
        delegate = self // Set the delegate
    }
    
    private func setUpTabs() {
        let dashboardVC = GGDashboardViewController()
        let petsVC = GGPetsViewController()
        let scoreboardVC = GGScoreboardViewController()
        let profileVC = GGProfileViewController()
        
        dashboardVC.title = "Dashboard"
        petsVC.title = "My Pets"
        scoreboardVC.title = "Scoreboard"
        profileVC.title = "Profile"
        
        dashboardVC.navigationItem.largeTitleDisplayMode = .automatic
        petsVC.navigationItem.largeTitleDisplayMode = .automatic
        scoreboardVC.navigationItem.largeTitleDisplayMode = .automatic
        profileVC.navigationItem.largeTitleDisplayMode = .automatic
        
        let nav1 = UINavigationController(rootViewController: dashboardVC)
        let nav2 = UINavigationController(rootViewController: petsVC)
        let nav3 = UINavigationController(rootViewController: scoreboardVC)
        let nav4 = UINavigationController(rootViewController: profileVC)
        
        nav1.tabBarItem = UITabBarItem(
            title:"Dashboard",
            image: UIImage(systemName: "map"),
            tag: 1
        )
        nav2.tabBarItem = UITabBarItem(
            title:"My Pets",
            image: UIImage(systemName: "tortoise"),
            tag: 2
        )
        nav3.tabBarItem = UITabBarItem(
            title:"Scoreboard",
            image: UIImage(systemName: "sportscourt"),
            tag: 3
        )
        nav4.tabBarItem = UITabBarItem(
            title:"Profile",
            image: UIImage(systemName: "person"),
            tag: 4
        )
        
        for nav in[nav1, nav2, nav3, nav4] {
            nav.navigationBar.prefersLargeTitles = true
        }
        
        setViewControllers([nav1, nav2, nav3, nav4],
                           animated: true)
    }
    
    // MARK: - UITabBarControllerDelegate
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let navigationController = viewController as? UINavigationController,
           let visibleViewController = navigationController.visibleViewController {
            if let reloadableViewController = visibleViewController as? ReloadableViewController {
                reloadableViewController.reloadData()
            }
        }
    }
}
