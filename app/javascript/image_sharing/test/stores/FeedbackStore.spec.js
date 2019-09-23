import { expect } from 'chai';
import React from 'react';
import sinon from 'sinon';
import FeedbackStore from '../../stores/FeedbackStore';

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
    expect(store.feedbacks).to.deep.equal([]);
  });

  it('should add correctly', () => {
    store.addFeedback({ name: 'test' });
    expect(store.feedbacks).to.deep.equal([{ name: 'test' }]);
  });

  it('should report correctly', () => {
    expect(store.report).to.equal('<none>');
    store.addFeedback({ name: 'test', comment: 'comment' });
    expect(store.report).to.equal('Latest feedback: test: comment.\nNumber of feedback: 1');
  });
});
