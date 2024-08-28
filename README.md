
# `SwiftLog`

<!--@START_MENU_TOKEN@-->SwiftLog is a lightweight logging SDK designed for iOS applications. It provides a simple API for sending log messages to a remote server.<!--@END_MENU_TOKEN@-->

## Overview

<!--@START_MENU_TOKEN@-->SwiftLog offers a straightforward interface to log messages from your iOS application to a backend server. This SDK supports iOS 13.0 and later and is implemented as a Swift framework. It is easy to integrate and provides feedback on the success or failure of the log message delivery.<!--@END_MENU_TOKEN@-->

## Topics

### Integration

- `Importing SwiftLog`
- `Adding SwiftLog to Your Project`

### Logging

- `Logging a Message`
- `Handling Errors`

### Distribution

- `Generating the XCFramework`
  
---

## Integration

### `Importing SwiftLog`

<!--@START_MENU_TOKEN@-->To use `SwiftLog` in your project, first import the framework where you want to use its functionalities.<!--@END_MENU_TOKEN@-->

```swift
import SwiftLog
```

### `Adding SwiftLog to Your Project`

<!--@START_MENU_TOKEN@-->To integrate `SwiftLog` into your project, follow these steps:

1. Clone the repository or download the source code.
   ```bash
   git clone https://github.com/alexandresoli/SwiftLog.git
   cd SwiftLog
   ```

2. Drag and drop the `SwiftLog.xcodeproj` file into your Xcode project.

3. Go to your target's General settings and add `SwiftLog.framework` under the "Frameworks, Libraries, and Embedded Content" section.<!--@END_MENU_TOKEN@-->

## Logging

### `Logging a Message`

<!--@START_MENU_TOKEN@-->To log a message, use the `saveString` method provided by `SwiftLog`. This method sends a string to the server and handles success or failure via a completion handler.<!--@END_MENU_TOKEN@-->

```swift
SwiftLog.saveString("Your log message here") { result in
    switch result {
    case .success():
        print("Log message successfully sent.")
    case .failure(let error):
        print("Failed to send log message: \(error.localizedDescription)")
    }
}
```

### `Handling Errors`

<!--@START_MENU_TOKEN@-->The `saveString` method returns a `Result` type, which can be either `.success` or `.failure`. If an error occurs, the failure case provides an `Error` object that you can inspect to determine what went wrong.<!--@END_MENU_TOKEN@-->

## Distribution

### `Generating the XCFramework`

<!--@START_MENU_TOKEN@-->To generate a `.xcframework` for distribution, use the following steps:


# Create the XCFramework

1 - Make the script executable
```bash
chmod +x create_xcframework.sh
```

2. Run it:

```bash
./create_xcframework.sh
```
 This will generate the `.xcframework` in the root directory of the project.
 <!--@END_MENU_TOKEN@-->
