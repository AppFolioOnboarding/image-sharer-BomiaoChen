import React, { Component } from 'react';
import { observer, inject } from 'mobx-react';

@inject('stores')
@observer
export default class FeedbackForm extends Component {
  nameRef = React.createRef();
  commentRref = React.createRef();

  createFeedback = (e) => {
    e.preventDefault();
    this.props.stores.feedbackStore.addFeedback({
      name: this.nameRef.current.value,
      comment: this.commentRref.current.value
    });
  }
  render() {
    return (
      <div>
        <div>
          { this.props.stores.feedbackStore.report }
        </div>
        <form className='feedback' onSubmit={this.createFeedback}>
          <div>
            <label htmlFor='name'>
              Your Name:
              <input name='name' ref={this.nameRef} type='text' placeholder='Name' />
            </label>
          </div>
          <div>
            <label htmlFor='comment'>
              Your Comment:
              <textarea name='comment' ref={this.commentRref} type='text' placeholder='Comments' />
            </label>
          </div>
          <button type='submit'>Send Feedback</button>
        </form>
      </div>
    );
  }
}
