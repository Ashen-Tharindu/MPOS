import express from "express"
import cors from "cors"
import dotenv from "dotenv"
import authRoutes from "./routes/auth.routes.js";
import protectedRoutes from "./routes/protected.routes.js";


dotenv.config()
const app = express()

app.use(cors())
app.use(express.json())
app.use("/api/auth", authRoutes);
app.use("/api", protectedRoutes);

app.get("/", (req, res) => {
  res.send("POS Backend Running")
})

app.listen(process.env.PORT, () => {
  console.log(`Server running on port ${process.env.PORT}`)
})
