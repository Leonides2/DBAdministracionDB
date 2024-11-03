
import { DataSource } from 'typeorm';

export const databaseProviders = [
  {
    provide: 'DATA_SOURCE',
    useFactory: async () => {
      const dataSource = new DataSource({
        type: 'mssql',
        host: 'localhost',
        port: 3306,
        username: 'root',
        password: 'root',
        database: 'SaludPlus',
        synchronize: true,
      });

      return dataSource.initialize();
    },
  },
];
