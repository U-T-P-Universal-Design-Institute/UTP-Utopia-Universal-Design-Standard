# UTP Utopia Universal Design Standard

本專案的 GitHub 倉庫。

> **沒有 Mac？** 請用 **Cursory**（App Store）管理此 repo，直接看下方「用手機管理此 Repo」。  
> **不必下載、不必編譯** `CursorMobile/` 資料夾——那個資料夾僅供有 Mac + Xcode 的開發者使用。

### 誰該用什麼？

| 你的情況 | 請這樣做 |
|----------|----------|
| 只有 iPhone，沒有 Mac | **Cursory** 管理此 repo（見下方步驟） |
| 有 Mac + Xcode | 可選用 `CursorMobile/` 自行編譯 App |
| 只想聊天寫文件、不動程式碼 | 用 Claude，不必開 Cursory |

---

## 用手機管理此 Repo（沒有 Mac 請從這裡開始）

用 **Cursory**（App Store）或 **Cursor 網頁版**，讓 AI 在雲端修改這個 GitHub 專案。

### 事前準備（做一次）

| 項目 | 說明 |
|------|------|
| Cursor 帳號 | 需能使用 Cloud Agent |
| GitHub 連線 | 開啟 [cursor.com/settings](https://cursor.com/settings) → 連接 GitHub → 授權本 repo |
| API Key | 同上頁面 → API Keys → 建立並複製 |
| Cursory App | App Store 搜尋 **Cursory** 並安裝（iOS 17+） |

**介面語言：** Cursory 支援英文／日文。iPhone「設定 → Cursory → 語言」可改為 English。

### 操作步驟

#### 1. 第一次連線

1. 開啟 Cursory
2. 貼上 Cursor **API Key**（不是 `run-` 或 `bc-` 開頭的 ID）
3. 完成 GitHub 授權（若 App 要求）

#### 2. 對本 repo 下任務

1. 點 **New Agent**
2. **Repository** 選 `U-T-P-Universal-Design-Institute/UTP-Utopia-Universal-Design-Standard`
3. **Branch** 選 `main`（或你要改的 branch）
4. 輸入任務，例如：

   ```
   更新 README：加入繁體中文的專案說明。
   不要修改 CursorMobile 資料夾。
   ```

5. 可勾選 **Auto-create PR**
6. 點 **Start**

#### 3. 執行中

- 查看 AI 回覆與進度
- 需要補充就輸入 follow-up
- 做錯了可 **Stop** 後重下指令

#### 4. 完成後

1. 在 agent 詳情找 **PR 連結**
2. 用 GitHub App 或 Safari 審核變更
3. 滿意 → **Merge**；不滿意 → 繼續下指令修改

### 任務撰寫範本

```
【目標】一句話說明要做什麼
【範圍】要改的檔案或功能（知道的話寫）
【語言】繁體中文
【限制】不要動哪些檔案
```

### 替代方案：Cursor 網頁版

1. Safari 開啟 [cursor.com/agents](https://cursor.com/agents)
2. 登入 Cursor 帳號（不用 API Key）
3. 分享 → **加入主畫面**

不需 API Key，但 iPhone 上穩定度較 Cursory 差。

---

## 本 Repo 裡有什麼

| 路徑 | 說明 | 你需要嗎？ |
|------|------|-----------|
| `README.md` | 本說明文件 | ✅ |
| `CursorMobile/` | 原生 iOS App 原始碼（Xcode 專案） | ❌ 沒有 Mac 可忽略 |

---

## CursorMobile 資料夾（僅限有 Mac 的開發者）

`CursorMobile/` 是 SwiftUI 原生 App 原始碼，**必須在 Mac 上用 Xcode 15+ 編譯**才能裝到 iPhone。

- 沒有 Mac → **請用 Cursory，不要用這個資料夾**
- 有 Mac 才需要：

  1. 開啟 `CursorMobile/CursorMobile.xcodeproj`
  2. 設定 Signing & Capabilities
  3. ⌘R 建置執行

技術細節見 [Cursor Cloud Agents API](https://cursor.com/docs/cloud-agent/api/endpoints)。

---

## 分支說明

目前**只使用 `main` 分支**作為主線。所有變更請針對 `main` 操作或開 PR 合併至 `main`。

---

## 常見問題

**Q：API Key 要貼哪裡？**  
A：Cursory App 的 onboarding 畫面，或 Cursor 網頁版用帳號登入即可。

**Q：`run-00000000-...` 是 API Key 嗎？**  
A：不是，那是 Run ID 範例，不能用來登入。

**Q：沒有 Mac 能管理這個 repo 嗎？**  
A：可以。安裝 Cursory，貼 API Key，選本 repo 下任務即可。

**Q：我能在手機上編譯 CursorMobile 嗎？**  
A：不能，需要 Mac + Xcode。沒有 Mac 請改用 Cursory。

**Q：只想跟 AI 聊天寫文件，不動 code？**  
A：用 Claude App 即可，不必開 Cursory。

---

## 授權

UTP Universal Design Institute 專案。
