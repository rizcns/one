import WidgetKit
import SwiftUI

private enum YouTubeLinks {
  static let home = URL(string: "https://youtube.com/")!
  static let shorts = URL(string: "https://youtube.com/shorts/")!
  static let subs = URL(string: "https://youtube.com/feed/subscriptions")!
  static let search = URL(string: "https://youtube.com/results?search_query=")!
}

struct SimpleEntry: TimelineEntry {
  let date: Date
}

struct Provider: TimelineProvider {
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date())
  }

  func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
    completion(SimpleEntry(date: Date()))
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
    // Widget UI is static; refresh occasionally.
    let entry = SimpleEntry(date: Date())
    let next = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date().addingTimeInterval(3600)
    completion(Timeline(entries: [entry], policy: .after(next)))
  }
}

private struct SearchBarView: View {
  var body: some View {
    Link(destination: YouTubeLinks.search) {
      HStack(spacing: 10) {
        ZStack {
          RoundedRectangle(cornerRadius: 8, style: .continuous)
            .fill(Color.red)
          Image(systemName: "play.fill")
            .font(.system(size: 12, weight: .bold))
            .foregroundStyle(.white)
        }
        .frame(width: 22, height: 22)

        Text("YouTube 검색")
          .font(.system(size: 14, weight: .semibold))
          .foregroundStyle(.primary)
          .lineLimit(1)

        Spacer(minLength: 0)

        Image(systemName: "mic.fill")
          .font(.system(size: 14, weight: .semibold))
          .foregroundStyle(.secondary)
      }
      .padding(.horizontal, 14)
      .padding(.vertical, 12)
      .background(
        RoundedRectangle(cornerRadius: 18, style: .continuous)
          .fill(.thinMaterial)
      )
      .overlay(
        RoundedRectangle(cornerRadius: 18, style: .continuous)
          .strokeBorder(.quaternary, lineWidth: 1)
      )
    }
    .buttonStyle(.plain)
  }
}

private struct TileLink: View {
  let title: String
  let systemImage: String
  let url: URL

  var body: some View {
    Link(destination: url) {
      VStack(spacing: 10) {
        Image(systemName: systemImage)
          .font(.system(size: 22, weight: .semibold))
          .foregroundStyle(.primary)
        Text(title)
          .font(.system(size: 13, weight: .semibold))
          .foregroundStyle(.primary)
          .lineLimit(1)
      }
      .frame(maxWidth: .infinity)
      .padding(.vertical, 18)
      .background(
        RoundedRectangle(cornerRadius: 16, style: .continuous)
          .fill(.thinMaterial)
      )
      .overlay(
        RoundedRectangle(cornerRadius: 16, style: .continuous)
          .strokeBorder(.quaternary, lineWidth: 1)
      )
    }
    .buttonStyle(.plain)
  }
}

struct YouTubeWidgetView: View {
  var body: some View {
    VStack(spacing: 12) {
      SearchBarView()
      HStack(spacing: 10) {
        TileLink(title: "홈", systemImage: "house", url: YouTubeLinks.home)
        TileLink(title: "Shorts", systemImage: "play.square", url: YouTubeLinks.shorts)
        TileLink(title: "구독", systemImage: "play.rectangle.on.rectangle", url: YouTubeLinks.subs)
      }
    }
    .padding(14)
  }
}

@main
struct MyYouTubeWidget: Widget {
  let kind: String = "MyYouTubeWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { _ in
      YouTubeWidgetView()
        .containerBackground(.fill.tertiary, for: .widget)
    }
    .configurationDisplayName("YouTube 바로가기")
    .description("YouTube 검색/홈/Shorts/구독 바로가기")
    .supportedFamilies([.systemMedium, .systemLarge])
  }
}
