import React from 'react';
import { createRoot } from 'react-dom/client';
import App from './App';
import { LanguageProvider } from './core/i18n';
import { StoreProvider } from './app/store';
import { ToastProvider } from './core/components/Toast';
import './styles.css';

createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <LanguageProvider>
      <StoreProvider>
        <ToastProvider>
          <App />
        </ToastProvider>
      </StoreProvider>
    </LanguageProvider>
  </React.StrictMode>,
);
