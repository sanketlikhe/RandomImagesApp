# RandomImagesApp

## Stage 1: API Integration
- Fetches entries from https://picsum.photos/v2/list
- Gets random images from API response.
- Network and UI layers separated cleanly.

## Stage 2: SwiftData Persistence
- Prevents duplicate saves with unique constraints
- Maintains user-defined sort order
- Reactive UI updates through Combine
- UserDefaults(But it's not ideal) was used because: 
    1. Quick to implement
    2. No additional setup required
    3. Works here as data set is not large/complex

## Stage 3: Complete UI
- Modern SwiftUI interface
- Add random image button with loading states
- AsyncImage for efficient image loading
- Delete functionality with swipe gestures
