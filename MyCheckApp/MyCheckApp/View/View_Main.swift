//
//  View_Main.swift
//  MyCheckApp
//
//  Created by 전수형 on 2021/08/05.
//
// push notification 기능은 아직 미구현. 추구 구현 후 앱스토어에 업로드 해야함


import SwiftUI
import UserNotifications

struct View_Main: View {
    @EnvironmentObject var store: CoreDataManager
    @EnvironmentObject var formatter: DateFormatter
    @EnvironmentObject var keyboard: KeyboardObserver
    @State private var content: String = ""
    @Binding var showComposer: Bool
    
    @State var add: Bool = false
    @State var result_check: Bool = false
    @State var alertActivated: Bool = false
    @State var alert = false
    
    var memo: MemoEntity? = nil
    
    @FetchRequest(entity: MemoEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \MemoEntity.insertDate, ascending: false)])
    
    //목록을 저장할 속성 memoList
    var memoList: FetchedResults<MemoEntity>
    
    var body: some View {
        
        NavigationView {
            GeometryReader { geometryreader in
                ZStack{
                    if memoList.count == 0 {
                        VStack {
                            Spacer()
                            Text("오늘 할 일을 추가하세요!")
                                .foregroundColor(.gray)
                            Spacer()
                            Spacer()
                        }
                        .navigationBarTitle("오늘 할 일 :)")
                        .navigationBarItems(trailing: PlusButton(show: $add, content: $content))
                        .frame(width : geometryreader.size.width,
                               height : geometryreader.size.height,
                               alignment : .center)
                        
                    }
                    else{
                        List {
                            ForEach (memoList) { memo in
                                MemoCell(memo: memo, showComposer: $showComposer)
                            }
                            .onDelete(perform: (delete))
                        }
                        .navigationBarTitle("오늘 할 일 :)")
                        .navigationBarItems(
                            trailing:
                                HStack(spacing: 0){
                                    Button(action: {
                                        alertActivated.toggle()
                                        
                                        
                                        //result_check가 true면 모든 할일을 완수한 것. false면 하나라도완수하지 못한것. 이걸로 달력에 완수한 것을 표시
                                        for a in 0...memoList.count-1 {
                                            if memoList[a].checklist == false {
                                                result_check = false
                                                break
                                            }else {
                                                result_check = true
                                            }
                                        }
                                        print("result_checklist : \(result_check)")
                                        
                                        self.store.add_result_checklist(memo: memoList[memoList.count-1], result_check: result_check)
                                        
                                        print("\(memoList)")
                                    }, label: {
                                        Image(systemName: "square.and.arrow.up")
                                            .padding(.trailing)
                                    })
                                    PlusButton(show: $add, content: $content)
                                    if memoList[memoList.count-1].resultchecklist == true {
                                        Image(systemName: "checkmark.seal.fill")
                                            .foregroundColor(.green)
                                    }
                                    else {
                                        Image(systemName: "xmark.seal.fill")
                                            .foregroundColor(.red)
                                    }
                                })
                        .frame(width : geometryreader.size.width,
                               height : geometryreader.size.height,
                               alignment : .center)
                    }
                }
                .alert(isPresented: $alertActivated, content: {
                    Alert(title: Text("진행상황을 평가합니다 :)"),  dismissButton: .default(Text("확인")))
                })
            }
        }
    }
    func delete(set : IndexSet) {
        for index in set {
            store.delete(memo: memoList[index])
        }
    }
}

fileprivate struct PlusButton: View{
    @Binding var show: Bool
    @EnvironmentObject var store: CoreDataManager
    @Binding var content: String
    
    var memo: MemoEntity? = nil
    
    var body: some View{
        Button(action: {
            //memo가 전달되었다면
            if let memo = self.memo {
                self.store.update(memo: memo, content: self.content)
            }else{
                //저장한 내용을 저장
                self.store.addMemo(content: self.content)
            }
            self.show = false
        }, label: {
            Image(systemName: "plus")
                .padding(.trailing)
        })
    }
}

struct View_Main_Previews: PreviewProvider {
    static var previews: some View {
        View_Main(showComposer: .constant(false))
            .environmentObject(CoreDataManager.shared)
            .environmentObject(DateFormatter.memoDateFormatter)
    }
}
