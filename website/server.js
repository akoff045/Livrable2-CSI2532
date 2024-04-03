const express = require("express");
const cors = require("cors");
const app = express();

app.use(
  cors({
    origin: "http://127.0.0.1:5500",
    credentials: true,
  })
);

const { Pool } = require("pg");
const bodyParser = require("body-parser");

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));

const pool = new Pool({
  user: "",
  host: "localhost",
  database: "",
  password: "",
  port: 5432,
});

app.post("/create_client", (req, res) => {
  const client = req.body;

  pool.query(
    "SELECT * FROM client WHERE username = $1",
    [client.username],
    (error, results) => {
      if (error) {
        throw error;
      }

      if (results.rows.length > 0) {
        res
          .status(400)
          .json({ status: "error", message: "Username already exists." });
      } else {
        pool.query(
          "INSERT INTO address (num, street, city, province, country, code_post) VALUES ($1, $2, $3, $4, $5, $6) RETURNING address_id",
          [
            client.num,
            client.street,
            client.city,
            client.province,
            client.country,
            client.zip,
          ],
          (error, results) => {
            if (error) {
              throw error;
            }

            const addressId = results.rows[0].address_id;

            pool.query(
              "INSERT INTO personne (nas, prenom, nom, address_id) VALUES ($1, $2, $3, $4)",
              [client.ssn, client.name, client.last, addressId],
              (error, results) => {
                if (error) {
                  throw error;
                }

                pool.query(
                  "INSERT INTO client (nas, username, password, date_enrg) VALUES ($1, $2, $3, CURRENT_DATE)",
                  [client.ssn, client.username, client.password],
                  (error, results) => {
                    if (error) {
                      throw error;
                    }
                    res
                      .status(200)
                      .json({ status: "success", message: "Client added." });
                  }
                );
              }
            );
          }
        );
      }
    }
  );
});

let currentUser = null;

app.post("/login", (req, res) => {
  const { username, password } = req.body;

  pool.query(
    "SELECT * FROM client WHERE username = $1 AND password = $2",
    [username, password],
    (error, results) => {
      if (error) {
        throw error;
      }

      if (results.rows.length > 0) {
        currentUser = results.rows[0];
        res.json({ success: true, userType: "client" });
      } else {
        pool.query(
          "SELECT * FROM employe WHERE username = $1 AND password = $2",
          [username, password],
          (error, results) => {
            if (error) {
              throw error;
            }

            if (results.rows.length > 0) {
              currentUser = results.rows[0];
              res.json({ success: true, userType: "employee" });
            } else {
              res.status(400).json({ success: false });
            }
          }
        );
      }
    }
  );
});

app.get("/check-login", (req, res) => {
  if (currentUser) {
    res.json({ loggedIn: true });
  } else {
    res.json({ loggedIn: false });
  }
});

app.get("/logout", (req, res) => {
  currentUser = null;
  res.json({ success: true });
});

app.post("/book", function (req, res) {
  var startDate = req.body.startDate;
  var endDate = req.body.endDate;
  var hotel = req.body.hotel;
  var price = req.body.price;
  var capacity = req.body.capacity;
  var type = req.body.type;

  pool.query(
    "SELECT * FROM chambre WHERE hotel_id IN (SELECT hotel_id FROM hotel WHERE chaine_id = $1 AND rating <= $4) AND prix <= $2 AND capacity = $3 AND chambrel_id NOT IN (SELECT chambre_id FROM reservation WHERE date_start <= $6 AND date_end >= $5)",
    [hotel, price, capacity, type, startDate, endDate],
    function (err, result) {
      if (err) {
        console.log(err);
        res.status(500).send("Error in transaction");
      } else {
        res.send(result.rows);
      }
    }
  );
});

app.post("/book_employee", function (req, res) {
  var startDate = req.body.startDate;
  var endDate = req.body.endDate;
  var hotel = currentUser.hotel_id;
  var userNas = req.body.userNas;

  pool.query(
    "SELECT * FROM client WHERE nas = $1",
    [userNas],
    function (err, result) {
      if (err) {
        console.log(err);
        res.status(500).send("Error in transaction");
      } else if (result.rows.length === 0) {
        res.status(400).send("No client found with the provided NAS");
      } else {
        pool.query(
          "SELECT * FROM chambre WHERE hotel_id = $1 AND chambrel_id NOT IN (SELECT chambre_id FROM reservation WHERE date_start <= $3 AND date_end >= $2)",
          [hotel, startDate, endDate],
          function (err, result) {
            if (err) {
              console.log(err);
              res.status(500).send("Error in transaction");
            } else {
              res.send(result.rows);
            }
          }
        );
      }
    }
  );
});

app.post("/reserve", function (req, res) {
  var client_id = currentUser.id;
  var chambre_id = req.body.chambre_id;
  var date_start = req.body.date_start;
  var date_end = req.body.date_end;

  pool.query(
    "INSERT INTO reservation (client_id, chambre_id, date_start, date_end) VALUES ($1, $2, $3, $4)",
    [client_id, chambre_id, date_start, date_end],
    function (err, result) {
      if (err) {
        console.log(err);
        res.status(500).send("Error in transaction");
      } else {
        res.send(result.rows);
      }
    }
  );
});

app.post("/reserve_employee", function (req, res) {
  var userNas = req.body.userNas;
  var chambre_id = req.body.chambre_id;
  var date_start = req.body.date_start;
  var date_end = req.body.date_end;

  pool.query(
    "SELECT id FROM client WHERE nas = $1",
    [userNas],
    function (err, result) {
      if (err) {
        console.log(err);
        res.status(500).send("Error in transaction");
      } else {
        var client_id = result.rows[0].id;

        pool.query(
          "INSERT INTO reservation (client_id, chambre_id, date_start, date_end) VALUES ($1, $2, $3, $4)",
          [client_id, chambre_id, date_start, date_end],
          function (err, result) {
            if (err) {
              console.log(err);
              res.status(500).send("Error in transaction");
            } else {
              res.send(result.rows);
            }
          }
        );
      }
    }
  );
});

app.listen(3000, () => {
  console.log("Server is running on port 3000");
});
