import React, { PropTypes } from 'react';
import Immutable from 'immutable';

export default class AboutPage extends React.Component {
  render() {
    return (
      <div>
        <p>
          Expensable is an application allowing you to share expenses with your
          friends with no effort or fees.
        </p>

        <h2>
          How to use it?
        </h2>

        <p>
          Once you eat luch with friends and pay for everybody all you need to do is:
        </p>

        <ul>
          <li>
            Create a new group and name it 'Company Lunch'
          </li>
          <li>
            Invite your friends to join the group
          </li>
          <li>
            Add the expense to the group where you all belong by choosing:
          </li>
          <ul>
            <li>
              Who paid
            </li>
            <li>
              How much spent
            </li>
            <li>
              Sharing with
            </li>
          </ul>
        </ul>
        <br />

        <p>
          The app will count the balances automatically and once you see that the
          friends owe you big ammount of money you can ask them to transfer you
          some such that you get back to balance.
        </p>

        <h2>
          News
        </h2>

        <p>
          <ul class="bold">
            <li>
              You can hide the expenses from the ones which are not involved
            </li>
          </ul>
        </p>

        <h2>
          Author
        </h2>

        <p>
          To contact the author please email me astrauka (at) gmail (dot) com.
        </p>
      </div>
    );
  }
}
