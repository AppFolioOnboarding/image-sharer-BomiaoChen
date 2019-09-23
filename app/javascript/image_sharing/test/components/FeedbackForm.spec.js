import React from 'react';
import { expect } from 'chai';
import FeedbackForm from '../../components/FeedbackForm';
import { shallow } from 'enzyme';
import FeedbackStore from '../../stores/FeedbackStore';
import { describe, it } from 'mocha';
import sinon from 'sinon';

describe('<FeedbackForm />', () => {
  let props;
  beforeEach(() => {
    props = {
      stores: {
        feedbackStore: new FeedbackStore()
      }
    };
  });

  it('should render feedback form', () => {
    const onSubmit = sinon.spy();
    const component = shallow(<FeedbackForm {...props} onSubmit={onSubmit} />).dive();
    const form = component.find('form');
    expect(form).to.have.length(1);
    const labels = component.find('label');
    expect(labels).to.have.length(2);
    expect(labels.at(0).text()).to.equals('Your Name:');
    expect(labels.at(1).text()).to.equals('Your Comment:');
  });

  it('should toggle the submit correctly', () => {
    const wrapper = shallow(<FeedbackForm {...props} />).dive();
    wrapper.find('button').simulate('click');
    expect(props.stores.feedbackStore.addFeedback.called);
  });
});
