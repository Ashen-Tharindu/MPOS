import express from "express";
import { PrismaClient } from "@prisma/client";
import { authMiddleware } from "../middleware/auth.middleware.js";

const router = express.Router();
const prisma = new PrismaClient();

/**
 * GET /api/dashboard?filter=today|yesterday|month
 * Returns detailed sales stats and low stock alerts
 */
router.get("/", authMiddleware, async (req, res) => {
  const filter = req.query.filter || "today"; // default to 'today'
  const now = new Date();
  let startDate, endDate;

  // Determine date range based on filter
  if (filter === "today") {
    startDate = new Date();
    startDate.setHours(0, 0, 0, 0);
    endDate = new Date();
    endDate.setHours(23, 59, 59, 999);
  } else if (filter === "yesterday") {
    startDate = new Date();
    startDate.setDate(startDate.getDate() - 1);
    startDate.setHours(0, 0, 0, 0);
    endDate = new Date();
    endDate.setDate(endDate.getDate() - 1);
    endDate.setHours(23, 59, 59, 999);
  } else if (filter === "month") {
    startDate = new Date(now.getFullYear(), now.getMonth(), 1);
    endDate = new Date(
      now.getFullYear(),
      now.getMonth() + 1,
      0,
      23,
      59,
      59,
      999
    );
  } else if (filter === "all") {
    startDate = undefined;
    endDate = undefined;
  } else {
    return res
      .status(400)
      .json({ error: "Invalid filter. Use today, yesterday, month, or all." });
  }

  try {
    // Fetch all sales in the period
    const sales = await prisma.sale.findMany({
      where:
        startDate && endDate
          ? { createdAt: { gte: startDate, lte: endDate } }
          : {},
      include: { product: true },
    });

    // Total sales amount
    const totalAmount = sales.reduce((sum, s) => sum + s.total, 0);

    // Product-wise sales summary
    const productWise = {};
    sales.forEach((s) => {
      if (!productWise[s.product.name]) {
        productWise[s.product.name] = {
          category: s.product.category,
          quantity: 0,
          total: 0,
        };
      }
      productWise[s.product.name].quantity += s.quantity;
      productWise[s.product.name].total += s.total;
    });

    // Low stock products (quantity < 5)
    const lowStock = await prisma.product.findMany({
      where: { quantity: { lt: 5 } },
    });

    // Response
    res.json({
      filter,
      totalSales: totalAmount,
      totalTransactions: sales.length,
      productWise,
      lowStockCount: lowStock.length,
      lowStockProducts: lowStock,
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Something went wrong" });
  }
});

export default router;
