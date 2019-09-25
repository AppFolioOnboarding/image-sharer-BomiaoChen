import React from 'react';
import { expect } from 'chai';
import FlashMessage from '../../components/FlashMessage';
import { shallow } from 'enzyme';
import { describe, it } from 'mocha';

describe('<FlashMessage />', () => {
  it('should render when message', () => {
    const props = {
      stores: {
        feedbackStore: {
          submitMessage: {
            status: 'success',
            text: 'text'
          }
        }
      }
    };
    const component = shallow(<FlashMessage {...props} />).dive();
    const alert = component.find('Alert');
    expect(alert).to.have.lengthOf(1);
  });
});
