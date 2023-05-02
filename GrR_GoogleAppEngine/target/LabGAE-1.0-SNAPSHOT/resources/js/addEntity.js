// Get references to the form and the lastAddedEntity div
const addEntityForm = document.getElementById('addEntityForm');
const lastAddedEntity = document.getElementById('lastAddedEntity');

// Add an event listener to submit the form
addEntityForm.addEventListener('submit', (e) => {
    e.preventDefault(); // Prevent the form from submitting normally

    // Send the form data to the server using the fetch api
    fetch('/datastorewrite?' + new URLSearchParams(new FormData(addEntityForm)), {
        method: 'GET'
    })
        .then((response) => response.json()).then((data) => {
            // Update the lastAddedEntity div with the returned data and show it
            lastAddedEntity.innerHTML = "<h2>Last Added Entity:</h2>" +
                "<p>Kind: " + data.kind + "</p>" +
                "<p>Key: " + data.key + "</p>" +
                "<ul>" + Object.entries(data.properties).map(
                    ([property, value]) => "<li>" + property.replace(
                        "_value", "Value") + ": " + value + "</li>").join('') + "</ul>";

            lastAddedEntity.style.display = 'block';
        })
        .catch((error) => {
            console.error('Error:', error);
        });
});