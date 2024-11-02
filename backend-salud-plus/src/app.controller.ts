import { Body, Controller, Post } from '@nestjs/common';
import { DatabaseService } from './app.service';
import { DEFAULT_FACTORY_CLASS_METHOD_KEY } from '@nestjs/common/module-utils/constants';

@Controller('database')
export class DatabaseController {
  constructor(private readonly databaseService: DatabaseService) {}

  @Post('query')
  async executeQuery(@Body() body: { sqlQuery: string; user: string; password: string }) {
    const { sqlQuery, user, password } = body;
    try {
      const pool = await this.databaseService.connect(user, password);
      const result = await pool.request().query(sqlQuery);
      return result.recordset;
    } catch (error) {
      throw new Error(`Query failed: ${error.message}`);
    } finally {
      await this.databaseService.disconnect();
    }
  }

  @Post('login')
  async logIn(@Body() {user, password} : { user: string, password: string }) {
    try {
      const pool = this.databaseService.connect(user, password);
      return {
        status: "Success"
      };
    } catch {
      throw new Error("Failed to log in")
    }
  }
}