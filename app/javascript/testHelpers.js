/* eslint import/no-extraneous-dependencies: 1 */

import 'jsdom-global/register';
import jsdom from 'jsdom-global';
import Adapter from 'enzyme-adapter-react-16/build/index';
import { configure } from 'enzyme';

configure({ adapter: new Adapter() });

//
// Throw exceptions on unhandled promise rejections to prevent tests
// from silently failing async.
//
let unhandledRejection = false;
process.on('unhandledRejection', (reason, promise) => {
  console.error('unhandled rejection:', reason || promise); // eslint-disable-line no-console
  unhandledRejection = true;
  throw promise;
});
process.prependListener('exit', (code) => {
  if (unhandledRejection && code === 0) {
    process.exit(1);
  }
});

import fetch from 'node-fetch';

//
// Set up the DOM
//
jsdom(undefined, { url: 'https://example.appfolio.com' });

//
// Use the Fetch polyfill
//
global.fetch = fetch;
