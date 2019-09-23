import { observable, computed, action } from 'mobx';

export class FeedbackStore {
  @observable feedbacks = [];

  @action
  addFeedback(feedback) {
    this.feedbacks.push(feedback);
  }

  @computed get report() {
    if (this.feedbacks.length === 0) {
      return '<none>';
    }
    return `Latest feedback: ${this.feedbacks[0].name}: ${this.feedbacks[0].comment}.\n` +
      `Number of feedback: ${this.feedbacks.length}`;
  }
}

export default FeedbackStore;
