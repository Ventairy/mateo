/// <reference types="vite/client" />
import '@mateo/web-react/styles.css';
import './mateo-golden.css';
import { afterEach, beforeAll } from 'vitest';
import { commands } from 'vitest/browser';
import { cleanup } from 'vitest-browser-react';
import { resetMateoGoldenCaptures } from './mateo-golden.js';

beforeAll(async () => {
  await commands.mateoGroupViewport(1280, 900);
});

afterEach(async () => {
  resetMateoGoldenCaptures();
  await commands.mateoResetInput();
  await cleanup();
});
