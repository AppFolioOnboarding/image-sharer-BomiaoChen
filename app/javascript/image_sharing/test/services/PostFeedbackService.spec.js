import { postFeedback } from '../../services/PostFeedbackService';
import { expect } from 'chai';
import { describe, it, beforeEach } from 'mocha';
import nock from 'nock';

describe('PostFeedbackService', () => {
  let http

  beforeEach(() => {
    http = nock('https://example.appfolio.com')
      .post('/api/feedbacks', { name: 'name', comment: 'comment' })
      .reply(200, { message: 'thank you' });
  });

  it('makes a request to the API', () => {
    return postFeedback({ name: 'name', comment: 'comment' }).then(() => expect(http.isDone()).to.equal(true));
  });

  it('returns a promise for the returned result', () => {
    return postFeedback({ name: 'name', comment: 'comment' }).then(data => expect(data).to.deep.equal({ message: 'thank you' }));
  });
});
