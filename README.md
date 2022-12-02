# hack-challenge

**name:** Big Red Bounty

**tagline:** an app that allows users to make posts of lost items and offer rewards for users who find them

**screenshots:**

**description:** Ever lost a precious belonging and wished there was a way to get it back? Big Red Bounty is your solution! Users of our app can make posts for items they have lost, and offer a reward for someone who finds their belongings. This way, you can incentive other people to help look for your lost items and make sure to find it.

**requirements:**

_frontend:_
1. We have 1 UICollection View (Cards of lost items on home tab), and 1 UITableView (Cards of lost items on individual profile tab)
2. Present - When clicking on secure bounty button, when clicking on main filter button. 
3. Push - When navigating between tabs, when clicking on cards of lost items in both the home tab and the individual profile tab.
4. Integrated with backend API to enhance filter function. 

_backend:_
1. We have more than four routes, with some GET, some POST, and some DELETE
2. We have a user, claim, and item object ; the user and item table have a one-to-many relationship and the user and claim table have a one-to-many relationsihp
3. The API spec was uploaded to the google form
4. We implemented authentification using the example given in demo7. Some examples of protected endpoints include deleting items, updating items, and deleting a user. We also implemented images using the example given in demo8. The route is /api/upload/. 

_design:_
