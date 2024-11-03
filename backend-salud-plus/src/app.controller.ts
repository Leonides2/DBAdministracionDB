import { Body, Controller, Param, Post } from '@nestjs/common';
import { DatabaseService } from './app.service';
import { ApiProperty } from '@nestjs/swagger';

class QueryDto { 
  @ApiProperty()
  sqlQuery: string 
  @ApiProperty()
  user: string
  @ApiProperty()
  password: string 
};

class LoginDto {
  @ApiProperty()
  user: string
  @ApiProperty()
  password: string
}

@Controller('database')
export class DatabaseController {
  constructor(private readonly databaseService: DatabaseService) {}

  @Post('query')
  async executeQuery(@Body() body: QueryDto) {
    const { sqlQuery, user, password } = body;
    const pool = await this.databaseService.connect(user, password);
    if (!pool) {
      return {
        status: "Failure",
        msg: "Invalid connection"
      }
    }
    else {
      try {
        const result = await pool.request().query(sqlQuery);
        return {
          status: "Success",
          recordset: result.recordset
        }
      } catch(error) {
        return {
          status: "Failure",
          msg: error.originalError.info.message
        }
      } finally {
        await this.databaseService.disconnect();
      }
    }
  }

  @Post('login')
  async logIn(@Body() body : LoginDto) {
    const { user, password } = body;
    
    console.log(user, password)
    const pool = await this.databaseService.connect(user, password);
    if (!pool) {
      return {
        status: "Failure"
      }
    } else {
      await this.databaseService.disconnect();
      return {
        status: "Success"
      }
    }
  }
}