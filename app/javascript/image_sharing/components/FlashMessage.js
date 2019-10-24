import React, { Component } from 'react';
import { observer, inject } from 'mobx-react';
import { Alert } from 'reactstrap';

@inject('stores')
@observer
export default class FlashMessage extends Component {
  render() {
    return (
      <Alert color={this.props.stores.feedbackStore.submitMessage.status} >
        {this.props.stores.feedbackStore.submitMessage.text}
      </Alert>
    );
  }
}
