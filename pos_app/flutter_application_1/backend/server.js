import express from "express"
import cors from "cors"
import dotenv from "dotenv"
import authRoutes from "./src/routes/auth.routes.js";
import protectedRoutes from "./src/routes/protected.routes.js";
import productRoutes from "./src/routes/product.routes.js";
import stockRoutes from "./src/routes/stock.routes.js";
import saleRoutes from "./src/routes/sale.routes.js";
import dashboardRoutes from "./src/routes/dashboard.routes.js";
import repairRoutes from "./src/routes/repair.routes.js";

dotenv.config()
const app = express()

app.use(cors())
app.use(express.json())
app.use("/api/auth", authRoutes);
app.use("/api", protectedRoutes);
app.use("/api/products", productRoutes);
app.use("/api/stock", stockRoutes);
app.use("/api/sales", saleRoutes);
app.use("/api/dashboard", dashboardRoutes);
app.use("/api/repairs", repairRoutes);


app.get("/", (req, res) => {
  res.send("POS Backend Running")
})

app.listen(process.env.PORT, () => {
  console.log(`Server running on port ${process.env.PORT}`)
})
