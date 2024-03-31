import UIKit

struct DistanceBreakdown {
    enum DistanceType: String {
        case walk = "Walk"
        case subway = "Subway"
        case drive = "Drive"
    }
    
    let type: DistanceType
    let value: Float
}

final class GGProfileView: UIView {
    
    private let viewModel = GGProfileViewViewModel()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateStartedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emissionsSavedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let numPetsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let totalXPLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userCurrentXPLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let distanceChartView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let distanceChartLabels: [UILabel] = [
        UILabel(),
        UILabel(),
        UILabel()
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(spinner, profileImageView, usernameLabel, dateStartedLabel, distanceLabel, emissionsSavedLabel, numPetsLabel, totalXPLabel, userCurrentXPLabel, distanceChartView)
        addConstraints()
        
        spinner.startAnimating()
        setupProfileView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 200),
            profileImageView.heightAnchor.constraint(equalToConstant: 200),
            
            usernameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            usernameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            dateStartedLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 20),
            dateStartedLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            dateStartedLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            distanceLabel.topAnchor.constraint(equalTo: dateStartedLabel.bottomAnchor, constant: 20),
            distanceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            distanceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            emissionsSavedLabel.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 20),
            emissionsSavedLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            emissionsSavedLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            numPetsLabel.topAnchor.constraint(equalTo: emissionsSavedLabel.bottomAnchor, constant: 20),
            numPetsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            numPetsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            totalXPLabel.topAnchor.constraint(equalTo: numPetsLabel.bottomAnchor, constant: 20),
            totalXPLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            totalXPLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            userCurrentXPLabel.topAnchor.constraint(equalTo: totalXPLabel.bottomAnchor, constant: 20),
            userCurrentXPLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            userCurrentXPLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            distanceChartView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            distanceChartView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            distanceChartView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            
            // Constraints for the labels in the distance chart
            distanceChartLabels[0].widthAnchor.constraint(equalToConstant: 100),
            distanceChartLabels[1].widthAnchor.constraint(equalToConstant: 100),
            distanceChartLabels[2].widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setupProfileView() {
        viewModel.fetchProfile { result in
            switch result {
            case .success(let profile):
                DispatchQueue.main.async {
                    self.usernameLabel.text = profile.username
                    self.dateStartedLabel.text = "Date Started: \(profile.date_started)"
                    self.distanceLabel.text = "Distance: \(profile.distance)"
                    self.emissionsSavedLabel.text = "Emissions Saved: \(profile.emissions_saved)"
                    self.numPetsLabel.text = "Number of Pets: \(profile.num_pets)"
                    self.totalXPLabel.text = "Total XP: \(profile.total_xp)"
                    self.userCurrentXPLabel.text = "Current XP: \(profile.user_current_xp)"
                    
                    let distanceBreakdown = [
                        DistanceBreakdown(type: .walk, value: profile.distance_breakdown_walk / profile.distance),
                        DistanceBreakdown(type: .subway, value: profile.distance_breakdown_subway / profile.distance),
                        DistanceBreakdown(type: .drive, value: profile.distance_breakdown_drive / profile.distance)
                    ]
                    self.createBarChart(for: distanceBreakdown)
                    
                    self.profileImageView.image = UIImage(systemName: "person.circle")
                    self.profileImageView.tintColor = UIColor(red: 0.31, green: 0.78, blue: 0.47, alpha: 1.00)
                    
                    self.spinner.stopAnimating()
                }
            case .failure(let error):
                print("Error fetching profile: \(error)")
            }
        }
    }
    
    private func createBarChart(for distanceBreakdown: [DistanceBreakdown]) {
        for (index, breakdown) in distanceBreakdown.enumerated() {
            let barView = UIView()
            barView.backgroundColor = self.color(for: breakdown.type)
            NSLayoutConstraint.activate([
                barView.heightAnchor.constraint(equalToConstant: 20),
                barView.widthAnchor.constraint(equalToConstant: CGFloat(breakdown.value) * 50) // Adjust multiplier as per your preference
            ])
            self.distanceChartView.addArrangedSubview(barView)
            
            // Add label for each bar
            let label = distanceChartLabels[index]
            label.text = breakdown.type.rawValue + ": " + String(Int(breakdown.value * 100)) + "%"
            label.font = UIFont.systemFont(ofSize: 14)
            label.translatesAutoresizingMaskIntoConstraints = false
            distanceChartView.addArrangedSubview(label)
        }
    }

    private func color(for type: DistanceBreakdown.DistanceType) -> UIColor {
        switch type {
        case .walk:
            return UIColor(red: 0.31, green: 0.78, blue: 0.47, alpha: 1.00)
        case .subway:
            return UIColor(red: 0.27, green: 0.51, blue: 0.71, alpha: 1.00)
        case .drive:
            return UIColor(red: 0.79, green: 0.20, blue: 0.20, alpha: 1.00)
        }
    }
}
