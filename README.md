# PizzaSearch


##Installation

Don't forget to install pods. 

This app requires CocoaPods dependency manager. It automates and simplifies the process of using 3rd-party libraries. If you don't have it yet, you can get it by typing the following in your console:

``` sh
$ sudo gem install cocoapods
```

With CocoaPods up and running go to the application folder and install dependencies:

``` sh
$ cd PizzaSearch
$ pod install
```
Use `PizzaSearch.xcworkspace` to open the project.


##When you shouldn’t use UIStoryboards in iOS application

There are several reasons why we shouldn't  use storyboards. At first - this a file with a lot of controllers. And commit conflicts happen when several developers work with it. Next - every time (at each action) it creates new object of controller. Also some actions it is easier to write in code than setup in storyboard. 


##Explain your choice about saving places into Core Data

I chosen RESTkit framework for this project because it combines 3 important things - networking, object mapping and saving to core data. This framework is well suited for the task. Also I added NSFeatchedViewController to catch any data changes (UITableView works good in pair with this class).
