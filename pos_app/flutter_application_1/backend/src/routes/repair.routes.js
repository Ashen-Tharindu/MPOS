import express from "express";
import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();
const router = express.Router();

// Create a repair
router.post("/", async (req, res) => {
  const { customer, product, issue, cost } = req.body;
  try {
    const repair = await prisma.repair.create({
      data: { customer, product, issue, cost },
    });
    res.json(repair);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Get all repairs
router.get("/", async (req, res) => {
  try {
    const repairs = await prisma.repair.findMany();
    res.json(repairs);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Update repair status
router.put("/:id", async (req, res) => {
  const { id } = req.params;
  const { status, cost, issue } = req.body;
  try {
    const repair = await prisma.repair.update({
      where: { id: parseInt(id) },
      data: { status, cost, issue },
    });
    res.json(repair);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Delete a repair
router.delete("/:id", async (req, res) => {
  const { id } = req.params;
  try {
    await prisma.repair.delete({ where: { id: parseInt(id) } });
    res.json({ message: "Repair deleted successfully" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

export default router;
