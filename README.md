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

# What is LML

<p>LML is a collection of usefull tools that can help you build your Dart module/Flutter application</p>

<p>
It is divided in these 4 categories:
<ul>
  <li>Network</li>
  <li>Navigation</li>
  <li>StateManagement</li>
  <li>Utils</li>
</ul>

For each of these modules there are multiple common problem solutions and prebuilt tools as a <b>HTTPnetworkCommunicator</b> handling custom NetworkRequets and Responses.

</p>
<br>

# Getting started

Import the package using the standard import (checkout the "version" tab for more)

```yaml
dependencies:
  lml: ^1.0.2
```

<br>

# LML Modules

## Network

```dart
import 'package:lml/network.dart';
```

<p>
Import this module to use the prebuilt HTTP communicator with these customizable features:
</p>
<ul>
<li>CRUD Network Delegate</li>
Mixin doing basic HTTP requests
<li>Network Communicator</li>
Uses <b>CrudNetworkDelegate</b> to make HTTP requests defined by <b>Network Request</b> and </b>Network Response</b> classes.
<li>Network Request</li>
<li>Network Response</li>
<li>Pagination</li>
<li>Header generation</li>
<li>Token refreshing</li>
</ul>

## Utilities

```dart
import 'package:lml/utils.dart';
```

### TimeWrapper

<p>
Some classes that helps developers to manage the DateTime class wrapping it with common "time usage" as:
</p>
<ul>
  <li>Date</li>
  <li>TimeInDay</li>
  <li>Timestamp</li>
  <li>Intervals<ul></li>
  <li>DateInterval</li>
  <li>TimeInDay Interval</li>
  <li>Timestamp Interval</li></ul>
</ul>

It uses also the [Intl package](https://pub.dev/packages/intl) to support formatting using the correct format depending on device settings

## Navigation

```dart
import 'package:lml/navigation.dart';
```

<p>

A complete app navigation library that uses [BLoC libary](https://pub.dev/packages/flutter_bloc) to update its Navigation widget

</p>

It's all you need, just create at the root of your app a MaterialApp.router() and provide it a RootNavigationDelegate and AppRouteParser with the supported routes for your application

<br>

## State Management

```dart
import 'package:lml/bloc.dart';
```

<p>

Using the [BLoC libary](https://pub.dev/packages/flutter_bloc) will require some extra code to get it work properly on your application.<br>
For example mapping each [BlocState] to its widget rapresentation or listening to a particular state change.<br>
The LML <b>Bloc module</b> has some tools to help you with this task.

</p>

### BlocStateBuilder

Doc coming soom, please check the class definition for more information

### BlocStateListener

Doc coming soom, please check the class definition for more information

### ErrorBlocManager

Doc coming soom, please check the class definition for more information

### ErrorManagerListener

Doc coming soom, please check the class definition for more information

### Utilities

Doc coming soom, please check the class definition for more information

# Additional information

Leave a issue if something is wrong or wants improvements on something, i will take it into account
