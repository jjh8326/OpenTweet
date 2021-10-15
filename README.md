OpenTweet
=========

Final note:
    Please just view the entire package via my final commit or the most recent in the main branch, I feel my best work was acheived after my final PR was merged. After reviewing the requirements one final time I realize that I missed dates having times so I redid my tweet cell layout and constraints to support time, as well as removed my twitter-esque time (RIP)

Known issues:
- The app should have a network detector and not attempt to download images if it does not have network connectivity, in that same thought this app is based off mock data but in the real world the data would be data downloaded from a server, so the whole app should not load if not connected to the internet.
- Changing the tweet timeline / tweet thread code to send the data over a notification broke the unit tests that tested TweetTimeline (as expected) but I needed to do this to fix an issue where the data was not loading.
- Sometimes the avatars on cells do not load on the first tap, I suspect this may be a simulator issue...

Future updates (if I had infinite time):
- I would like to implement a UILoading indicator for when the json and replies are loading
- I would like to implement UITesting, this would help me get more code coverage. The 50+% I have acheived is not ideal but I feel like it covers the majority of the non UI based code.
- I would like to animate the cells and views
- I would like to redo the constraints and make them code based so I can reuse them when need be and design the layout for a table view cell via code instead of interface builder (I know the duplicate table view is not ideal, I have learned alot doing this assignment and would not do that again - that is essentially making constraints hardcoded which is bad)
- I would like to add an error logging class that could be toggled on or off
- More time to proof read my code would have been great XD
- Finally, I would like to make the link in the tweet tappable

Notes:
- I do not squash commits and I also commit frequently, I try to have good commit messages.
- (I thought) Most of the base assignment was completed with commit 4dedc073ccd170bd852ed4b33db10d566ec8d2e4, after that you can check PRs to see how I implemented various bonus features.
    Update: Please just view the entire package via my final commit or the most recent in the main branch, I feel my best work was acheived after my final PR was merged.
- I have carefully tested this app with the simulator. I do not currently have an iPhone for testing :(
- As the code base grew bigger some bugs were introduced, I will try to address them but in the event that I do not I have tried my best to prevent crashing.

Original Content Below:

Hi! Welcome to your iOS coding excercise.

This is a very simple twitter like client. You'll find a json file under Data/ with a short tweet timeline. You are asked to write the app that will display the tweets, similar to what a Twitter client would do.

A tweet has at the minimum:

* An id
* An author
* A content (e.g. the actual tweet)
* A date (text format, in the standard ISO-8601 format)

Additionally, a tweet may have:

* A reference to the tweet ID it's replying to
* A URL to the user's avatar
* A list of image URLs

The timeline is a chronologically ordered (ascending order) list of tweets.

Since the topic is very simple, yet offers so many possibilities at the same time, there is a minimum requirement, and bonuses.

Minimum requirement
-------------------

* Fork the repo
* Parse the json file included in the project
* Display the tweets in the order the json file defines them. The app should display the author, the tweet and the date it was tweeted at. Tweets are variable length, so the cells must be properly sized to the content
* When done, send a pull request to this project (e.g don't email me your project :))

Keep in mind that the repo is public, so forking and sending a pull request will be shown in your public GitHub activity. If that doesn't work out for you for whatever reason, you can simply clone the repo locally, and submit your work back as a zip file to the recruiter.

Bonuses (in no particular order)
--------------------------------

* Highlight the mentions (@username) and/or links in a different font/color
* Display a tweet's thread when tapping on a giving tweet. Due to the very simplistic data model made available to you, it's probably best to simplify this: if the user taps on the first tweet of a thread, display all the replies in ascending chronological order, if the user taps on a reply to another tweet, only show the tapped tweet and the tweet it's replying to.
* Display avatar images (feel free to use AFNetworking/AlamoFire or just use NSURLSession for that)
* Animate/highlight a tweet when it is selected (e.g. make it "bigger", in an animated fashion)
* Anything else you might think of that showcases a UIKit feature: UIDynamics, parallax effect, the list is endless.

What the assignment will be judged on
-------------------------------------

* Accuracy of the result (e.g. is the cell sizing pixel perfect, dates are properly formatted, the app doesn't crash, project builds and runs with no extra step, etc.)
* Proper usage of UIKit apis (e.g. are cells properly reused, a back button must have a proper title, how well does it scale to various device sizes, etc.)
* Overall code quality: clarity, conciseness, quality of comments. Robustness and maintainability matter a lot more than clever one liners.
* If you end up short on time and/or can't fix a specific bug or finish a given feature, update this readme with what the bug is, and how you think you can fix had you more time.
* Bonuses are exactly that, bonuses. If you can complete one or more, good. Otherwise, don't sweat it
* If you can't complete something, explain why, how you reached that conclusion and potential options to complete it.

What the assignment will NOT be judged on
-----------------------------------------

* Visual design. This is a UI coding excercise, not a visual design excercise. 
* UI performance (e.g. framerate), as long as it's reasonable. Feel free to indicate in the code if/why something would affect the framerate, and a potential solution to it.
* If you try to complete a bonus and can't finish it, that's fine. I'd recommend using git commits/tags to indicate where the bonuses start in the history, so we can easily reset the branch at that commit and validate the minimum requirement.

Happy coding!
