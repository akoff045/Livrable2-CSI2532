document.getElementById("searchRooms").addEventListener("click", function() {
    fetch('/getAvailableRooms')
        .then(response => response.json())
        .then(data => {
            displayRooms(data); 
        })
        .catch(error => console.error('Erreur lors de la récupération des chambres:', error));
});

function displayRooms(rooms) {
    const roomList = document.getElementById("roomList");
    roomList.innerHTML = ""; 

    rooms.forEach(room => {
        const roomItem = document.createElement("div");
        roomItem.innerHTML = `
            <h3>${room.nom_hotel}</h3>
            <p>Capacité: ${room.capacity}</p>
            <p>Prix: ${room.prix}</p>
            <button onclick="bookRoom(${room.chambrel_ID})">Réserver</button>
        `;
        roomList.appendChild(roomItem);
    });
}

function bookRoom(roomId) {
    fetch(`/bookRoom/${roomId}`, { method: 'POST' })
        .then(response => {
            if (response.ok) {
                alert("Chambre réservée avec succès!");
            } else {
                alert("Erreur lors de la réservation de la chambre.");
            }
        })
        .catch(error => console.error('Erreur lors de la réservation de la chambre:', error));
}