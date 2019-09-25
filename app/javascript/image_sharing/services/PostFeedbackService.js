import { post } from '../utils/helper';

export function postFeedback(feedback) {
  return post('/api/feedbacks', feedback);
}
