<a id="readme-top"></a>

<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]


<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/SteveLeungYL/WaterTracker">
    <img src="https://github.com/SteveLeungYL/WaterTrackerSupplementaryMaterials/blob/main/AppIcon/AppIcon.png" alt="Logo" width="200" height="200">
  </a>

  <h3 align="center">Water Tracker for iOS, iPadOS & watchOS</h3>

  <p align="center">
    A simple Water Tracker application written in pure SwiftUI and SwiftData, syncs with HealthKit and CloudKit. 
    <br />
    <a href="https://github.com/SteveLeungYL/WaterTracker/issues/new?labels=bug&template=bug-report---.md">Report Bug</a>
    ·
    <a href="https://github.com/SteveLeungYL/WaterTracker/issues/new?labels=enhancement&template=feature-request---.md">Request Feature</a>
    <br />
    <br />
    <a href="https://apps.apple.com/us/app/pocket-water-tracker/id6738141744"><img src="https://developer.apple.com/assets/elements/badges/download-on-the-app-store.svg"></a>
  </p>
</div>

<!-- ABOUT THE PROJECT -->
## About The Project
This is my first time building one iOS/watchOS app using pure SwiftUI and SwiftData. The project is just for fun. Hopefully, it will benefit someone who wants to build a SwiftUI app on their own. 

The app is published in the App Store, completely free of charge. No subscription; no in-app purchase; and no ads!

Features:
+ Super simple & quick drink logging. 
+ Smart Water Reminder after 2 hours of each drink logging. NO REPEATED & ANNOYING reminders again and again. 
+ Water Summary with 24-hour view or weekly view. 
+ Data synced with, and only with CloudKit and HealthKit. No user data collected to me in any form. 
+ Flexible daily goal setup. 
+ Support both Milliliter and Ounce. 
+ Widgets for Home Screen. 
+ Deep integration with Apple Watch. 

<!-- Screenshots -->
## Screenshots

