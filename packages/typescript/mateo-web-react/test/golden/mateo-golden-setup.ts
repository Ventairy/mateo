/// <reference types="vite/client" />
import 'mateo-web-react/styles.css';
import './mateo-golden.css';
import { afterEach } from 'vitest';
import { commands } from 'vitest/browser';
import { cleanup } from 'vitest-browser-react';
import { resetMateoGoldenCaptures } from './mateo-golden.js';

afterEach(async () => {
  resetMateoGoldenCaptures();
  await commands.mateoResetInput();
  await cleanup();
});
