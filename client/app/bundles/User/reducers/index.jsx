// This file is our manifest of all reducers for the app.
// See also /client/app/bundles/User/store/userStore.jsx
// A real world app will likely have many reducers and it helps to organize them in one file.
// `https://github.com/shakacode/react_on_rails/tree/master/docs/additional_reading/generated_client_code.md`
import userReducer from './userReducer';
import { $$initialState as $$userState } from './userReducer';

export default {
  $$userStore: userReducer,
};

export const initalStates = {
  $$userState,
};
