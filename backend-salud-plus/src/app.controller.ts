import { Body, Controller, Post } from '@nestjs/common';
import { DatabaseService } from './app.service';
import { DEFAULT_FACTORY_CLASS_METHOD_KEY } from '@nestjs/common/module-utils/constants';

@Controller('database')
export class DatabaseController {
  constructor(private readonly databaseService: DatabaseService) {}

  @Post('query')
  async executeQuery(@Body() body: { sqlQuery: string; user: string; password: string }) {
    const { sqlQuery, user, password } = body;
    const pool = await this.databaseService.connect(user, password);
    if (!pool) {
      return {
        status: "Failure",
        msg: "Invalid connection"
      }
    }
    else {
      const result = await pool.request().query(sqlQuery);
      await this.databaseService.disconnect();
      return {
        status: "Success",
        recordset: result.recordset
      }
    }
  }

  @Post('login')
  async logIn(@Body() {user, password} : { user: string, password: string }) {
    const pool = await this.databaseService.connect(user, password);
    if (!pool) {
      return {
        status: "Failed login"
      }
    } else {
      return {
        status: JSON.stringify(pool)
      }
    }
  }
}