import 'dotenv/config'; // <-- garante leitura do .env antes de tudo
import { drizzle } from "drizzle-orm/node-postgres";
import { migrate } from "drizzle-orm/node-postgres/migrator";
import { Pool } from "pg";

if (!process.env.DATABASE_URL) {
  console.error("ERROR: process.env.DATABASE_URL is not defined. Check your .env and that dotenv is loaded.");
  process.exit(1);
}

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

const db = drizzle(pool);

async function main() {
  console.log("Running migrations...");
  await migrate(db, { migrationsFolder: "./drizzle" });
  console.log("Migrations completed!");
  await pool.end();
}

main().catch((err) => {
  console.error("Migration failed:", err);
  process.exit(1);
});