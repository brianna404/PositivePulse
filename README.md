# PositivePulse
## What is this about?

Receive only positive and neutral news from different blogs and news providers all in one place and filter for your interests. Note: at the moment you can only receive articles form the United States, but soon articles from german and english speaking countries will be avialable again. 

## Error handling

Due to a bug of XCode Version 15.4 after cloning this project there may accure an error `missing package product <package>`. If this is the case you can perform a workaround to run the project. Please open your terminal and follow this steps:

+ open your repository of the project by using `cd`:
    For example: `cd ~/Documents/MyProject`
+ then run the function `swiftpm` on the `Makefile` by using `make swiftpm`

The error should disappear and you should be able to run the app
