import { render, screen } from '@testing-library/react';
import App from './App';

test('title is set', () => {
  render(<App />);
  const title = screen.getByText("GetWise");
  expect(title).toBeInTheDocument();
});

test('reload button exists', () => {
  render(<App />);
  const reloadButton = screen.getByText("Reload");
  expect(reloadButton).toBeInTheDocument();
});
