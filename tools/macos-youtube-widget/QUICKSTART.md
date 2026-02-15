# macOS YouTube Widget Quickstart

이 폴더에는 WidgetKit 코드(위젯 UI)만 포함되어 있습니다.

## 설치 방법(3분)
1) Xcode 실행 → File → New → Project… → App(SwiftUI) 생성
   - Product Name: `MyYouTubeWidget`
2) File → New → Target… → **Widget Extension** 추가
3) 위젯 타겟의 자동 생성된 `...Widget.swift` 파일을 열고 내용을 전부 지운 뒤,
   `tools/macos-youtube-widget/YouTubeWidget.swift` 내용을 그대로 붙여넣기
4) Run(▶︎) 후, macOS 위젯 목록에서 **"YouTube 바로가기"** 추가

## 링크
- 검색바: https://youtube.com/results?search_query=
- 홈: https://youtube.com/
- Shorts: https://youtube.com/shorts/
- 구독: https://youtube.com/feed/subscriptions
