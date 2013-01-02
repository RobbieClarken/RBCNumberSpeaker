RBCNumberSpeaker
================

iOS class to speak numbers using pre-recorded sound files.

For example, "12345" will be spoken as "one thousand three hundred forty five".

Usage
-----

1. Add the `RBCNumberSpeaker` folder to your project
2. Add the `AVFoundation` framework to your project
3. Import `RBCNumberSpeaker.h`
4. Request numbers are spoken as follows:

```ObjectiveC
[[RBCNumberSpeaker sharedNumberSpeaker] speakNumber:12345];
```
