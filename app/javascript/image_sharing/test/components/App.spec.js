import React from 'react';
import { expect } from 'chai';
import App from '../../components/App';
import { shallow } from 'enzyme';
import FeedbackStore from '../../stores/FeedbackStore';
import { describe, it } from 'mocha';

describe('<App />', () => {
  let props;
  beforeEach(() => {
    props = {
      stores: {
        feedbackStore: new FeedbackStore()
      }
    };
  });

  it('should render correctly', () => {
    const component = shallow(<App {...props} />);
    const header = component.find('Header');
    const feedbackForm = component.find('Header');
    const footer = component.find('Header');
    expect(header).to.have.length(1);
    expect(feedbackForm).to.have.length(1);
    expect(footer).to.have.length(1);
  });
});