[Supplementary Materials repo](https://github.com/SteveLeungYL/WaterTrackerSupplementaryMaterials)

### iOS
<img src="https://github.com/SteveLeungYL/WaterTrackerSupplementaryMaterials/blob/main/ScreenShots%20and%20Previews/iPhone_6_9/ScreenShots%20and%20Previews/Slide3.png" width="200"> <img src="https://github.com/SteveLeungYL/WaterTrackerSupplementaryMaterials/blob/main/ScreenShots%20and%20Previews/iPhone_6_9/ScreenShots%20and%20Previews/Slide5.png" width="200"> <img src="https://github.com/SteveLeungYL/WaterTrackerSupplementaryMaterials/blob/main/ScreenShots%20and%20Previews/iPhone_6_9/ScreenShots%20and%20Previews/Slide7.png" width="200"> <img src="https://github.com/SteveLeungYL/WaterTrackerSupplementaryMaterials/blob/main/ScreenShots%20and%20Previews/iPhone_6_9/ScreenShots%20and%20Previews/Slide9.png" width="200"> <img src="https://github.com/SteveLeungYL/WaterTrackerSupplementaryMaterials/blob/main/ScreenShots%20and%20Previews/iPhone_6_9/ScreenShots%20and%20Previews/Slide11.png" width="200"> <img src="https://github.com/SteveLeungYL/WaterTrackerSupplementaryMaterials/blob/main/ScreenShots%20and%20Previews/iPhone_6_9/ScreenShots%20and%20Previews/Slide13.png" width="200">

### iPadOS
<img src="https://github.com/SteveLeungYL/WaterTrackerSupplementaryMaterials/blob/main/ScreenShots%20and%20Previews/iPad_13/ScreenShots%20and%20Previews/Slide3.png" width="49%"> <img src="https://github.com/SteveLeungYL/WaterTrackerSupplementaryMaterials/blob/main/ScreenShots%20and%20Previews/iPad_13/ScreenShots%20and%20Previews/Slide5.png" width="49%">

### watchOS
<img src="https://github.com/SteveLeungYL/WaterTrackerSupplementaryMaterials/blob/main/ScreenShots%20and%20Previews/Apple_Watch_Series_9/1.PNG" width="200"> <img src="https://github.com/SteveLeungYL/WaterTrackerSupplementaryMaterials/blob/main/ScreenShots%20and%20Previews/Apple_Watch_Series_9/2.PNG" width="200"> <img src="https://github.com/SteveLeungYL/WaterTrackerSupplementaryMaterials/blob/main/ScreenShots%20and%20Previews/Apple_Watch_Series_9/3.PNG" width="200">

<!-- ROADMAP -->
## Roadmap

- [x] iOS app.
- [x] iPad compatibility.
- [x] watchOS app.
- [x] Widgets using WidgetKit.
  - [x] iOS
  - [x] watchOS
- [x] Water Wave animation. 
- [x] Charts. 
  - [x] 24-hour view
  - [x] weekly view
- [x] WCSession (iOS & watchOS communication)
- [x] Water Reminder Local Notification
- [x] Double Tap on watchOS to trigger drink water. 
- [x] App Store Released. ⭐️ 
- [x] Show Empty Data or need refresh if the widget gets empty input. 
- [x] (Bug) Widget data is out of sync if another device updates the HealthKit data. How do I correctly propagate HealthKit data when the app is not active, or even worse, when the device is locked?
    - [x] (Partial Fix) Show data empty and prompt the user to enter the app for widget refresh. 
- [x] Custom reminder interval. 
- [ ] (Bug) Non-main thread modifying SwiftUI contents in Summary View. Not sure how.  
- [ ] Do not disturb within sleep time. 
- [ ] (Bug) The HealthKit data is not presented correctly in the first launch of the app.
- [ ] The current CupView and SummaryView are a bit too complex. Divide them into smaller subviews.
- [ ] A better `.accessoryCorner` widget, different than `.accessoryCircular`.  
- [ ] Swipe to drink (swipe on the CupView to trigger drink button, better with animations).
- [ ] App Intents.
  - [ ] Siri Integration.
  - [ ] Shortcuts Integration.
- [ ] Unexpectedly high performance/power consumption on the wave animation (optimization).
- [ ] Wave animation glitches at the start of the application.
  - [x] Partially avoided by uplift `waveOffset` to parent view (not ideal). 
- [ ] Fix the widget recommendation name being the same for all widgets. 

See the [open issues](https://github.com/SteveLeungYL/WaterTracker/issues) for a full list of proposed features and known issues.

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- CONTRIBUTING -->
## Contributing

Contributing is welcome, but I might not have enough time to update this app frequently. Feel free to fork this repo and implement your own features. And give me a pull request if you like. 

<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTACT -->
## Contact

Yu Liang - [GitHub](https://github.com/SteveLeungYL) - [HomePage](https://steveleungyl.github.io) - yuliang@psu.edu

Project Link: [WaterTracker](https://github.com/SteveLeungYL/WaterTracker)

```
@misc{LiangYuApple2024,
  author = {Liang, Yu},
  title = {WaterTracker},
  year = {2024},
  publisher = {GitHub},
  journal = {GitHub repository},
  howpublished = {\url{https://github.com/SteveLeungYL/WaterTracker}},
}
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

* [Wave Animation: RedDragonJ/Swift-Learning](https://github.com/RedDragonJ/Swift-Learning/tree/main/Animations/Animations/Animations)
* [Cleveland Clinic. (2024, October 3). How much water you should drink every day.](https://health.clevelandclinic.org/how-much-water-do-you-need-daily)
* [arthurkahwa/healthkit_showcase](https://github.com/arthurkahwa/healthkit_showcase)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/SteveLeungYL/WaterTracker?style=for-the-badge
[contributors-url]: https://github.com/SteveLeungYL/WaterTracker/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/SteveLeungYL/WaterTracker?style=for-the-badge
[forks-url]: https://github.com/SteveLeungYL/WaterTracker/network/members
[stars-shield]: https://img.shields.io/github/stars/SteveLeungYL/WaterTracker?style=for-the-badge
[stars-url]: https://github.com/SteveLeungYL/WaterTracker/stargazers
[issues-shield]: https://img.shields.io/github/issues/SteveLeungYL/WaterTracker?style=for-the-badge
[issues-url]: https://github.com/SteveLeungYL/WaterTracker/issues
[license-shield]: https://img.shields.io/github/license/SteveLeungYL/WaterTracker?style=for-the-badge
[license-url]: https://github.com/SteveLeungYL/WaterTracker/blob/main/LICENSE.txt
