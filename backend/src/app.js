require("dotenv").config();
const express = require("express");
const helmet = require("helmet");
const cors = require("cors");

const sessionsRouter = require("./routes/sessions");
const plansRouter = require("./routes/plans");

const app = express();

app.use(helmet());
app.use(cors());
app.use(express.json());

app.use((err, _req, res, next) => {
  if (err instanceof SyntaxError && "body" in err) {
    return res.status(400).json({ error: "Invalid JSON request body" });
  }
  next(err);
});

app.get("/health", (_req, res) => res.json({ status: "ok" }));

app.use("/sessions", sessionsRouter);
app.use("/plans", plansRouter);

app.use((err, _req, res, _next) => {
  console.error(err);
  res.status(500).json({ error: "Internal server error" });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`IronmanApp API running on port ${PORT}`));
