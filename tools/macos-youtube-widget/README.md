# MyYouTubeWidget (WidgetKit) 코드

요구사항 반영:
- 브라우저로 열기
- 링크는 `m.` 없이
- 다크 고정 X → **시스템 테마 따라가기**
- 위젯 UI: (상단) 검색바 느낌 + (하단) 홈/Shorts/구독 3버튼

## 1) Xcode에서 프로젝트 생성
1. Xcode → **File → New → Project…**
2. **App** 선택
   - Product Name: `MyYouTubeWidget`
   - Interface: SwiftUI
   - Language: Swift
3. 생성 후: **File → New → Target… → Widget Extension** 추가
   - Include Configuration Intent: 꺼도 됨

## 2) 파일 붙여넣기
Widget Extension 타겟(예: `MyYouTubeWidgetExtension`) 폴더에 아래 파일을 추가/교체:
- `YouTubeWidget.swift` (이 폴더에 같이 제공)

기존에 자동 생성된 위젯 파일이 있으면 삭제하거나 내용 교체해도 됨.

## 3) 테스트
- Run 스킴을 위젯 포함된 앱으로 실행
- macOS: 알림센터/데스크탑에서 위젯 추가 → `MyYouTubeWidget`

## 4) 링크
- Search bar: https://youtube.com/
- 홈: https://youtube.com/
- Shorts: https://youtube.com/shorts/
- 구독: https://youtube.com/feed/subscriptions

> 위젯은 텍스트 입력이 안 되어서(위젯 구조 제약) 검색바는 “검색 화면으로 이동” 버튼 역할로 구현됨.
