//
//  StylePickerViewController.swift
//  BeerBuddy
//
//  Created by Alexei Baboulevitch on 2018-8-1.
//  Copyright © 2018 Alexei Baboulevitch. All rights reserved.
//
//  This file is part of Good Spirits.
//
//  Good Spirits is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  Good Spirits is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with Foobar.  If not, see <https://www.gnu.org/licenses/>.
//

import UIKit
import DrawerKit
import DataLayer

public protocol StylePickerViewControllerDelegate: class
{
    func drawerHeight(for: StylePickerViewController) -> CGFloat
    func startingStyle(for: StylePickerViewController) -> DrinkStyle
    func startingName(for: StylePickerViewController) -> String?
    func didSetStyle(_ vc: StylePickerViewController, to: DrinkStyle, withName: String?)
}

public class StylePickerViewController: CheckInDrawerViewController
{
    public weak var delegate: StylePickerViewControllerDelegate!
    
    @IBOutlet private var stylePicker: UIPickerView!
    @IBOutlet private var name: UITextField!
    
    private static let validStyles = DrinkStyle.displayableStyles
    
    public override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let styleIndex = StylePickerViewController.validStyles.index(of: self.delegate.startingStyle(for: self))!
        
        self.stylePicker.selectRow(styleIndex, inComponent: 0, animated: false)
        self.name.text = self.delegate.startingName(for: self)
    }
    
    public var selectedStyle: DrinkStyle
    {
        return StylePickerViewController.validStyles[self.stylePicker.selectedRow(inComponent: 0)]
    }
    
    public var selectedName: String?
    {
        if self.name.text?.isEmpty == true
        {
            return nil
        }
        else
        {
            return self.name.text
        }
    }
    
    public override func confirmCallback(_ deleted: Bool = false)
    {
        self.delegate.didSetStyle(self, to: self.selectedStyle, withName: self.selectedName)
    }
}

extension StylePickerViewController: UITextFieldDelegate
{
    public func textFieldDidEndEditing(_ textField: UITextField)
    {
        textField.text = textField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    // AB: quick hack to prevent keyboard from showing up on clear (https://stackoverflow.com/a/26547461/89812)
    public func textFieldShouldClear(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        textField.text = nil
        return false
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
}

extension StylePickerViewController: UIPickerViewDelegate, UIPickerViewDataSource
{
    public func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return StylePickerViewController.validStyles.count
    }

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        let style = StylePickerViewController.validStyles[row]
        
        return Format.format(style: style)
    }
}
