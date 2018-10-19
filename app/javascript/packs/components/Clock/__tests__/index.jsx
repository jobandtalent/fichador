import React from 'react';
import { shallow } from 'enzyme';
import Clock from '..';

describe('Clock', () => {
  const instance = shallow(<Clock />);

  it('renders a button for start the day', () => {
    const button = instance.find('button');
    expect(button).toHaveLength(1);
    expect(button.prop('type')).toEqual('button');
    expect(button.text()).toEqual('Comenzar');
  });
});
