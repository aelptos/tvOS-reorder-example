//	
//  Copyright © Aelptos. All rights reserved.
//

import UIKit

final class ItemsViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var editModeEnabled: Bool {
        get { collectionView.isEditing }
    }
    
    private var items = [Item]()
    private var movingItems: [Item]!
    private var selectedCell: ItemCollectionViewCell?
    private var isMovingItem = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make some items
        (0..<100).forEach { items.append(Item(title: "Item \($0 + 1)", position: $0)) }
    }
    
    func toggleEditMode(_ enabled: Bool) {
        collectionView.isEditing = enabled
        if enabled {
            movingItems = items
        }
    }
    
    func toggleSelectCell(_ cell: ItemCollectionViewCell) {
        if selectedCell == cell {
            cell.stopWiggle()
            selectedCell = nil
            return
        }
        selectedCell = cell
        cell.startWiggle()
    }
    
    func changeOrder() {
        toggleEditMode(false)
        items = movingItems
        commit()
    }
    
    func revertOrderChanges() {
        toggleEditMode(false)
        commit()
    }
    
    private func commit() {
        movingItems = nil
        collectionView.reloadData()
        collectionView.setNeedsFocusUpdate()
    }
}

extension ItemsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as! ItemCollectionViewCell
        cell.update(with: items[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldUpdateFocusIn context: UICollectionViewFocusUpdateContext) -> Bool {
        if !collectionView.isEditing { return true }
        guard let _ = selectedCell else { return true }
        guard let currentIndexPath = context.previouslyFocusedIndexPath, let nextIndexPath = context.nextFocusedIndexPath else { return false }
        guard !isMovingItem else { return false }
        isMovingItem = true
        collectionView.moveItem(at: currentIndexPath, to: nextIndexPath)
        movingItems.moveItem(from: currentIndexPath.row, to: nextIndexPath.row)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.isMovingItem = false
        }
        return false
    }
}

extension ItemsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 300, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        50
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        50
    }
}
