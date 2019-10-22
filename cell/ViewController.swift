import UIKit

class ViewController: UIViewController {
    
    let model = Model()
    let cellsModel = CellsModel()

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var previewLabel: UILabel!
    @IBOutlet weak var timeZonePicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.delegate = self
        
        timeZonePicker.delegate = self
        timeZonePicker.dataSource = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let cellNib = UINib(nibName: "Cell", bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: "Cell")
        
        let sectionNib = UINib(nibName: "Section", bundle: nil)
        collectionView.register(sectionNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Section")
        
    }

}

extension ViewController: ModelDelegate {
    func timesUpdated (_ times: [Date]) {
        let summary = summaryFromTimes(times, model.theirTimeZone)
        previewLabel.text = summary
    }
}


extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return TimeZone.knownTimeZoneIdentifiers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return TimeZone.knownTimeZoneIdentifiers[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        model.updateTheirTimeZone(TimeZone(identifier: TimeZone.knownTimeZoneIdentifiers[row])!)
    }
}


extension ViewController: UICollectionViewDataSource {
    
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

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var dateComponent = absoluteTimeToDateComponent(cellsModel.daysShown[indexPath.section], TimeZone.autoupdatingCurrent)
        dateComponent.hour = cellsModel.hoursShown[indexPath.row]
        dateComponent.minute = 0
        dateComponent.nanosecond = 0
        let absoluteTime = dateComponentToAbsoluteTime(dateComponent)
        model.addATime(absoluteTime)
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {

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
