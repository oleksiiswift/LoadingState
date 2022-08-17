import UIKit
import RealmSwift

enum ContactInfoContainerState {
	case availibleImage
	case alphabetical
	case numeric
}

enum AvailibleRecords {
	case availible
	case empty
}

protocol ContactActionDelegate {
    func didSelectContact(_ cell: ContactTableViewCell)
}

class ContactTableViewCell: UITableViewCell {
    
	@IBOutlet weak var contactInfoContainerView: UIView!
	@IBOutlet weak var containerImageView: UIImageView!
	@IBOutlet weak var containerTextLabel: UILabel!
	@IBOutlet weak var chevronImageView: UIImageView!
	@IBOutlet weak var numbersOfRecordsView: UIView!
	@IBOutlet weak var numbersOfRecordsTextLabel: UILabel!
	@IBOutlet weak var contactInfoTextLabel: UILabel!
	@IBOutlet weak var recordsContainerView: UIView!
    
    
    public var delegate: ContactActionDelegate?
    public var contact: Contact?
    public var stringText: String?
    public var color: UIColor?
	
	override func awakeFromNib() {
        super.awakeFromNib()
        
		self.setupUI()
		self.setupAppearance()
    }
    
    override func prepareForReuse() {
       super.prepareForReuse()
        
        self.numbersOfRecordsView.isHidden = true
        self.chevronImageView.isHidden = true
        self.setRecords(List<CallResult>())
   }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
		
    }
    
    @IBAction func didTapSelectContactsRecordsActionButton(_ sender: Any) {
        
        self.numbersOfRecordsView.animateButtonTransform()
        self.delegate?.didSelectContact(self)
    }
}

extension ContactTableViewCell {
	
	public func configure(with model: ContactModel) {
		
        self.contact = model.contact
        self.contactInfoTextLabel.text = model.contact.displayedFullName
		self.setRecords(model.contact.callResults)
		
        if let image = DefaultFileManager().loadContactImage(from: model.contact.identifier) {
            self.setUserImageAvailible(.availibleImage, imageData: image)
        } else {
            let title = Utilites.getShortName(from: model)
            self.setUserImageAvailible(.alphabetical, title: title)
        }
	}
	
	private func setRecords(_ list: List<CallResult>) {
	
		let recordsAvailible: AvailibleRecords = list.isEmpty ? .empty : .availible
	
		switch recordsAvailible {
            case .availible:
                numbersOfRecordsView.isHidden = false
				chevronImageView.isHidden = false
				numbersOfRecordsTextLabel.text = String("\(list.count) Rec")
            case .empty:
				numbersOfRecordsView.isHidden = true
				chevronImageView.isHidden = true
		}
	}
	
	private func setUserImageAvailible(_ state: ContactInfoContainerState, title: String? = nil, imageData: UIImage? = nil) {
		
		switch state {
			case .availibleImage:
				contactInfoContainerView.backgroundColor = .clear
				containerTextLabel.isHidden = true
                containerTextLabel.text = nil
                
                self.containerImageView.isHidden = false
                
                if let userPicture = imageData {
                    self.containerImageView.image = userPicture
                }
                
			case .alphabetical, .numeric:
				
				containerTextLabel.isHidden = false
                self.containerImageView.isHidden = true
                self.containerImageView.image = nil
                
                if let jd = title {
                    self.containerTextLabel.text = jd
                    self.stringText = jd
                }
                
                let randomColor = ColorRandomizer.randomColor()
                contactInfoContainerView.backgroundColor = randomColor
                self.color = randomColor
		}
	}
}

extension ContactTableViewCell: AppearanceUpdatable {
	
	func setupUI() {
		
		containerImageView.rounded()
		contactInfoContainerView.rounded()
		
		contactInfoContainerView.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
		contactInfoContainerView.layer.borderWidth = 1

		numbersOfRecordsTextLabel.font = .systemFont(ofSize: 12, weight: .medium)
		
		chevronImageView.image = Images.Default.rightChevron
	}
	
	func setupAppearance() {
		
		contactInfoTextLabel.textColor = theme.maintTitleTextColor
		containerTextLabel.textColor = theme.maintTitleTextColor
		numbersOfRecordsTextLabel.textColor = theme.normalTitleTextColor
		
		numbersOfRecordsView.setBorder(radius: 12, color: theme.helperViewBorderColor, width: 1)
		numbersOfRecordsView.backgroundColor = theme.helperViewBackgroundColor
		
		chevronImageView.tintColor = theme.helperActiveBackroundColor
	}
}



