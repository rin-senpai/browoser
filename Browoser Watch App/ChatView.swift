//
//  ChatView.swift
//  Browoser Watch App
//
//  Created by 小鳥遊りん on 15/11/2023.
//

import SwiftUI
import GoogleGenerativeAI

struct ChatView: View {
    @State var message: String = ""
    @State var introMessage: LocalizedStringKey
    
    @State var scrollingUp: Bool = false
    @State var previousViewOffset: CGFloat = 0
    let minimumOffset: CGFloat = 16
    @State var wholeSize: CGSize = .zero
    @State var scrollViewSize: CGSize = .zero
    
    let model = GenerativeModel(
        name: "gemini-1.5-flash-latest",
        apiKey: APIKey.default,
        safetySettings: [
            SafetySetting(harmCategory: .dangerousContent, threshold: .blockNone),
            SafetySetting(harmCategory: .harassment, threshold: .blockNone),
            SafetySetting(harmCategory: .hateSpeech, threshold: .blockNone),
            SafetySetting(harmCategory: .sexuallyExplicit, threshold: .blockNone)
        ]
    )
    var chat: Chat
    @State var history: [ModelContent]
    
    init() {
        print("innit")
        chat = model.startChat()
        history = chat.history
        
        let randomGenerator = Random()
        var random = Int(abs(randomGenerator.gaussRand) * 3)
        
        if random > 10 {
            random = 10
        } else if random == 0 {
            random = 1
        }

        introMessage = LocalizedStringKey(String(localized: LocalizedStringResource(stringLiteral: String(random))))
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ChildSizeReader(size: $wholeSize) {
                ScrollView {
                    ChildSizeReader(size: $scrollViewSize) {
                        VStack {
                            MessageView(content: introMessage, fromSelf: false)
                                .id(-1)

                            ForEach(Array(zip(history.indices, history)), id: \.0) { index, message in
                                MessageView(content: LocalizedStringKey(message.parts[0].text!), fromSelf: message.role == "user")
                            }
                            TextField(
                                "",
                                text: $message
                            )
                            .id(-2)
                            .textFieldStyle(MessageFieldStyle())
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                            .onSubmit {
                                let userResponse = $message.wrappedValue
                                $message.wrappedValue = ""
                                history.append(ModelContent(role: "user", parts: userResponse))
                                history.append(ModelContent(role: "model", parts: ""))
                                Task {
                                    _ = try await chat.sendMessage(userResponse)
                                    history = chat.history
                                    proxy.scrollTo(history.count - 2)
                                }
                            }
                            .onChange(of: history.count) {
                                withAnimation(.easeInOut) {
                                    proxy.scrollTo(history.count - 1)
                                }
                            }
                        }
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                HStack {
                                    if scrollingUp {
                                        Button {
                                            withAnimation(.easeInOut) {
                                                proxy.scrollTo(-1)
                                            }
                                        } label: {
                                            Image(systemName: "chevron.up").foregroundStyle(.blue)
                                        }
                                    } else {
                                        Button {
                                            withAnimation(.easeInOut) {
                                                proxy.scrollTo(-2)
                                            }
                                        } label: {
                                            Image(systemName: "chevron.down").foregroundStyle(.blue)
                                        }
                                    }
                                }
                            }
                        }.background(GeometryReader { proxy in // https://stackoverflow.com/questions/59342384/how-to-detect-scroll-direction-programmatically-in-swiftui-scrollview
                            Color.clear.preference(key: ViewOffsetKey.self, value: -1 * proxy.frame(in: .named("scroll")).origin.y)
                        }).onPreferenceChange(ViewOffsetKey.self) { value in
                            let offsetDifference: CGFloat = abs(self.previousViewOffset - value)

                            if value == 0 { // top of screen
                                scrollingUp = false
                            } else if value >= scrollViewSize.height - wholeSize.height { // bottom of screen https://stackoverflow.com/questions/68681075/how-do-i-detect-when-user-has-reached-the-bottom-of-the-scrollview
                                scrollingUp = true
                            } else {
                                if self.previousViewOffset > value { // scrolling up
                                    scrollingUp = true
                                } else { // scrolling down
                                    scrollingUp = false
                                }

                                if offsetDifference > minimumOffset {
                                    self.previousViewOffset = value
                                }
                            }
                    }
                    }
                }.coordinateSpace(name: "scroll")
            }
        }
    }
}

