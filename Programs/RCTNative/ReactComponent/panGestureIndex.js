'use strict'

import React,{ Component } from 'react';
import {
  View,
  AppRegistry,
  StyleSheet,
  PanResponder,
  ListView,
  TouchableHighlight,
  Text,
  Image
} from 'react-native';

var ROW_DATAS = require('./MessageCenter.json');

class SimpleApp3 extends Component {
  constructor(props) {
    super(props);
    var dataSource = new ListView.DataSource({
      rowHasChanged:(row1,row2) => row1 !== row2
    });
    this.state = {
      dataSource:dataSource.cloneWithRows(ROW_DATAS),
      deleteIndex:-1
    };
    this.contentOffsetY = 0;
    this._panResponder = PanResponder.create({
      onPanResponderTerminationRequest:(evt,gestureState) => true,
      onStartShouldSetPanResponder: () => true,
      onMoveShouldSetPanResponder: () => true,
      onPanResponderGrant: this._handlePanResponderGrant.bind(this),
      onPanResponderMove:this._handlePanResponderMove.bind(this),
      onPanResponderRelease: this._handlePanResponderEnd,
      onPanResponderTerminate: this._handlePanResponderEnd
    });
  }
  _handlePanResponderGrant(evt,gestureState) {

  }
  _handlePanResponderMove(evt, gestureState) {
    var currentX = gestureState.moveX;
    var currentY = gestureState.moveY+this.contentOffsetY;
    if (gestureState.dx < 0 && -gestureState.dx >= 20) {//向左移动
      var index = Math.floor(currentY/66);
        console.log(index);
        if (this.state.deleteIndex != -1) {
          return;
        }

        this.setState({
          deleteIndex:index
        });
    }else if (gestureState.dx > 0) {
        if (this.state.deleteIndex == -1) {
          return;
        }
        this.setState({
          deleteIndex:-1
        });
    }

    evt.nativeEvent
  }
  _handlePanResponderEnd() {
    console.log('end');
  }
  _onScroll(event) {
    this.contentOffsetY = event.nativeEvent.contentOffset.y;
  }
  render() {
    return(
      <ListView
        ref="_listView"
        onScroll={this._onScroll.bind(this)}
        renderRow={this.renderRow.bind(this)}
        dataSource={this.state.dataSource}
        style={{flex:1}}
      />
    );
  }
  renderRow(rowData,sectionID,rowID) {
    console.log(rowID);
    return(
        <View {...this._panResponder.panHandlers}>
        <TouchableHighlight onPress={() => {}} underlayColor='#dddddd'>
        <View style={[styles.rowView,rowID==this.state.deleteIndex?{backgroundColor:'red'}:{backgroundColor:'blue'}]}>
          <View style={styles.horizontalViewStyle}>
            <View style={styles.baseView}>
                <View style={styles.horizontalViewStyle}>
                  <Text style={styles.rowTitle}>{rowData.title}</Text>
                  <Text style={styles.rowTime}>{rowData.time}</Text>
                </View>
                <View style={styles.baseView}>
                  <Text style={styles.rowContent}>{rowData.content}</Text>
                </View>
            </View>
            <View style={styles.rowArrowView}>
              <Image source={require('image!row_detail_icon')}
                     style={styles.rowArrow}/>
            </View>
          </View>
          <View style={styles.rowSeparator}/>
        </View>
        </TouchableHighlight>
        </View>
    );
  }
}

var styles = StyleSheet.create({
  navBack: {
    height:64,
    backgroundColor: 'white',
    borderBottomWidth: 0.5,
    borderBottomColor: 'gray'
  },
  nav: {
    marginTop:20,
    height:44,
    alignItems:'center',
    flexDirection: 'row'
  },
  backImage: {
    marginLeft:16,
    width:10.5,
    height:17.5
  },
  title: {
    textAlign:'center',
    color:'black',
    fontSize:18,
    height:20,
    flex:1
  },
  rightBarBtn: {
    marginRight:16,
    textAlign:'center',
    color:'#ff741e',
    fontSize:14
  },
  controlView: {
    height:39.5,
    borderBottomColor:'#dddddd',
    borderBottomWidth:0.2,
    backgroundColor:'white',
    flexDirection:'row'
  },
  controlButton: {
    flex:1,
    marginLeft:9,
    alignSelf:'stretch',
    justifyContent:'center'
  },
  controlButtonSel: {
    borderBottomWidth:1,
    borderBottomColor:'#FF741F'
  },
  controlTextNor: {
    fontSize:14,
    textAlign:'center',
    color:'#666666'
  },
  controlTextSel: {
    fontSize:14,
    textAlign:'center',
    color:'#ff741e'
  },
  baseView: {
    flex:1
  },
  horizontalViewStyle: {
    flex:1,
    flexDirection:'row'
  },
  rowArrow: {
    width:8,
    height:12,
    alignSelf:'center'
  },
  rowArrowView: {
    width:38,
    justifyContent:'center'
  },
  rowView: {
    height:66
  },
  rowViewBackColorNor: {
    backgroundColor:'white'
  },
  rowViewBackColorSel: {
    backgroundColor:'#dddddd'
  },
  rowTitle: {
    flex:1,
    marginLeft:15,
    marginTop:12,
    fontSize:14,
    color:'#222222'
  },
  rowTime: {
    flex:1,
    textAlign:'right',
    marginTop:12,
    fontSize:12,
    color:'#999999'
  },
  rowContent: {
    marginLeft:15,
    fontSize:13,
    color:'#666666'
  },
  rowSeparator: {
    height:1,
    backgroundColor:'#dddddd'
  }
});

AppRegistry.registerComponent('SimpleApp',() => SimpleApp3);
