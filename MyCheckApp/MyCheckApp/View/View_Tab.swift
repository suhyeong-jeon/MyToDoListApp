//
//  View_Tab.swift
//  MyCheckApp
//
//  Created by 전수형 on 2021/08/09.
//

import SwiftUI

struct View_Tab: View {
    @EnvironmentObject var store: CoreDataManager
    @Environment(\.calendar) var calendar
    @EnvironmentObject var formatter: DateFormatter
    
    

    
    @FetchRequest(entity: MemoEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \MemoEntity.insertDate, ascending: false)])
    
    //목록을 저장할 속성 memoList
    var memoList: FetchedResults<MemoEntity>
    
        private var year: DateInterval {
            calendar.dateInterval(of: .month, for: Date())!
        }
    
    var body: some View {
        TabView {
            View_Main(showComposer: .constant(false))
                .tabItem {
                    Image(systemName: "pencil.tip.crop.circle")
                    Text("메인")
                }
                .tag(0)
            
            CalendarView(interval: self.year) { date in
                                Text("30")
                                    .hidden()
                                    .padding(8)
                                    .background(1 != 1 ? Color.red : Color.blue) // Make your logic
                                    .clipShape(Rectangle())
                                    .cornerRadius(4)
                                    .padding(4)
                                    .overlay(
                                        Text(String(self.calendar.component(.day, from: date)))
                                            .foregroundColor(Color.black)
                                            .underline(2 == 2) //Make your own logic
                                    )
            
                        }
            .tabItem {
                Image(systemName: "calendar")
                Text("달력")
            }
            .tag(1)
        }
    }
}


struct View_Tab_Previews: PreviewProvider {
    static var previews: some View {
        View_Tab()
    }
}
