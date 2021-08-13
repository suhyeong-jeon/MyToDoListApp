//
//  DateFormatter+Memo.swift
//  SwiftUIMemo
//
//  Created by 전수형 on 2021/07/28.
//

import Foundation

extension DateFormatter {
    static let memoDateFormatter: DateFormatter = {
       let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .short
        f.locale = Locale(identifier: "Ko_kr")
        return f
    }()
}

//선언만 추가
extension DateFormatter: ObservableObject {
    
}

