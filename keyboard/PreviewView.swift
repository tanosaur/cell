import UIKit

class PreviewView: UIView {
    var summary: String!
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var previewTextLabel: UILabel!
    @IBOutlet weak var nextKeyboardButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    
    }
    
    func setNextKeyboardVisible(_ visible: Bool) {
        nextKeyboardButton.isHidden = !visible
    }
}

extension PreviewView: ModelDelegate {
    func timesUpdated (_ times: [Date]) {
        self.summary = summaryFromTimes(times, model.theirTimeZone)
    }
}
