# Contributing to IndieBuilderKit

Thanks for your interest in contributing!

## Development setup

- Xcode 15+ recommended (Swift 5.9+)
- iOS 17+ for the demo app

## Running the demo

Open:

- `Demo/IndieBuilderKitDemo.xcworkspace`

Build and run the `IndieBuilderKitDemo` target.

## Swift Package Manager

From the repo root:

```bash
swift package resolve
swift package build
```

## Pull requests

- Keep PRs focused (small, reviewable changes)
- Add/update documentation when changing public API
- Add tests when you can (especially for services like NetworkService)

## Code style

- Prefer modern Swift Concurrency (async/await)
- Keep public API surfaces documented

