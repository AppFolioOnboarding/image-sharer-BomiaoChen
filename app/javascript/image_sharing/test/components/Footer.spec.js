/* eslint-env mocha */

import Footer from '../../components/Footer';
import React from 'react';
import { shallow } from 'enzyme';
import { describe, it } from 'mocha';

const assert = require('assert');

describe('<Footer />', () => {
  it('should have copyright in footer', () => {
    const component = shallow(<Footer />);

    const div = component.find('div');
    assert.strictEqual(div.text(), 'Copyright: Appfolio Inc. Onboarding');
  });
});
