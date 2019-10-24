import { expect } from 'chai';
import React from 'react';
import sinon from 'sinon';
import { beforeEach, afterEach, describe, it } from 'mocha';
import FeedbackStore from '../../stores/FeedbackStore';
import * as API from '../../services/PostFeedbackService';

describe('FeedbackStore', () => {
  let store;
  let sandbox;

  beforeEach(() => {
    sandbox = sinon.createSandbox();
    store = new FeedbackStore();
  });

  afterEach(() => {
    sandbox.restore();
  });

  it('should initialize correctly', () => {
    expect(store.submitMessage.status).to.equal('');
    expect(store.submitMessage.text).to.equal('');
    expect(store.name).to.equal('');
    expect(store.comment).to.equal('');
    expect(store.displayFlashMessage).to.equal('');
  });

  it('should update correctly', () => {
    store.updateSubmitMessage('test', 'test');
    expect(store.submitMessage.status).to.equal('test');
    expect(store.submitMessage.text).to.equal('test');
    expect(store.displayFlashMessage).to.equal('test');
    store.updateName({ target: { value: 'name' } });
    expect(store.name).to.equal('name');
    store.updateComment({ target: { value: 'comment' } });
    expect(store.comment).to.equal('comment');
  });

  it('should submit correctly', () => {
    const event = { preventDefault: sandbox.stub() };
    sandbox.stub(store, 'updateSubmitMessage');
    store.submitFeedback(event);
    expect(event.preventDefault.called);
    expect(API.postFeedback.called);
    expect(store.updateSubmitMessage.calledWith('success', 'success'));
  });

  it('should submit error message', () => {
    const event = { preventDefault: sandbox.stub() };
    sandbox.stub(store, 'updateSubmitMessage');
    sandbox.stub(API, 'postFeedback').returns(Promise.reject());
    store.submitFeedback(event);
    expect(event.preventDefault.called);
    expect(API.postFeedback.called);
    expect(store.updateSubmitMessage.calledWith('danger', 'Try again'));
  });
});
