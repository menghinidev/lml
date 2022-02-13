<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

## Features

### TimeWrapper

<p>
Some classes that helps developers to manage the DateTime class wrapping it with common "time usage" as:
</p>
<ul>
  <li>Date</li>
  <li>Time In Day</li>
  <li>Timestamp</li>
  <li>Intervals<ul></li>
  <li>Date Interval</li>
  <li>Time In Day Interval</li>
  <li>Timestamp Interval</li></ul>
</ul>
<br><br>
It uses also the [Intl package](https://pub.dev/packages/intl) to support formatting using the correct format depending on device settings
</p>

It uses also the [Intl package](https://pub.dev/packages/intl) to support formatting using the correct format depending on device settings

### BasicNavigation

A complete app navigation library that uses BLoC pattern to update its Navigation widget

```dart
import 'package:lml/navigation.dart';
```

It's all you need, just create at the root of your app a MaterialApp.router() and provide it a RootNavigationDelegate and AppRouteParser with the supported routes for your application

### Utils

<p> Some classes i found useful to have in some context (identifiers, cachevalues, responses, more..) </p>

### Network

<p> Doc coming soon, just import

```dart
import 'package:lml/network.dart';
```

to access CRUD network delegates and more utilities object (Pagination, NetworkResponse, more..) </p>

## Getting started

Import the package using the standard import (checkout the "version" tab for more)

```yaml
dependencies:
  lml: ^1.0.2
```

## Additional information

Leave a issue if something is wrong or wants improvements on something, i will take it into account
