import UIKit

final class GGPetsView: UIView {
    
    private let viewModel = GGPetsViewViewModel()
    private var pets_array = [GGSinglePet]()
    private var current_xp = 0
    private var nameEntryView: UIView?
    private var nameTextField: UITextField?
    private var submitButton: UIButton?
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let padding: CGFloat = 16
        let itemSpacing: CGFloat = 16
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        layout.minimumInteritemSpacing = itemSpacing
        layout.minimumLineSpacing = itemSpacing
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(GGPetCardCollectionViewCell.self, forCellWithReuseIdentifier: GGPetCardCollectionViewCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private let currentXPLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black // Changed text color to black
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let getNewPetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Get a new pet! (500 XP required)", for: .normal)
        button.backgroundColor = UIColor(red: 0.31, green: 0.78, blue: 0.47, alpha: 1.00)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubviews(spinner, collectionView, getNewPetButton, currentXPLabel)
        addConstraints()
        
        spinner.startAnimating()
        setupPetsView()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        getNewPetButton.addTarget(self, action: #selector(handleGetNewPetButtonTap), for: .touchUpInside)
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
            
            currentXPLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16), // Positioned above the collectionView
            currentXPLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            collectionView.topAnchor.constraint(equalTo: currentXPLabel.bottomAnchor, constant: 16), // Positioned below currentXPLabel
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: getNewPetButton.topAnchor, constant: -16),
            
            getNewPetButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            getNewPetButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            getNewPetButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            getNewPetButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func convertToSinglePets(ggPets: GGPets) -> [GGSinglePet] {
        let xpArray = ggPets.pets_current_xp.components(separatedBy: ",")
        let levelArray = ggPets.pets_levels.components(separatedBy: ",")
        let nameArray = ggPets.pets_names.components(separatedBy: ",")
        let photoArray = ggPets.pets_photos.components(separatedBy: ",")
        var singlePets = [GGSinglePet]()
        
        guard xpArray.count == levelArray.count,
              levelArray.count == nameArray.count,
              nameArray.count == photoArray.count else {
                  fatalError("Input arrays are of different lengths")
              }
        
        for i in 0..<xpArray.count {
            let singlePet = GGSinglePet(pet_current_xp: xpArray[i],
                                         pet_level: levelArray[i],
                                         pet_name: nameArray[i],
                                         pet_photo: photoArray[i],
                                         username: ggPets.username)
            singlePets.append(singlePet)
        }
        
        return singlePets
    }
    
    private func setupPetsView() {
        // Update UI when profile is fetched
        viewModel.fetchPets { result in
            switch result {
            case .success(let pets):
                DispatchQueue.main.async {
                    self.pets_array = self.convertToSinglePets(ggPets: pets)
                    self.current_xp = pets.user_current_xp
                    self.currentXPLabel.text = "Current XP: \(self.current_xp)"
                    self.spinner.stopAnimating()
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print("Error fetching pets: \(error)")
            }
        }
    }
    
    @objc private func handleGetNewPetButtonTap() {
        if current_xp >= 500 {
            showNameEntryView()
        } else {
            // Show an alert or handle the case when XP is insufficient
            let alert = UIAlertController(title: "Insufficient XP", message: "You need at least 500 XP to get a new pet.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = windowScene.keyWindow?.rootViewController {
                rootViewController.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func showNameEntryView() {
        let nameEntryView = UIView()
        nameEntryView.backgroundColor = .white
        nameEntryView.layer.cornerRadius = 10
        nameEntryView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameEntryView)
        
        let nameTextField = UITextField()
        nameTextField.placeholder = "Enter pet name"
        nameTextField.borderStyle = .roundedRect
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameEntryView.addSubview(nameTextField)
        
        let submitButton = UIButton(type: .system)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.backgroundColor = .systemGreen
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.addTarget(self, action: #selector(submitButtonTapped(_:)), for: .touchUpInside)
        nameEntryView.addSubview(submitButton)
        
        NSLayoutConstraint.activate([
            nameEntryView.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameEntryView.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameEntryView.widthAnchor.constraint(equalToConstant: 300),
            nameEntryView.heightAnchor.constraint(equalToConstant: 150),
            
            nameTextField.topAnchor.constraint(equalTo: nameEntryView.topAnchor, constant: 16),
            nameTextField.leadingAnchor.constraint(equalTo: nameEntryView.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: nameEntryView.trailingAnchor, constant: -16),
            
            submitButton.bottomAnchor.constraint(equalTo: nameEntryView.bottomAnchor, constant: -16),
            submitButton.leadingAnchor.constraint(equalTo: nameEntryView.leadingAnchor, constant: 16),
            submitButton.trailingAnchor.constraint(equalTo: nameEntryView.trailingAnchor, constant: -16),
            submitButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        self.nameEntryView = nameEntryView
        self.nameTextField = nameTextField
        self.submitButton = submitButton
    }
    @objc private func submitButtonTapped(_ sender: UIButton) {
        guard let petName = nameTextField?.text, !petName.isEmpty else {
            // Handle empty pet name
            return
        }

        // Call the API with the pet name
        self.spinner.startAnimating()
        viewModel.addPet(name: petName, completion: { result in
            switch result {
            case .success(let pets):
                DispatchQueue.main.async {
                    self.pets_array = self.convertToSinglePets(ggPets: pets)
                    self.current_xp = pets.user_current_xp
                    self.currentXPLabel.text = "Current XP: \(self.current_xp)"
                    self.spinner.stopAnimating()
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print("Error fetching pets: \(error)")
            }
        })

        // Dismiss the name entry view
        dismissNameEntryView()
    }

    private func dismissNameEntryView() {
        nameEntryView?.removeFromSuperview()
        nameEntryView = nil
        nameTextField = nil
        submitButton = nil
    }
}

extension GGPetsView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pets_array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GGPetCardCollectionViewCell.reuseIdentifier, for: indexPath) as! GGPetCardCollectionViewCell
        let pet = pets_array[indexPath.item]
        cell.configure(with: pet)
        return cell
    }
}

extension GGPetsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 16
        let itemSpacing: CGFloat = 16
        let collectionViewWidth = collectionView.bounds.width
        let cellWidth = (collectionViewWidth - 2 * padding - itemSpacing) / 2
        let cellHeight = cellWidth * 1.2 // Adjust the aspect ratio as needed
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

