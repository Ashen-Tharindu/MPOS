import express from "express";
import { getLowStockProducts } from "../controllers/stock.controller.js";
import {authMiddleware} from "../middleware/auth.middleware.js";

const router = express.Router();

// GET low stock products
router.get("/low", authMiddleware, getLowStockProducts);

export default router;
