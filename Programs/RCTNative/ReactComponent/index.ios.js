'use strict';

import React from 'react';
import IntervalPlay from './IntervalPlay.js'
import {
  AppRegistry,
  StyleSheet,
  Text,
  View
} from 'react-native';

var styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: 'white',
    alignItems:'center'
  }
});

class SimpleApp extends React.Component {
  render() {
    return (
      <View style={styles.container}>
        <IntervalPlay style={styles.container}></IntervalPlay>
        <Text style={styles.container}>this is a test</Text>
      </View>
    )
  }
}

AppRegistry.registerComponent('SimpleApp', () => SimpleApp);
