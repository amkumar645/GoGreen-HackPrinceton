import UIKit

class GGPetCardCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "GGPetCardCollectionViewCell"
    private var petCell = GGSinglePet(pet_current_xp: "0",
                                     pet_level: "0",
                                     pet_name: "NOTREAL",
                                     pet_photo: "",
                                     username: "amkumar")
    private var current_xp = 0
    private let viewModel = GGPetsViewViewModel()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private let petImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit // or .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let petNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let petLevelLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let xpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Level Up (100 XP)", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.31, green: 0.78, blue: 0.47, alpha: 1.00)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
        xpButton.addTarget(self, action: #selector(levelUpPet), for: .touchUpInside)
    }
    
    @objc private func levelUpPet() {
        if self.current_xp >= 100 {
            spinner.startAnimating()
            viewModel.levelUpPet(name: petCell.pet_name, completion: { result in
                switch result {
                case .success(let pets):
                    DispatchQueue.main.async {
                        self.current_xp = pets.user_current_xp
//                        self.petLevelLabel.text = "Level: \(Int(self.petCell.pet_level)! + 1)"
                        self.spinner.stopAnimating()
                    }
                case .failure(let error):
                    print("Error leveling up pet: \(error)")
                }
            })
        } else {
            // Show an alert or handle the case when XP is insufficient
            let alert = UIAlertController(title: "Insufficient XP", message: "You need at least 100 XP to level up this pet.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = windowScene.keyWindow?.rootViewController {
                rootViewController.present(alert, animated: true, completion: nil)
            }
        }
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(petImageView)
        contentView.addSubview(petNameLabel)
        contentView.addSubview(petLevelLabel)
        contentView.addSubview(xpButton)
        contentView.addSubview(spinner)
        
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
        
            petImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            petImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            petImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            petImageView.bottomAnchor.constraint(equalTo: petNameLabel.topAnchor, constant: -8),
            petImageView.heightAnchor.constraint(equalToConstant: 120), // Set the desired height
            petImageView.widthAnchor.constraint(equalToConstant: 191),
            
            petNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            petNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            petNameLabel.bottomAnchor.constraint(equalTo: petLevelLabel.topAnchor, constant: -8),
            
            petLevelLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            petLevelLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            petLevelLabel.bottomAnchor.constraint(equalTo: xpButton.topAnchor, constant: -8),
            
            xpButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            xpButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            xpButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8), // Adjust spacing
            xpButton.heightAnchor.constraint(equalToConstant: 40) // Adjust button height
        ])
        
        viewModel.fetchPets { result in
            switch result {
            case .success(let pets):
                DispatchQueue.main.async {
                    self.current_xp = pets.user_current_xp                }
            case .failure(let error):
                print("Error fetching pets: \(error)")
            }
        }
    }
    
    func configure(with pet: GGSinglePet) {
        petImageView.image = UIImage(named: pet.pet_photo)
        self.petCell = pet
        petNameLabel.text = pet.pet_name
        petLevelLabel.text = "Level: \(pet.pet_level)"
//        petImageView.image = UIImage(systemName: "photo")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Print the height and width of the petImageView after layout
        print("petImageView height: \(petImageView.bounds.height)")
        print("petImageView width: \(petImageView.bounds.width)")
    }
}
