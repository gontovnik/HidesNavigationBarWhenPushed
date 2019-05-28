# HidesNavigationBarWhenPushed

A library, which adds the ability to hide navigation bar when view controller is pushed via `hidesNavigationBarWhenPushed` flag.

**FYI: I use Apple internal API to make it work. Please remember that Apple might reject your app during app review process.**

## Context

While hacking on various projects, time to time I get designs where view controller A has navigation bar, and view controller B doesn't have it. It was always a pain to make it work. I decided to hack on that – and this is the result of that.

I hope that many people will find it useful too.

## Demo

### With interactive pop gesture recognizer

![](https://raw.githubusercontent.com/gontovnik/HidesNavigationBarWhenPushed/master/HidesNavigationBarWhenPushed1.gif)

### Regular push and pop

![](https://raw.githubusercontent.com/gontovnik/HidesNavigationBarWhenPushed/master/HidesNavigationBarWhenPushed2.gif)
![](https://raw.githubusercontent.com/gontovnik/HidesNavigationBarWhenPushed/master/HidesNavigationBarWhenPushed3.gif)

## Requirements
* Xcode 9 or higher
* iOS 11.0 or higher (may work on previous versions, just did not test it)
* ARC
* Swift 4.1

## Example project

Open and run the **HidesNavigationBarWhenPushedExample** project in Xcode to see **HidesNavigationBarWhenPushed** in action.

## Installation

### CocoaPods

``` ruby
pod 'HidesNavigationBarWhenPushed'
```

### Manual

Add **HidesNavigationBarWhenPushed** folder into your project.

## Usage

1. Use provided `NavigationController` instead of `UINavigationController`
2. Use provided `ViewController` instead of `UIViewController`
3. Use provided `NavigationBar` instead of `UINavigationBar` (make sure you specify this explicitly when using Interface Builder)

`ViewController` contains a single property you have to worry about: `hidesNavigationBarWhenPushed`.

If value on the new view controller is set to `true` and on the current view controller is set to `false`, then when new view controller is pushed, navigation bar will remain in the previous view controller. If value on the new view controller set to `false` and on the current view controller is set to `false`, then when new view controller is pushed, navigation bar will be present only in the new view controller, but not in the current.

If it sounds confusing, please see the demo above.

## Contributions

Contributions are always welcome!

## Contact

Danil Gontovnik

- https://github.com/gontovnik
- https://twitter.com/gontovnik
- http://gontovnik.com/
- danil@gontovnik.com

## License

The MIT License (MIT)

Copyright (c) 2018 Danil Gontovnik

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
