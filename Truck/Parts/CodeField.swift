// CodeField.swift
//
// Created by  brownsoo han

import UIKit

public protocol CodeFieldDelegate {
    func codeDidChanged(code: String) -> Void
}

@IBDesignable
public class CodeField: UIView, UITextFieldDelegate {
    
    static let defaultUnderlineFilledColor = UIColor(red: 74/255.0,
                                                     green: 144/255.0,
                                                     blue: 226/255.0,
                                                     alpha: 1.0)
    static let defaultUnderlineColor = UIColor(white: 0.95, alpha: 1)
    static let defaultUnderlineHeight: CGFloat = 3.0
    static let defaultUnderlineEditingColor = UIColor.black
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        onInit()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        onInit()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        onInit()
    }
    
    @IBInspectable
    public var codeCount: Int {
        get {
            return _codeCount
        }
        set {
            if newValue > 0 {
                _codeCount = newValue
                let new = newValue
                if _codeCount != new {
                    resetCodeViews()
                }
            }
        }
    }
    
    @IBInspectable
    public var oneCodeLength: Int = 1 {
        didSet {
            boxes.forEach { $0.maxLength = oneCodeLength }
        }
    }
    
    @IBInspectable
    public var oneCodePlaceHolder: String? = "" {
        didSet {
            boxes.forEach { $0.placeholder = oneCodePlaceHolder }
        }
    }
    
    // TODO: make responsive height with font
    @IBInspectable
    public var codeHeight: CGFloat = 58 {
        didSet {
            boxes.forEach { $0.heightConstraint?.constant = codeHeight }
        }
    }
    
    @IBInspectable
    public var codeDistribution: UIStackView.Distribution = .fillEqually {
        didSet {
            stack.distribution = codeDistribution
        }
    }
    
    @IBInspectable
    public var label: String? = nil {
        didSet {
            labelView.text = label
        }
    }
    
    @IBInspectable
    public var underlineDefaultColor: UIColor = CodeField.defaultUnderlineColor {
        didSet {
            boxes.forEach { $0.underlineDefaultColor = underlineDefaultColor }
        }
    }
    
    @IBInspectable
    public var underlineFilledColor: UIColor = CodeField.defaultUnderlineFilledColor {
        didSet {
            boxes.forEach { $0.underlineFilledColor = underlineFilledColor }
        }
    }
    
    @IBInspectable
    public var underlineEditingColor: UIColor = CodeField.defaultUnderlineEditingColor {
        didSet {
            boxes.forEach { $0.underlineEditingColor = underlineEditingColor }
        }
    }
    
    @IBInspectable
    public var underlineHeight: CGFloat = CodeField.defaultUnderlineHeight {
        didSet {
            boxes.forEach { $0.underlineHeight = underlineHeight }
        }
    }
    
    @IBInspectable
    public var code: String {
        set(new) {
            let count = new.count
            let boxCount = boxes.count
            for i in 0..<boxCount {
                if i < count {
                    let char = new.enumerated().first { offset, _ in offset == i }?.element
                    if char != nil {
                        boxes[i].tf.text = String(char!)
                        continue
                    }
                }
                boxes[i].tf.text = ""
            }
        }
        get {
            return codes.joined()
        }
    }
    
    public var allFilled: Bool {
        return codes.filter{ $0.isEmpty }.count == 0
    }
    
    @IBInspectable
    public var helper: String? = nil {
        didSet {
            helperLb.text = helper
            if helper == nil {
                helperBottomConstraint?.isActive = false
            } else {
                helperBottomConstraint?.isActive = true
            }
        }
    }
    
    @IBInspectable
    public var helperFont = UIFont.systemFont(ofSize: 13, weight: .regular) {
        didSet {
            helperLb.font = helperFont
        }
    }
    
    @IBInspectable
    public var helperTextColor = UIColor(red: 52/255.0, green: 58/255.0, blue: 64/255.0, alpha: 1.0) {
        didSet {
            helperLb.textColor = helperTextColor
        }
    }
    
    @IBInspectable
    public var isEnabled: Bool = true {
        didSet {
            boxes.forEach { $0.tf.isEnabled = isEnabled }
        }
    }
    
    @IBInspectable
    public var keyboardType: UIKeyboardType = .numberPad {
        didSet {
            boxes.forEach { $0.keyboardType = keyboardType }
        }
    }
    
    public var delegate: CodeFieldDelegate?
    
    private var _codeCount: Int = 6
    private lazy var klassName = "CodeField@\(hash)"
    private lazy var labelView = UILabel()
    private lazy var helperLb: UILabel = {
        let lb = UILabel()
        lb.font = helperFont
        lb.textColor = helperTextColor
        lb.setContentCompressionResistancePriority(.required, for: .vertical)
        lb.setContentHuggingPriority(.required, for: .vertical)
        return lb
    }()
    private var helperBottomConstraint: NSLayoutConstraint?
    private lazy var stack = UIStackView()
    private var codes = [String]()
    private var boxes = [CharBox]()
    private var cursor: Int = 0 {
        didSet {
            let box = boxes.first { $0.tag == cursor }
            box?.tf.becomeFirstResponder()
            box?.updateFilled()
        }
    }
    
    @discardableResult
    public override func becomeFirstResponder() -> Bool {
        if let tf = boxes.first?.tf {
            return tf.becomeFirstResponder()
        }
        return false
    }
    
    public override func layoutSubviews() {
        print(klassName, "layoutSubviews")
        // setup()
        super.layoutSubviews()
    }
    
    private func onInit() {
        print(klassName, "onInit")
        
        addSubview(labelView)
        labelView.textColor = UIColor(red: 52/255.0, green:58/255.0, blue:64/255.0, alpha: 1.0)
        labelView.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        labelView.translatesAutoresizingMaskIntoConstraints = false
        labelView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        labelView.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor).isActive = true
        labelView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        addSubview(stack)
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .top
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stack.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        stack.topAnchor.constraint(equalTo: labelView.bottomAnchor, constant: 8).isActive = true
        let bottomConstraint = stack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        bottomConstraint.priority = .defaultLow
        bottomConstraint.isActive = true
        
        addSubview(helperLb)
        helperLb.translatesAutoresizingMaskIntoConstraints = false
        helperLb.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        helperLb.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        helperLb.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 8).isActive = true
        helperBottomConstraint = helperLb.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        
        resetCodeViews()
    }
    
    private func resetCodeViews() {
        print(klassName, "resetCodeViews")
        
        if stack.superview != nil {
            for child in stack.subviews {
                stack.removeArrangedSubview(child)
                child.removeFromSuperview()
                for con in child.constraints {
                    child.removeConstraint(con)
                }
                (child as? CharBox)?.onDeleteNothing = nil
                (child as? CharBox)?.onTextChanged = nil
            }
        }
        
        codes.removeAll(keepingCapacity: false)
        boxes.removeAll(keepingCapacity: false)
        for idx in 0..<codeCount {
            let charBox = CharBox(tag: idx)
            charBox.translatesAutoresizingMaskIntoConstraints = false
            charBox.heightConstraint = charBox.heightAnchor.constraint(equalToConstant: codeHeight)
            charBox.heightConstraint?.isActive = true
            charBox.keyboardType = keyboardType
            //charBox.underlineHeight = underlineHeight
            charBox.underlineFilledColor = underlineFilledColor
            charBox.underlineDefaultColor = underlineDefaultColor
            charBox.underlineEditingColor = underlineEditingColor
            charBox.maxLength = oneCodeLength
            charBox.placeholder = oneCodePlaceHolder
            charBox.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
            stack.addArrangedSubview(charBox)
            charBox.onTextChanged = {
                self.onTextChanged(text: $0, tag: idx)
            }
            charBox.onDeleteNothing = {
                self.onDeleteNothing(tag: $0)
            }
            codes.append("")
            boxes.append(charBox)
        }
        
        if helper != nil {
            helperBottomConstraint?.isActive = true
        } else {
            helperBottomConstraint?.isActive = false
        }
    }
    
    private func onTextChanged(text: String?, tag: Int) {
        print(klassName, "onTextChanged \(oneCodeLength)")
        codes[tag] = text ?? ""
        if text != nil && !(text!.isEmpty) && text!.count == oneCodeLength {
            cursor = min(codeCount - 1, tag + 1)
        }
        delegate?.codeDidChanged(code: self.code)
    }
    
    private func onDeleteNothing(tag: Int) {
        print(klassName, "onDeleteNothing \(tag)")
        cursor = max(0, tag - 1)
        if tag - 1 >= 0 {
            boxes[tag - 1].tf.text = nil
            codes[tag - 1] = ""
        }
        delegate?.codeDidChanged(code: self.code)
    }
    
}

