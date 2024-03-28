const express = require('express');
const cors = require('cors');
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
    "INSERT INTO personne (nas, nom, prenom) VALUES ($1, $2, $3)",
    [client.ssn, client.last, client.name],
    (error, results) => {
      if (error) {
        throw error;
      }
      res.status(200).json({ status: "success", message: "Client added." });
    }
  );
});

app.listen(5500, () => {
  console.log("Server is running on port 5500");
});
