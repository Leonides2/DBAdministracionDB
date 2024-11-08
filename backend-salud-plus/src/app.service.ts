import { Injectable } from '@nestjs/common';
import * as sql from 'mssql';
import * as dotenv from 'dotenv';

dotenv.config();

@Injectable()
export class DatabaseService {
  private pool: sql.ConnectionPool | null = null;

  async connect(user: string, password: string): Promise<sql.ConnectionPool> {
    try {
      this.pool = await sql.connect({
        user,
        password,
        server: "localhost",
        database: "SaludPlus",
        options: {
          trustServerCertificate: true,
        },
      });
      return this.pool;
    } catch (error) {
      return null;
    }
  }

  async disconnect(): Promise<void> {
    if (this.pool) {
      await this.pool.close();
      console.log('Database connection closed');
    }
  }
}