fileprivate class CharBox: UIView, UITextFieldDelegate {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }
    
    convenience init(tag: Int = 0) {
        self.init(frame: CGRect())
        self.tag = tag
        setupLayout()
    }
    
    let tf = NTextField()
    let line = UIView()
    var onDeleteNothing: ((Int) -> Void)?
    var onTextChanged: ((String?) -> Void)?
    private(set) var filled: Bool = false {
        didSet {
            updateUnderline()
        }
    }
    var heightConstraint: NSLayoutConstraint?
    private var lineHeighConstraint: NSLayoutConstraint?
    var underlineHeight: CGFloat = CodeField.defaultUnderlineHeight {
        didSet {
            lineHeighConstraint?.constant = underlineHeight
        }
    }
    var underlineDefaultColor = CodeField.defaultUnderlineColor {
        didSet {
            updateUnderline()
        }
    }
    var underlineFilledColor = CodeField.defaultUnderlineFilledColor {
        didSet {
            updateUnderline()
        }
    }
    var underlineEditingColor = CodeField.defaultUnderlineEditingColor {
        didSet {
            updateUnderline()
        }
    }
    var maxLength: Int = 1
    var keyboardType: UIKeyboardType = .numberPad {
        didSet {
            tf.keyboardType = keyboardType
        }
    }
    var placeholder: String? = nil {
        didSet {
            tf.placeholder = placeholder
        }
    }
    
    private func updateUnderline() {
        if isEditing {
            line.backgroundColor = underlineEditingColor
        } else if filled {
            line.backgroundColor = underlineFilledColor
        } else {
            line.backgroundColor = underlineDefaultColor
        }
    }
    
    private var isEditing: Bool = false
    
    private func setupLayout() {
        
        self.addSubview(tf)
        tf.placeholder = placeholder
        tf.textAlignment = .center
        tf.textColor = UIColor.black
        tf.font = UIFont.systemFont(ofSize: 33, weight: .medium)
        tf.keyboardType = keyboardType
        tf.textAlignment = .center
        tf.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = tf.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor)
        topConstraint.priority = .defaultLow
        topConstraint.isActive = true
        tf.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        tf.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        tf.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        tf.deleteBackNothing = {
            self.onDeleteNothing?(self.tag)
        }
        tf.delegate = self
        tf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        self.addSubview(line)
        line.backgroundColor = underlineDefaultColor
        line.translatesAutoresizingMaskIntoConstraints = false
        lineHeighConstraint = line.heightAnchor.constraint(equalToConstant: underlineHeight)
        lineHeighConstraint?.isActive = true
        line.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        line.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        line.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
    }
    
    func updateFilled() {
        let t = tf.text
        self.filled = t != nil && !(t!.isEmpty)
    }
    
    @objc
    private func textFieldDidChange() {
        let t = tf.text
        updateFilled()
        onTextChanged?(t)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= maxLength
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isEditing = true
        updateFilled()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        isEditing = false
        updateFilled()
    }
}

fileprivate class NTextField: UITextField {
    /// Called when nothing to delete with the back-key pressed
    var deleteBackNothing: (() -> Void)?
    
    override func deleteBackward() {
        if self.text == nil || self.text!.isEmpty {
            deleteBackNothing?()
        }
        super.deleteBackward()
    }
}

