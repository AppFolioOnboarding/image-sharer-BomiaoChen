import React from 'react';
import { expect } from 'chai';
import FeedbackForm from '../../components/FeedbackForm';
import { shallow } from 'enzyme';
import { describe, it, beforeEach } from 'mocha';
import sinon from 'sinon';
import FlashMessage from '../../components/FlashMessage';

describe('<FeedbackForm />', () => {
  let props;
  beforeEach(() => {
    props = {
      stores: {
        feedbackStore: {
          submitMessage: {
            status: '',
            text: ''
          },
          name: '',
          comment: '',
          updateSubmitMessage: sinon.spy(),
          updateName: sinon.spy(),
          updateComment: sinon.spy(),
          submitFeedback: sinon.spy(),
        }
      }
    };
  });

  it('should render feedback form', () => {
    const component = shallow(<FeedbackForm {...props} />).dive();
    const form = component.find('form');
    expect(form).to.have.length(1);
    const labels = component.find('label');
    expect(labels).to.have.length(2);
    expect(labels.at(0).text()).to.equals('Your Name:');
    expect(labels.at(1).text()).to.equals('Your Comment:');
    const flashMessage = component.find('FlashMessage');
    expect(flashMessage).to.have.length(0);
  });

  it('should update the input', () => {
    const component = shallow(<FeedbackForm {...props} />).dive();
    const form = component.find('form');
    const input = form.find('input');
    input.simulate('change', { target: { value: 'name' } });
    expect(props.stores.feedbackStore.updateName.called);
    const textarea = form.find('textarea');
    textarea.simulate('change', { target: { value: 'comment' } });
    expect(props.stores.feedbackStore.updateComment.called);
  });

  it('should toggle the submit correctly', () => {
    const wrapper = shallow(<FeedbackForm {...props} />).dive();
    wrapper.find('button').simulate('click');
    expect(props.stores.feedbackStore.submitFeedback.called);
  });

  it('should toggle the submit correctly', () => {
    props = {
      stores: {
        feedbackStore: {
          submitMessage: {
            status: 'test',
            text: 'test'
          },
          name: '',
          comment: '',
          updateSubmitMessage: sinon.spy(),
          updateName: sinon.spy(),
          updateComment: sinon.spy(),
          submitFeedback: sinon.spy(),
          displayFlashMessage: 'test'
        }
      }
    };
    console.log(props.stores.feedbackStore.displayFlashMessage);
    const wrapper = shallow(<FeedbackForm {...props} />).dive();
    console.log(wrapper.debug());
    const flashMessage = wrapper.find('inject-FlashMessage-with-stores');
    expect(flashMessage).to.have.length(1);
  });
});
