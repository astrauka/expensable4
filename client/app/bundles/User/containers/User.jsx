import React, { PropTypes } from 'react';
import UserWidget from '../components/UserWidget';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import Immutable from 'immutable';
import * as userActionCreators from '../actions/userActionCreators';

function select(state) {
  // Which part of the Redux global state does our component want to receive as props?
  // Note the use of `$$` to prefix the property name because the value is of type Immutable.js
  return { $$userStore: state.$$userStore };
}

// Simple example of a React "smart" component
class User extends React.Component {
  static propTypes = {
    dispatch: PropTypes.func.isRequired,

    // This corresponds to the value used in function select above.
    $$userStore: PropTypes.instanceOf(Immutable.Map).isRequired,
  };

  constructor(props, context) {
    super(props, context);
  }

  render() {
    const { dispatch, $$userStore } = this.props;
    const actions = bindActionCreators(userActionCreators, dispatch);

    // This uses the ES2015 spread operator to pass properties as it is more DRY
    // This is equivalent to:
    // <UserWidget $$userStore={$$userStore} actions={actions} />
    return (
      <UserWidget {...{ $$userStore, actions }} />
    );
  }
}

// Don't forget to actually use connect!
// Note that we don't export User, but the redux "connected" version of it.
// See https://github.com/rackt/react-redux/blob/master/docs/api.md#examples
export default connect(select)(User);
