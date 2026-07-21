# Mini Course Player App

A Flutter application developed as my technical assessment submission for the Mobile Engineering Intern role at Almentor.

The application allows users to browse a collection of e-learning courses, track their watching progress, and automatically resume video playback from where they left off.

## Features

- Course Catalog: Displays available courses with thumbnails, titles, durations, and progress indicators.
- Resume Playback: Persists video playback positions locally and automatically seeks to the saved timestamp when reopened.
- State Management: Built using Bloc/Cubit following clean MVVM architecture.
- Dependency Injection: Powered by GetIt for separation of concerns and simplified testability.
- Error Handling: Handles video loading states and network/media errors gracefully.
- Automated Testing: Contains unit tests for Cubit state management and widget tests for the UI.

## Architecture and Decision Rationale

### State Management (MVVM + Cubit)
I selected Cubit because it provides a predictable and lightweight state management flow with minimal boilerplate. It cleanly separates the UI layer from business logic, adhering strictly to MVVM principles.

I followed a UI-first approach, where I designed and polished the presentation components first before wiring up the Cubit state management and persistent storage logic.

GetIt was used for dependency injection to keep repositories decoupled from the presentation layer, allowing me to easily inject fake repositories during unit and widget tests.

### Resume Playback Strategy
Playback progress is tracked by listening to the video player's position updates and persisting the timestamp (in seconds) and progress percentage to SharedPreferences. When a user opens a course, the app retrieves the saved position and seeks to that exact frame.

Trade-offs:
- Disk I/O: Saving progress frequently on player updates creates repeated disk writes. In a production environment, I would throttle or debounce these writes to execute every 3 to 5 seconds.
- Local Storage: SharedPreferences keeps data local to the device. Multi-device synchronization would require a remote API integration.

## AI Tools Disclosure

In accordance with the guidelines, I utilized AI assistance (Gemini / ChatGPT) during development for the following:
- Generating boilerplate code for unit and widget test files.
- Debugging test environment issues, such as resolving SharedPreferences channel bindings during test execution.

All AI-generated snippets were reviewed, refactored to fit my project architecture, and validated by running flutter test.

## Future Improvements

If I had more time, I would focus on the following enhancements:
1. Throttled Progress Saving: Implement a debouncer for disk writes during video playback to optimize I/O performance.
2. Offline Video Caching: Store video streams locally using flutter_cache_manager for offline playback support.
3. Expanded Controls: Add options for playback speed selection, auto-rotation, and full-screen mode.
4. Network Listener: Use connectivity_plus to notify users instantly when connection drops.

## Setup and Run Instructions

### Prerequisites
- Flutter SDK (Version >= 3.0.0)
- Dart SDK

### Steps

1. Clone the repository:
   git clone  https://github.com/Ezzatbalah/almentor_course_player.git
  


