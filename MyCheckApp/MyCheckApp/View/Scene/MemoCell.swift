//
//  MemoCell.swift
//  SwiftUIMemo
//
//  Created by 전수형 on 2021/07/28.
//

import SwiftUI

//body에 있던 뷰를 분리했음. shift+command+a -> Extract Subview -> 새로운 SwiftUI.swift에 저장
struct MemoCell: View {
    @ObservedObject var memo: MemoEntity
    @EnvironmentObject var formatter: DateFormatter
    @Binding var showComposer: Bool
    @EnvironmentObject var store: CoreDataManager
    
    var memo3: MemoEntity? = nil
    @State private var content: String = ""
    @State private var check: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack (alignment: .leading, spacing: 0){
                    if memo.checklist == false {
                        TextField("오늘 할 일을 입력하세요!", text: $content)
                            
                            .font(.system(size: 20))
                            .onChange(of: self.content,
                                    perform: { value in
                                    self.store.update(memo: memo, content: self.content)
                                        
                            })
                            .frame(minWidth: 100, minHeight:  50)
                    } else {
                        Text("\(content)")
                            .strikethrough(true)
                            .font(.system(size: 20))
                            .frame(minHeight:  50)
                    }
                    
                    Divider()
                     .frame(height: 1)
                     .padding(.horizontal, 30)
                     .background(Color.gray)
                }
                    
                
                Spacer()
                
                Button(action: {
                    withAnimation{
                        self.check.toggle()
                    }
                    self.store.update_checklist(memo: memo, check: self.check)
                    
                }, label: {
                    if(memo.checklist == true) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.largeTitle)
                            .padding(.horizontal)
                            .foregroundColor(.green)
                    }else {
                        Image(systemName: "circle")
                            .font(.largeTitle)
                            .padding(.horizontal)
                            .foregroundColor(.red)
                    }
                })
            
            }
            
            HStack{
                Text("\(memo.insertDate ?? Date(), formatter: self.formatter)")
                    //caption으로 날짜부분의 text 스타일을 바꿔줌
                    .font(.caption)
                    .foregroundColor(Color(UIColor.secondaryLabel))
            }
            
        }
        .onAppear {
            self.content = self.memo.content ?? ""
            
        }
    }
}

fileprivate struct SaveButton: View{
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
            Text("Save")
        })
    }
}

extension UITextView {
    func increaseFontSize () {
        self.font =  UIFont(name: (self.font?.fontName)!, size: (self.font?.pointSize)!+1)!
    }
}


struct MemoCell_Previews: PreviewProvider {
    static var previews: some View {
        //Previews에서는 "Test"라는 더미데이터를 주어서 오류를 해결
        MemoCell(memo: MemoEntity(context: CoreDataManager.mainContext), showComposer: .constant(false))
            .environmentObject(DateFormatter.memoDateFormatter)
    }
}
