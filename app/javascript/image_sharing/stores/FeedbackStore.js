import { observable, action, computed } from 'mobx';
import { postFeedback } from '../services/PostFeedbackService';

export class FeedbackStore {
  @observable submitMessage = {
    status: '',
    text: ''
  };

  @observable name = '';
  @observable comment = '';

  @action
  updateSubmitMessage = (status, text) => {
    this.submitMessage.status = status;
    this.submitMessage.text = text;
  };

  @action
  updateName = (event) => {
    this.name = event.target.value;
  };

  @action
  updateComment = (event) => {
    this.comment = event.target.value;
  };

  @action.bound
  submitFeedback(e) {
    e.preventDefault();
    postFeedback({ name: this.name, comment: this.comment }).then(() => {
      this.updateSubmitMessage('success', 'success');
    }).catch(() => {
      this.updateSubmitMessage('danger', 'Try again');
    });
  }

  @computed get displayFlashMessage() {
    return this.submitMessage.status;
  }
}

export default FeedbackStore;
