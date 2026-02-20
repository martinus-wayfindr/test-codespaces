import express, { Express, Request, Response } from 'express';

const app: Express = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(express.json());

// Routes
app.get('/', (req: Request, res: Response) => {
  res.send('Welcome to TypeScript HTTP Server!');
});

app.get('/api/hello', (req: Request, res: Response) => {
  const name = req.query.name || 'World';
  res.json({ message: `Hello, ${name}!` });
});

app.post('/api/data', (req: Request, res: Response) => {
  const data = req.body;
  res.json({ received: data, timestamp: new Date().toISOString() });
});

// Error handling
app.use((req: Request, res: Response) => {
  res.status(404).json({ error: 'Route not found' });
});

// Start server
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
