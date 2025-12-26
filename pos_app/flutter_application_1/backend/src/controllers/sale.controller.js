import prisma from "../../prisma/client.js";

export const createSale = async (req, res) => {
  try {
    const { productId, quantity } = req.body;

    // 1. Find product
    const product = await prisma.product.findUnique({
      where: { id: productId },
    });

    if (!product) {
      return res.status(404).json({ error: "Product not found" });
    }

    // 2. Check stock
    if (product.stock < quantity) {
      return res.status(400).json({ error: "Insufficient stock" });
    }

    // 3. Create sale
    const sale = await prisma.sale.create({
      data: {
        productId,
        quantity,
        total: product.price * quantity,
      },
    });

    // 4. Reduce stock
    await prisma.product.update({
      where: { id: productId },
      data: {
        quantity: product.quantity - quantity,
      },
    });

    res.status(201).json({
      message: "Sale completed",
      sale,
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
