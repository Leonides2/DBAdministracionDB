import { createRoot } from 'react-dom/client'
import { BrowserRouter as Router } from 'react-router-dom'
import App from './App.tsx'
import { QueryClient, QueryClientProvider } from 'react-query'
const client = new QueryClient();

createRoot(document.getElementById('root')!).render(
  
  <QueryClientProvider client={client}>
    <Router>
      <App />
    </Router>
  </QueryClientProvider>
)
