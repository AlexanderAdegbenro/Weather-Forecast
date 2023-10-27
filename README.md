# Weather Forecast App

## Overview

The Weather Forecast app provides you with up-to-date weather information for your current location. It offers a visually pleasing user interface and displays both current weather conditions and a 5-day weather forecast.

## Features

- **Current Weather**: The main screen displays current weather conditions, including temperature, weather description, and an icon representing the weather.

- **5-Day Forecast**: The app also presents a daily forecast section showing the weather forecast for the next 5 days. Each forecast cell displays the date, a weather icon, and the temperature range.

- **Refresh**: You can manually update the weather data by using the pull-to-refresh gesture.

- **Smooth Animations**: Smooth transitions and animations have been implemented to enhance the user experience.

- **Loading Indicators**: During data retrieval, loading indicators provide visual feedback to the user, indicating that data is being fetched.

## Design Decisions

- **UI Framework**: The app is built using SwiftUI to create a visually pleasing and responsive user interface.

- **Data Parsing**: JSON responses from the API are parsed into Swift models, making it easy to work with the weather data.

- **Network Integration**: The app integrates with a free weather API, OpenWeatherMap, to fetch current weather conditions and the 5-day forecast for the user's location.

- **Error Handling**: Error handling is implemented to gracefully handle network request failures or data parsing errors.

## Challenges

- **Info.plist Mistake**: A challenge faced during development was mistakenly deleting the Info.plist file. It was later added back to ensure proper functionality.

- **Location Permissions**: Ensuring proper location permissions was another challenge. Initially, "Location When and Always in Use Description" was used, but it should have been "Location When in Use Usage Description."

## Installation and Usage

1. Clone this repository to your local machine.
2. Open the Xcode project.
3. Build and run the app on your simulator or physical device.

## Bonus Features (Already Implemented)

- **Unit Tests**: Unit tests have been added to ensure the correctness of networking and parsing code.

- **Animation Enhancements**: SwiftUI's built-in animation capabilities have been utilized to polish the user interface and provide a more interactive experience.


## Bonus Features (Not Yet Implemented)

- **Search Functionality**: A search functionality for users to search for weather in different locations has not been implemented yet.

Enjoy using the Weather Forecast app and stay informed about the weather in your area!
