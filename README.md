# Hack-Challenge

**Name:** Big Red Bounty

**Tagline:** an app that allows users to make posts of lost items and offer rewards for users who find them

**Screenshots:**


<img width="239" alt="image" src="https://user-images.githubusercontent.com/67351739/205424422-62614e54-b5ad-4d39-bd96-0599beb627f4.png">     




<img width="241" alt="image" src="https://user-images.githubusercontent.com/67351739/205424768-d048e1bf-ee39-4542-acf7-cec4b2aedc9e.png">




<img width="264" alt="image" src="https://user-images.githubusercontent.com/67351739/205424777-07c3bd94-c3bf-4025-8318-ee14ae81658b.png">




<img width="236" alt="image" src="https://user-images.githubusercontent.com/67351739/205424791-c8dd3ca2-10be-4e98-9198-372e6c1d34c9.png">




<img width="239" alt="image" src="https://user-images.githubusercontent.com/67351739/205424796-cad6ff64-59b1-4dee-bf47-427cdcb0fd88.png">




<img width="248" alt="image" src="https://user-images.githubusercontent.com/67351739/205424803-cc934429-f533-40b4-b5ed-9218d5d09ae8.png">




<img width="242" alt="image" src="https://user-images.githubusercontent.com/67351739/205424845-965df05e-ff87-4613-855d-ab27682dfc4b.png">




<img width="239" alt="image" src="https://user-images.githubusercontent.com/67351739/205424854-770a5428-c157-4714-920d-890d9e60a2ae.png">




<img width="222" alt="image" src="https://user-images.githubusercontent.com/67351739/205424860-f894499b-3696-4eae-983c-3b8b4271a0b2.png">


**Description:** 
Ever lost a precious belonging and wished there was a way to get it back without walking all the way to Barton? Big Red Bounty is your solution! Users of our app can make posts for items they have lost, and offer a reward for someone who finds their belongings. This way, you can incentivize other people to help look for your lost items and make sure to find it. 

The app allows you to make a post with things like the item name, last known location, and description along with the option to enter a bounty to incentivize others to help you find the object. In the profile page, your lost items posts will be displayed in a list, and there is a message inbox component where you can be notified if someone discovers your item. In the homepage, any person can use the filter, searching, or sorting functions to narrow down the list. You can click on the cards on display, which will lead you to another view with information about the item and a button that lets you notify the owner.

**Requirements:**

_frontend:_
1. We used SwiftUI to layout the app with constraints.
2. We have SwiftUI equivalent of CollectionViews as a horizontal carousel on the homepage and a two column grid on the profile page.
3. We have sheets that are presented from buttons like the filter button on the homepage and the message inbox on the profile page.
4. The backened provided the framework for the creation of accounts in the sign up page and login with authentication. 

_backend:_
1. We have more than four routes, with some GET, some POST, and some DELETE
2. We have a user, claim, and item object ; the user and item table have a one-to-many relationship and the user and claim table have a one-to-many relationsihp
3. The API spec was uploaded to the google form
4. We implemented authentification using the example given in demo7. Some examples of protected endpoints include deleting items, updating items, and deleting a user. We also implemented images using the example given in demo8. The route is /api/upload/. 

_design:_
https://www.figma.com/file/TkvQaKNtEcRmGbtIjKZ6XH/Hack-challenge?node-id=142%3A35&t=usF1AB6BXSa1FSWd-1
