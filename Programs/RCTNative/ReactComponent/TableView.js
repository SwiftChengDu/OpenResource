'use strict';

import React,{ Component } from 'react';
import {
  requireNativeComponent
} from 'react-native';

class TableView extends Component {
  constructor() {
    super()
    this._onClick = this._onClick.bind(this);
  }
  _onClick() {
    console.log('1111');
  }
  render() {
    return <RCTTable {...this.props} clickAtIndex={this._onClick}/>;
  }
}

TableView.propTypes = {
  rowHeight:React.PropTypes.number,
  selectIndex:React.PropTypes.number,
  clickAtIndex:React.PropTypes.func,
};

var RCTTable = requireNativeComponent('DMRCTTable',TableView);
module.exports = TableView;
