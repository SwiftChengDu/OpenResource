'use strict'

import React,{ Component,PropTypes } from 'react';
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

import DMSwipeRow from './DMSwipeRow';
import ROW_DATAS from './MessageCenter.json';

class SimpleApp3 extends Component {
  constructor(props) {
    super(props);

    this._rows = {};
    this.openCellId = null;
    var dataSource = new ListView.DataSource({
      rowHasChanged:(row1,row2) => row1 !== row2
    });
    this.state = {
      dataSource:dataSource.cloneWithRows(ROW_DATAS),
    };
  }

  setScrollEnabled(enable) {
    this._listView.setNativeProps({scrollEnabled:enable});
  }

  safeCloseOpenRow() {
    if (this._rows[this.openCellId]) {
        this._rows[this.openCellId].closeRow();
    }
  }

  onScroll(evt) {
    if (this.openCellId) {
        if (this.props.closeOnScroll) {
            this.safeCloseOpenRow();
            this.openCellId = null;
        }
    }
    this.props.onScroll && this.props.onScroll(evt);
  }

  onRowOpen(id) {
    if (this.openCellId && this.openCellId !== id) {
        this.safeCloseOpenRow();
    }
    this.openCellId = id;
    this.props.onRowOpen && this.props.onRowOpen();
  }

  onRowPress(id) {
    if (this.openCellId) {
        if (this.props.closeOnRowPress) {
            this.safeCloseOpenRow();
            this.openCellId = null;
        }
    }
  }

  onRowClose() {

  }

  render() {
    return(
      <ListView
        {...this.props}
        ref = { lv => this._listView = lv }
        onScroll = { evt => this.onScroll(evt) }
        renderRow = { this.renderRow.bind(this) }
        dataSource = { this.state.dataSource }
        style={{flex:1}}
      />
    );
  }

  renderRow(rowData,sectionID,rowID) {
    return(
        <DMSwipeRow
          ref = {row => this._rows[`${sectionID}${rowID}`] = row}
          onRowOpen = { _ => this.onRowOpen(`${sectionID}${rowID}`)}
          onRowClose = { _ => this.onRowClose()}
          onRowPress = { _ => this.onRowPress(`${sectionID}${rowID}`)}
          setScrollEnabled = { (enable) => this.setScrollEnabled(enable)}
          leftOpenValue = {this.props.leftOpenValue}
          rightOpenValue = {this.props.rightOpenValue}
          closeOnRowPress = {this.props.closeOnRowPress}
          disableLeftSwipe = {this.props.disableLeftSwipe}
          disableRightSwipe = {this.props.disableRightSwipe}
          recalculateHiddenLayout = {this.props.recalculateHiddenLayout}
        >
          {this.renderHiddenRow(rowData,sectionID,rowID,this._rows)}
          {this.renderVisibleRow(rowData,sectionID,rowID,this._rows)}
        </DMSwipeRow>
    );
  }

  renderVisibleRow(rowData,sectionID,rowID,rowMap) {
    return (
      <TouchableHighlight onPress={() => {}} underlayColor='#dddddd'>
      <View style={styles.rowView}>
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
    );
  }

  renderHiddenRow(rowData,sectionID,rowID,rowMap) {
    return (
      <View style={styles.rowBack}>
          <Text style={{color:'white',textAlign:'center',marginRight:0}}>删除</Text>
      </View>
    );
  }
}

SimpleApp3.propTypes = {
  leftOpenValue:PropTypes.number,
  rightOpenValue:PropTypes.number,

  closeOnRowPress:PropTypes.bool,
  closeOnScroll:PropTypes.bool,
  disableLeftSwipe:PropTypes.bool,
  disableRightSwipe:PropTypes.bool,
  recalculateHiddenLayout:PropTypes.bool
};

SimpleApp3.defaultProps = {
  leftOpenValue:0,
  rightOpenValue:-75,
  closeOnScroll:true,
  closeOnRowPress:true,
  disableLeftSwipe:false,
  disableRightSwipe:true,
  recalculateHiddenLayout:false
};

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
    height:66,
    backgroundColor:'white'
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
  },
  //new
  rowBack: {
    alignItems: 'center',
		backgroundColor: 'red',
		flex: 1,
		flexDirection: 'row',
		justifyContent: 'space-between',
		paddingLeft: 15,
  },
  standalone: {
		marginTop: 50,
		marginBottom: 50,
    backgroundColor:'blue'
	},
	standaloneRowFront: {
		alignItems: 'center',
		backgroundColor: 'white',
		justifyContent: 'center',
		height: 50,
	},
	standaloneRowBack: {
		alignItems: 'center',
		backgroundColor: '#8BC645',
		flex: 1,
		flexDirection: 'row',
		justifyContent: 'space-between',
		padding: 15
	},
	backTextWhite: {
		color: 'black'
	}
});

AppRegistry.registerComponent('SimpleApp',() => SimpleApp3);
