import UIKit

protocol ContactDataSourceDelegate {
	func doNothingAction()
}

class ContactListDataSource: NSObject {

	public var contactListViewModel: ContactsListViewModel
	public var didSelectDialContact: ((Contact) -> Void) = {_ in }
	public var didSelectViewContactsRecords: ((Contact) -> Void) = {_ in }
	
	public var delegate: ContactDataSourceDelegate?
 
	init(contactListViewModel: ContactsListViewModel) {
		self.contactListViewModel = contactListViewModel
	}
}

extension ContactListDataSource: UITableViewDelegate, UITableViewDataSource {

	private func configure(_ cell: ContactTableViewCell, at indexPath: IndexPath) {
		
		guard let contactModel = contactListViewModel.contact(at: indexPath) else { return }
		
		cell.delegate = self
		cell.configure(with: contactModel)
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return contactListViewModel.data.count
	}
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return contactListViewModel.numberRowsInSection(section)
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: Constants.identifier.cell.contact, for: indexPath) as! ContactTableViewCell
		self.configure(cell, at: indexPath)
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
		
		guard let model = self.contactListViewModel.contact(at: indexPath) else { return }
		
		self.didSelectDialContact(model.contact)
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 60
	}
	
	func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
		return false
	}
}

extension ContactListDataSource {
	
	func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
		
		guard let model = contactListViewModel.contact(at: indexPath) else { return nil }
		
		let identifier = IndexPath(row: indexPath.row, section: indexPath.section) as NSCopying
		let image = self.handleContactImage(model.contact)

		return UIContextMenuConfiguration(identifier: identifier) {
			if let thumbnail = image {
				return ImagePreviewThumbnailViewController(item: thumbnail)
			} else {
				if let cell = tableView.cellForRow(at: indexPath) as? ContactTableViewCell {
					if let text = cell.stringText, let color = cell.color {
						return NamePreviewThumbnaiViewController(text: text, color: color)
					}
				}
				
				let chareacters = Utilites.getShortName(from: model)
				let color = ColorRandomizer.randomColor()
				return NamePreviewThumbnaiViewController(text: chareacters, color: color)
			}
		} actionProvider: { _ in
			return self.createCellContextMenu(for: model.contact, at: indexPath)
		}
	}
	
	func tableView(_ tableView: UITableView, willDisplayContextMenu configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
		
		guard let window = Utilites.application.windows.first else { return }
		
		DispatchQueue.main.async {
			
			if let view = Utilites.viewByClassName(view: window, className: "_UICutoutShadowView") {
				view.isHidden = true
			}
			if let view = Utilites.viewByClassName(view: window, className: "_UIPortalView") {
				view.rounded()
			}
			if let view = Utilites.viewByClassName(view: window, className: "_UIPlatterTransformView") {
				view.rounded()
			}
			
			if let view = Utilites.viewByClassName(view: window, className: "_UIPlatterTransformView") {
				view.rounded()
			}
		}
	}
	
	func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {

		guard let indexPath = configuration.identifier as? IndexPath,
			  let cell = tableView.cellForRow(at: indexPath) as? ContactTableViewCell else { return nil }

		let params = UIPreviewParameters()
		params.backgroundColor = .clear

		return UITargetedPreview(view: cell.contactInfoContainerView, parameters: params)
	}

	func tableView(_ tableView: UITableView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {

		guard let indexPath = configuration.identifier as? IndexPath,
			  let cell = tableView.cellForRow(at: indexPath) as? ContactTableViewCell else { return nil }

		let params = UIPreviewParameters()
		params.backgroundColor = .clear

		return UITargetedPreview(view: cell.contactInfoContainerView, parameters: params)
	}
}

extension ContactListDataSource {
	
	private func handleContactImage(_ contact: Contact) -> UIImage? {
		
		if DefaultFileManager().isContactImageExist(contact.identifier) {
			return DefaultFileManager().loadContactImage(from: contact.identifier)
		}
		return nil
	}
	
	private func createCellContextMenu(for contact: Contact, at indexPath: IndexPath) -> UIMenu {
		
		let phoneNumbers = contact.phoneNumbers.convertable(ContactPhoneNumber.self)
	
		if phoneNumbers.isEmpty {
			return UIMenu(title: "No phone numbers", children: [])
		} else {
			let menuImage = UIImage(systemName: Images.Actions.outgoingCall)
//            TODO: need
			#warning("Anonim actions did not work with delegate !!!!")
			
			let actions = [UIAction(title: "віііві",handler: { _ in
				self.delegate?.dial(phoneNumber: ContactPhoneNumber(), with: contact)
			})]
			
//            let actions: [UIAction] = phoneNumbers.map { index in
//                UIAction(title: index.number, image: menuImage) { _ in
//                    self.delegate?.dial(phoneNumber: index, with: contact)
//                }
//            }
			return UIMenu(title: "", children: actions)
		}
	}
}

extension ContactListDataSource: ContactActionDelegate {

	func didSelectContact(_ cell: ContactTableViewCell) {
	  
		guard let contact = cell.contact else { return }
		
		self.didSelectViewContactsRecords(contact)
	}
}


extension ContactListDataSource: UIScrollViewDelegate {
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {}
}