struct MessageView: View {
    var content: LocalizedStringKey
    var fromSelf: Bool
    
    let systemBackground = Color(hex: "#1A1A1A")
    
    var body: some View {
        HStack {
            if fromSelf {
                Spacer()
            }
            if content == "" {
                HStack(spacing: 6) {
                    DotView(delay: 0)
                    DotView(delay: 0.3)
                    DotView(delay: 0.6)
                }
                    .padding(14)
                    .frame(minWidth: 34)
                    .background(fromSelf ? .blue : systemBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .frame(maxWidth: 160, alignment: fromSelf ? .trailing : .leading)
            } else {
                Text(content)
                    .padding()
                    .frame(minWidth: 34)
                    .background(fromSelf ? .blue : systemBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .frame(maxWidth: 160, alignment: fromSelf ? .trailing : .leading)
            }
            if !fromSelf {
                Spacer()
            }
        }
    }
}

struct DotView: View {
    @State var delay: Double = 0
    @State var opacity: CGFloat = 0.8
    
    var body: some View {
        Circle()
            .frame(width: 8, height: 8)
            .opacity(opacity)
            .onAppear {
                withAnimation(.linear(duration: 0.9).repeatForever().delay(delay)) {
                    opacity = opacity == 0.2 ? 0.8 : 0.2
                }
            }
    }
}

public struct MessageFieldStyle : TextFieldStyle {
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .frame(height: 40)
            .background(
                RoundedRectangle(cornerRadius: .infinity)
                    .stroke(Color.white, lineWidth: 4.0)
            )
            .clipShape(RoundedRectangle(cornerRadius: .infinity))
            .foregroundStyle(.clear)
            .padding([.top, .leading, .trailing])
            .opacity(0.1)
            .overlay(alignment: .leading) {
                HStack {
                    Text("Message...")
                        .padding(.leading, 24)
                        .padding(.top)
                        .font(.caption)
                        .foregroundStyle(.gray.opacity(0.8))
                    
                }
                .allowsHitTesting(false)
            }
            .submitLabel(.send)
    }
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

struct SizePreferenceKey: PreferenceKey {
  typealias Value = CGSize
  static var defaultValue: Value = .zero

  static func reduce(value _: inout Value, nextValue: () -> Value) {
    _ = nextValue()
  }
}

struct ChildSizeReader<Content: View>: View {
  @Binding var size: CGSize

  let content: () -> Content
  var body: some View {
    ZStack {
      content().background(
        GeometryReader { proxy in
          Color.clear.preference(
            key: SizePreferenceKey.self,
            value: proxy.size
          )
        }
      )
    }
    .onPreferenceChange(SizePreferenceKey.self) { preferences in
      self.size = preferences
    }
  }
}

class Random {
    var s : Double = 0.0
    var v2 : Double = 0.0

    var gaussRand : Double  {
        var u1, u2, v1, x : Double
        repeat {
            u1 = Double(arc4random()) / Double(UINT32_MAX)
            u2 = Double(arc4random()) / Double(UINT32_MAX)
            v1 = 2 * u1 - 1
            v2 = 2 * u2 - 1
            s = v1 * v1 + v2 * v2
        } while (s >= 1 || s == 0)
        x = v1 * sqrt(-2 * log(s) / s)
        return x
    }
}

#Preview {
    NavigationStack {
        ChatView()
    }
}
