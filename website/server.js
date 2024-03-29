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

const pool = new Pool({
  user: "postgres",
  host: "localhost",
  database: "csi2532",
  password: "V19des&D20",
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
        res.json({ success: true });
      } else {
        res.status(400).json({ success: false });
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


app.listen(3000, () => {
  console.log("Server is running on port 3000");
});
