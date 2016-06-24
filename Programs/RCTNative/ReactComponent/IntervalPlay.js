import React, { Component } from 'react';
import {
  StyleSheet,
  ScrollView,
  Image,
  Text,
  View
} from 'react-native';
import NativeMethodsMixin from 'NativeMethodsMixin';
var dataList = require('./IntervalPlay.json');
var SCREEN_WIDTH = require('Dimensions').get('window').width;

var styles = StyleSheet.create({
    container:{
      height:200
    },
    image:{
        width:SCREEN_WIDTH,
        height:200
    }
});

export default class IntervalPlay extends React.Component{

  constructor(props){
      super(props);
      this.intervalPlay = this.intervalPlay.bind(this);
      this.onScrollEnd = this.onScrollEnd.bind(this);
      this.state = {
         contentIndex:0
      }
  }


  intervalPlay(){
      this.state.contentIndex = (++this.state.contentIndex)%dataList.length;
      var offsetX = SCREEN_WIDTH*this.state.contentIndex;
      this.refs._sv.scrollTo({x:offsetX,y:0,animated:true});
  }

  componentDidMount(){
      setInterval(this.intervalPlay,2000);
  }

  onScrollEnd(event){

      var offsetX = event.nativeEvent.contentOffset.x

      var index = Math.round(offsetX/SCREEN_WIDTH);
      this.state.contentIndex = index;
  }

  render(){
    var elements = new Array();
    for(var i=0;i<dataList.length;i++){
      var data = dataList[i];
      var element = (
        <Image key={i} source={{uri:data.spImgUrl}} style={styles.image}/>
      );
      elements.push(element);
    }

    return (
      <ScrollView
      ref="_sv"
      onMomentumScrollEnd={this.onScrollEnd}
      style={styles.container}
      pagingEnabled={true}
      horizontal={true}
      automaticallyAdjustContentInsets={false}>
        {elements}
      </ScrollView>
    )
  }
}

module.exports = IntervalPlay;
