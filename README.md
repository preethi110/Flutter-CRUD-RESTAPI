Screen 1: User List

 1.Display a list of users fetched from the API "https://gorest.co.in/" using a GET request.
 2.Implemented pagination using the page and per_page parameters in the API.
 3.Display each user item with the user's name, email, and gender.
 4.Included an "Add" button at the top of the screen.
 5.Implemented "Edit" and "Remove" options for each user item.
 6.On pressing "Add," navigate to Screen 2 for adding a new user.
 
Screen 2: Add/Edit User Form

 1.Created a form to add a new user or edit an existing user.
 2.Included input fields for name, email, phone, status(used radio buttons), gender (used radio buttons), address, city, and state.
 3.Used device's location services (geolocator) to automatically populate latitude and longitude fields.
 4.Implemented validation for the form fields.
 5.For editing, if the user clicks on "Edit" on Screen 1, navigate to Screen 2 with pre-filled data.
 6.On pressing "Add" or "Update," use the respective API endpoint.
 
API Integration

 1.Implemented POST request functionality using the provided endpoint: "https://gorest.co.in/."
 2.Implemented PATCH request functionality using the provided endpoint: "https://gorest.co.in/{id}".
 3.Implemented DELETE request functionality to delete a user.
 
Additional Functionality

 1.After adding or updating a user, return to Screen 1 and display the updated user list without making another API call.
 2.For user deletion, ask for confirmation and, if confirmed, use the DELETE request to "https://gorest.co.in/{id}" to delete the user.
 3.After deletion, refresh the user list on Screen 1 without making another API call.
