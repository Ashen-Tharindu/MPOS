import express from "express";
import { createSale } from "../controllers/sale.controller.js";
import { authMiddleware } from "../middleware/auth.middleware.js";

const router = express.Router();

router.post("/", authMiddleware, createSale);

export default router;
