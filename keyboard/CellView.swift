import UIKit
import AudioToolbox

class CellView: UIView {
    let model = Model()
    let cellsModel = CellsModel()
    var summary: String!
    
    @IBOutlet weak var mainStackHeight: NSLayoutConstraint!
    @IBOutlet weak var nextKeyboardButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sendButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = true
        
//        sendButton.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/4)
        
        let cellNib = UINib(nibName: "Cell", bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: "Cell")
        
        let sectionNib = UINib(nibName: "Section", bundle: nil)
        collectionView.register(sectionNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Section")
        
        model.delegate = self
    }
    
    func setNextKeyboardVisible(_ visible: Bool) {
        nextKeyboardButton.isHidden = !visible
    }
}

extension CellView: ModelDelegate {
    func timesUpdated (_ times: [Date]) {
        self.summary = summaryFromTimes(times, model.theirTimeZone)
    }
}

extension CellView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return cellsModel.daysShown.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return cellsModel.hoursShown.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        cell.textLabel.text = String(cellsModel.hoursShown[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: "Section",
                                                                   for: indexPath) as! Section
        
        let dayDisplay = absoluteTimeToDisplayDay(daysFromToday: indexPath.section, absoluteTime: cellsModel.daysShown[indexPath.section])
  
        view.textLabel.text = dayDisplay
        return view
    }
}

extension CellView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var dateComponent = absoluteTimeToDateComponent(cellsModel.daysShown[indexPath.section], TimeZone.autoupdatingCurrent)
        dateComponent.hour = cellsModel.hoursShown[indexPath.row]
        dateComponent.minute = 0
        dateComponent.nanosecond = 0
        let absoluteTime = dateComponentToAbsoluteTime(dateComponent)
        model.addATime(absoluteTime)
        AudioServicesPlaySystemSound(1519)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        var dateComponent = absoluteTimeToDateComponent(cellsModel.daysShown[indexPath.section], TimeZone.autoupdatingCurrent)
        dateComponent.hour = cellsModel.hoursShown[indexPath.row]
        dateComponent.minute = 0
        dateComponent.nanosecond = 0
        let absoluteTime = dateComponentToAbsoluteTime(dateComponent)
        model.removeATime(absoluteTime)
        AudioServicesPlaySystemSound(1519)
    }
}

extension CellView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 25, height: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 8, left: 4, bottom: 8, right: 4)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.bounds.size.width, height: 25)
    }
    
}
