import prisma from "../../prisma/client.js";

export const getLowStockProducts = async (req, res) => {
  try {
    const LOW_STOCK_LIMIT = 5;

    const products = await prisma.product.findMany({
      where: {
        quantity: {
          lte: LOW_STOCK_LIMIT,
        },
      },
      orderBy: {
        quantity: "asc",
      },
    });

    res.status(200).json({
      count: products.length,
      products,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Failed to fetch low stock products" });
  }
};
