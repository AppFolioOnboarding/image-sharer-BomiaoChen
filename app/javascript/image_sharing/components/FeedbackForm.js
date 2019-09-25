import React, { Component } from 'react';
import { observer, inject } from 'mobx-react';
import FlashMessage from './FlashMessage';

@inject('stores')
@observer
export default class FeedbackForm extends Component {
  render() {
    const { feedbackStore } = this.props.stores;
    const { name, comment, updateName, updateComment, submitFeedback, displayFlashMessage } = feedbackStore;
    return (
      <div>
        <div>
          { displayFlashMessage && <FlashMessage /> }
        </div>
        <form className='feedback'>
          <div>
            <label htmlFor='name'>
              Your Name:
              <input name='name' value={name} onChange={updateName} type='text' placeholder='Name' />
            </label>
          </div>
          <div>
            <label htmlFor='comment'>
              Your Comment:
              <textarea name='comment' value={comment} onChange={updateComment} type='text' placeholder='Comments' />
            </label>
          </div>
          <button onClick={submitFeedback}>Send Feedback</button>
        </form>
      </div>
    );
  }
}
