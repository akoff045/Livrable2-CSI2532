const express = require("express");
const cors = require("cors");
const app = express();

app.use(cors());
const { Pool } = require("pg");
const bodyParser = require("body-parser");

app.use(bodyParser.json());

const pool = new Pool({
  user: "postgres",
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

app.listen(3000, () => {
  console.log("Server is running on port 3000");
});
