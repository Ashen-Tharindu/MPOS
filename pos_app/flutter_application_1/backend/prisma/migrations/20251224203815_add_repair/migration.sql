-- CreateEnum
CREATE TYPE "RepairStatus" AS ENUM ('PENDING', 'IN_PROGRESS', 'COMPLETED');

-- CreateTable
CREATE TABLE "Repair" (
    "id" SERIAL NOT NULL,
    "customer" TEXT NOT NULL,
    "product" TEXT NOT NULL,
    "issue" TEXT NOT NULL,
    "status" "RepairStatus" NOT NULL DEFAULT 'PENDING',
    "cost" DOUBLE PRECISION NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Repair_pkey" PRIMARY KEY ("id")
);
