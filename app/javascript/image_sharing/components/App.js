import React, { Component } from 'react';
import Header from './Header';
import Footer from './Footer';
import FeedbackForm from './FeedbackForm';

class App extends Component {
  /* Add Prop Types check*/
  render() {
    return (
      <div>
        <Header title='Tell us what you think' />
        /* Put your components here: Flash Message, Form, Footer */
        <FeedbackForm />
        <Footer />
      </div>
    );
  }
}

export default App;
