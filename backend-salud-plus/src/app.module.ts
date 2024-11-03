import { Module } from '@nestjs/common';
import { DatabaseController } from './app.controller';
import { DatabaseService } from './app.service';

@Module({
  imports: [],
  controllers: [DatabaseController],
  providers: [DatabaseService],
})
export class AppModule {}
