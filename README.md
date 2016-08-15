# Fleks
Fleks is a workout builder app for iOS. 

From a database of canned exercises plus exercises you create yourself, you can create custom workouts with different rep/sets schemes and variations that you can use when you're at the gym. This was built for my Udacity iOS NanoDegree.

## Tools 
#### Built Using
1. Firebase for remote, offline storage, and authentication
2. FBSDK for login and authentication
3. Cocoapods for package management
4. XCode 7.3.1
5. Swift 2.2
6. ReactiveCocoa for some FRP goodness (still a noob and learning)
7. MVVM to avoid Fat Controllers 
8. Quick and Nimbe for some unit tests

## Build, Run, and Use
1. open Fleks.xcworkspace
2. Play in XCode
3. login with your Facebook account

## Tests
Test were made using Quick and Nimble. Run tests in test navigator.

## How to Use
### Login
#### Login via Facebook
<img src="https://github.com/paulsalinas/Fleks/blob/master/images/Login.png" width="400"/>

## Tab Interface
#### The main UI are two tabs 
1. Workouts - create, delete, and edit your workouts here! 
2. Exercises - create new exercises here!


## Exercise Tab
####  List of Exercises 
<img src="https://github.com/paulsalinas/Fleks/blob/master/images/Exercises%20Table.png" width="400"/>

####  Add new exercises by entering a name and selecting the muscles it targets!
<img src="https://github.com/paulsalinas/Fleks/blob/master/images/Exercise%20Form%20Selected.png" width="400"/>

## Workout Tab
####  List of Workouts 
<img src="https://github.com/paulsalinas/Fleks/blob/master/images/Workout%20Table.png" width="400"/>

#### Create a Workout - Enter a name and touch '+' to add your first exercise!
<img src="https://github.com/paulsalinas/Fleks/blob/master/images/Create%20Workout%20Form.png" width="400"/>

#### Select your first exercise 
<img src="https://github.com/paulsalinas/Fleks/blob/master/images/Select%20Exercise.png" width="400"/>

#### Enter the number of reps and sets plus any special notes or instructions 
<img src="https://github.com/paulsalinas/Fleks/blob/master/images/Exercise%20Form.png" width="400"/>

#### Cool there's validation!
<img src="https://github.com/paulsalinas/Fleks/blob/master/images/Validation.png" width="400"/>
#### you can keep entering exercises if you would like!

#### This workout was too hard, let's delete it!
<img src="https://github.com/paulsalinas/Fleks/blob/master/images/Delete%20Workout.png" width="400"/>

#### Ooh I can re-order my exercise order or delete by pressing 'Edit'!
<img src="https://github.com/paulsalinas/Fleks/blob/master/images/Edit%20Workout.png" width="400"/>

#### Selecting an exercise set allows you to edit it!
<img src="https://github.com/paulsalinas/Fleks/blob/master/images/Edit%20Exercise%20Set.png" width="400"/>

