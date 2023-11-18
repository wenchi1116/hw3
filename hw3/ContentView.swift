//
//  ContentView.swift
//  hw3
//
//  Created by 許雯淇 on 2023/10/22.
//

import SwiftUI
import PhotosUI


struct ContentView: View {
    @State private var pictureUIImage: UIImage?
    
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var image: Image?
    @State private var isSaved: Bool = false // Flag to track whether the image is saved
    
    @State private var selectedWordIndex: Int = 0
    @State var write = false
    @State var word : String = ""
    @State var swords : Int = 0
    @State private var xAmount : CGFloat = 0.0
    @State private var yAmount : CGFloat = 0.0
    @State private var textsize : CGFloat = 1.0
    @State private var textColor = Color.orange
    @State var alignment : Int = 0
    @State private var changeColor = Color.black
    @State private var Time = Date()
    
    let words = ["","彩虹再虹，也沒有你的臉紅","好巧喔～跟我想的一樣","不要管我讓我哭一整天","嘿嘿嘿嘿我今天很開心，你呢！！！","早安！祝您有個美好的一天","人生無常，大腸包小腸","這我爸媽","歐耶！你看這次是我贏了","今天我生日，可以祝我生日快樂嗎"]
    let textAlignment:[TextAlignment] = [.leading, .center, .trailing]
    
    
    var body: some View {
        let pictureView = createPictureView(text: write ? words[swords] : word, textSize: textsize, xOffset: xAmount, yOffset: yAmount)
        
        NavigationStack{
            VStack{
                pictureView
                    .toolbar {
                        PhotosPicker(
                            selection: $selectedPhoto,
                            matching: .images
                        ) {
                            Image(systemName: "photo")
                        }
                    }
                    .task(id: selectedPhoto) {
                        image = try? await selectedPhoto?.loadTransferable(type: Image.self)
                    }
                
            }
            HStack{
                ZStack{
                    if write{
                        Text(words[swords])
                            .bold()
                            .offset(x: xAmount, y: yAmount)
                            .scaleEffect(textsize)
                            .foregroundColor(textColor)
                            .multilineTextAlignment(textAlignment[alignment])
                    }
                    else{
                        Text(word)
                            .bold()
                            .foregroundColor(textColor)
                            .offset(x: xAmount, y: yAmount)
                            .scaleEffect(textsize)
                    }
                }
                .hidden()
            }
            Form{
                HStack{
                    Text("字體大小")
                    Text(words[selectedWordIndex])
                        .font(.system(size: textsize))
                    Slider(value: $textsize, in: 5...20, step: 0.5)
                }
                HStack{
                    if write{
                        Picker("選一個喜歡的句子",selection: self.$swords){
                            ForEach(0..<words.count){(item) in
                                Text(self.words[(item)])
                            }
                        }.frame(width: 280, height: 100)
                            .clipped()
                            .pickerStyle(WheelPickerStyle())
                    }
                    else{
                        TextField("海綿寶寶萬歲",text: $word)
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.black))
                    }
                    Toggle("         幫配字",isOn: $write)
                    
                }.frame(minHeight: 0,maxHeight: 100)
                
                DisclosureGroup("文字細部調整"){
                    HStack{
                        Stepper(value: $xAmount, in: -200...200, step: 5){
                            Text("x = \(Int(xAmount))")
                        }
                        Stepper(value: $yAmount, in: -200...200, step: 5){
                            Text("y = \(Int(yAmount))")
                        }
                    }
                    
                    HStack{
                        ColorPicker("顏色", selection: $textColor)
                    }
                    
                }
                HStack{
                    DatePicker("製作時間", selection: $Time,displayedComponents: .date)
                }
                
                Button("儲存此張梗圖") {
                    let render = ImageRenderer(content: pictureView)
                    render.scale = UIScreen.main.scale
                    if let uiImage = render.uiImage {
                        pictureUIImage = uiImage
                        UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
                    }
                }
                .padding()
        
            }
        }
    }
    
    func createPictureView(text: String, textSize: CGFloat, xOffset: CGFloat, yOffset: CGFloat) -> some View {
        VStack {
            image?
                .resizable()
                .scaledToFill()
                .frame(width: 300, height: 200)
                .clipped()
            Text(text)
                .font(.system(size:textsize))
                .bold()
                .foregroundColor(textColor)
                .offset(x: xOffset, y: yOffset)
        }
    }
}

#Preview {
    ContentView()
}
