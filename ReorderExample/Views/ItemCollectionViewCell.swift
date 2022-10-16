//	
//  Copyright © Aelptos. All rights reserved.
//

import UIKit

final class ItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var labelTitle: UILabel!
    
    var item: Item!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addGestureRecognizer(
            UILongPressGestureRecognizer(
                target: self,
                action: #selector(onLongPressGestureRecognized(sender:)))
        )
        
        let selectTapRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(onSelectButtonTapRecognized(sender:))
        )
        selectTapRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.select.rawValue)]
        addGestureRecognizer(selectTapRecognizer)
        
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 8
    }
    
    func update(with item : Item) {
        self.item = item
        labelTitle.text = item.title
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with _: UIFocusAnimationCoordinator) {
        if context.nextFocusedView == self {
            UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveEaseOut) {
                self.contentView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }
        }
        if context.previouslyFocusedView == self {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
                self.contentView.transform = .identity
            }
        }
    }
    
    @objc func onLongPressGestureRecognized(sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else  { return }
        guard let parent = parentViewController as? ItemsViewController else { return }
        let controller = UIAlertController(
            title: item.title,
            message: nil,
            preferredStyle: .alert
        )
        if parent.editModeEnabled {
            controller.addAction(
                UIAlertAction(title: "Confirm new order", style: .default) { _ in
                    parent.changeOrder()
                }
            )
            controller.addAction(
                UIAlertAction(title: "Revert changes", style: .destructive) { _ in
                    parent.revertOrderChanges()
                }
            )
            controller.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        }
        else {
            controller.addAction(
                UIAlertAction(title: "Change order", style: .default) { _ in
                    (self.parentViewController as? ItemsViewController)?.toggleEditMode(true)
                }
            )
            controller.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        }
        parentViewController?.present(controller, animated: true, completion: nil)
    }
}

extension ItemCollectionViewCell {
    @objc func onSelectButtonTapRecognized(sender: UITapGestureRecognizer) {
        guard sender.state == .ended else  { return }
        guard let parent = parentViewController as? ItemsViewController else { return }
        guard parent.editModeEnabled else { return }
        parent.toggleSelectCell(self)
    }
}
