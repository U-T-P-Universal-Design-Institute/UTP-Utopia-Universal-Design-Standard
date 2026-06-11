import SwiftUI

struct ChatView: View {
    let messages: [ChatMessage]
    let isStreaming: Bool

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(messages) { message in
                        MessageBubble(message: message)
                            .id(message.id)
                    }

                    if isStreaming {
                        TypingIndicator()
                            .id("typing")
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .onChange(of: messages.count) { _, _ in
                scrollToBottom(proxy: proxy)
            }
            .onChange(of: isStreaming) { _, _ in
                scrollToBottom(proxy: proxy)
            }
        }
    }

    private func scrollToBottom(proxy: ScrollViewProxy) {
        withAnimation(.easeOut(duration: 0.2)) {
            if isStreaming {
                proxy.scrollTo("typing", anchor: .bottom)
            } else if let last = messages.last {
                proxy.scrollTo(last.id, anchor: .bottom)
            }
        }
    }
}

struct MessageBubble: View {
    let message: ChatMessage

    var body: some View {
        switch message.role {
        case .user:
            userBubble
        case .assistant:
            assistantBubble
        case .thinking:
            thinkingBubble
        case .toolCall:
            toolCallBubble
        case .system:
            systemBubble
        }
    }

    private var userBubble: some View {
        HStack {
            Spacer(minLength: 48)
            Text(message.text)
                .font(.body)
                .foregroundStyle(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(CursorTheme.userBubble)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
    }

    private var assistantBubble: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "sparkles")
                .font(.caption)
                .foregroundStyle(CursorTheme.accent)
                .frame(width: 24, height: 24)
                .background(CursorTheme.accent.opacity(0.12))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(message.text.isEmpty && message.isStreaming ? "…" : message.text)
                    .font(.body)
                    .textSelection(.enabled)

                if message.isStreaming {
                    ProgressView()
                        .scaleEffect(0.7)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(CursorTheme.assistantBubble)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

            Spacer(minLength: 32)
        }
    }

    private var thinkingBubble: some View {
        HStack(spacing: 8) {
            Image(systemName: "brain.head.profile")
                .font(.caption)
                .foregroundStyle(.purple)
            Text(message.text)
                .font(.caption)
                .foregroundStyle(.secondary)
                .italic()
            Spacer()
        }
        .padding(.horizontal, 8)
    }

    private var toolCallBubble: some View {
        HStack(spacing: 8) {
            Image(systemName: message.toolStatus == "completed" ? "checkmark.circle.fill" : "gearshape.2.fill")
                .font(.caption)
                .foregroundStyle(message.toolStatus == "completed" ? .green : .orange)

            VStack(alignment: .leading, spacing: 2) {
                Text(message.toolName ?? "Tool")
                    .font(.caption.weight(.medium))
                Text(message.text)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(10)
        .background(Color(.tertiarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }

    private var systemBubble: some View {
        Text(message.text)
            .font(.caption)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
    }
}

struct TypingIndicator: View {
    @State private var phase = 0.0

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(CursorTheme.accent.opacity(0.6))
                    .frame(width: 6, height: 6)
                    .offset(y: sin(phase + Double(index) * 0.8) * 3)
            }
        }
        .padding(.leading, 40)
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear {
            withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                phase = .pi * 2
            }
        }
    }
}

struct ChatInputBar: View {
    @Binding var text: String
    let isSending: Bool
    let isStreaming: Bool
    let onSend: () -> Void
    let onCancel: () -> Void

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(alignment: .bottom, spacing: 12) {
            TextField("Ask the agent…", text: $text, axis: .vertical)
                .lineLimit(1...6)
                .focused($isFocused)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color(.tertiarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

            if isStreaming {
                Button(action: onCancel) {
                    Image(systemName: "stop.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.red)
                }
            } else {
                Button(action: onSend) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.title2)
                        .foregroundStyle(canSend ? CursorTheme.accent : .gray)
                }
                .disabled(!canSend)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(.bar)
    }

    private var canSend: Bool {
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isSending
    }
}
